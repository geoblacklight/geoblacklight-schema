##
# Convert a Geoblacklight 1.0 schema record into a 2.0 JSON-LD record
# @param [Hash]
# @return [Hash]
def transform_record(record)
  ## Note: this is a LOSSY transform from GBL 1.0 -> 2.0 DCAT
  ## TODO: array / multivalue checking
  ## TODO: simple conversions of datetime to ISO 8601 (no '/' for separation of date components)

  dcat_record = {}
  dcat_record[:@context] = "https://raw.githubusercontent.com/geoblacklight/geoblacklight-schema/json-ld-schema/v2/schema/context.jsonld"
  dcat_record[:@id] = record.fetch('dc_identifier_s', nil)
  dcat_record[:@type] = "dcat:Dataset"
  dcat_record[:accessLevel] = record.fetch('dc_rights_s', nil)
  dcat_record[:creator] = record.fetch('dc_creator_sm', nil)
  dcat_record[:description] = record.fetch('dc_description_s', nil)
  dcat_record[:distribution] = []
  dcat_record[:geom] = record.fetch('solr_geom', nil)
  dcat_record[:geomType] = record.fetch('layer_geom_type_s', nil)
  dcat_record[:isPartOf] = record.fetch('dct_isPartOf_sm', nil)
  dcat_record[:issued] = record.fetch('dct_issued_s', nil)
  dcat_record[:landingPage] = nil
  dcat_record[:language] = record.fetch('dc_language_s', nil)
  dcat_record[:license] = nil
  dcat_record[:modified] = record.fetch('layer_modified_dt', nil)
  dcat_record[:provenance] = record.fetch('dct_provenance_s', nil)
  dcat_record[:publisher] = record.fetch('dc_publisher_s', nil)
  dcat_record[:resourceType] = record.fetch('dc_type_s', nil)
  dcat_record[:rights] = nil
  dcat_record[:slug] = record.fetch('layer_slug_s', nil)
  dcat_record[:source] = record.fetch('dc_source_sm', nil)
  dcat_record[:spatial] = record.fetch('dct_spatial_sm', nil)
  dcat_record[:subject] = record.fetch('dc_subject_sm', nil)
  dcat_record[:temporal] = record.fetch('dct_temporal_sm', nil)
  dcat_record[:title] = record.fetch('dc_title_s', nil)

  parsed_references = JSON.parse(record['dct_references_s'])

  parsed_references.each do |k,v|
    case k
    when "http://schema.org/downloadUrl" ## Direct-download URL
      dcat_record[:distribution] << generate_distribution_download(record['dc_format_s'], record['dc_format_s'], "application/octet-stream", v)
    when "http://schema.org/url" ## URL
      dcat_record[:landingPage] = v
    when "http://www.opengis.net/cat/csw/csdgm" ## FGDC metadata
      dcat_record[:distribution] << generate_distribution_download("FGDC Metadata", "FGDC", "application/xml", v, k)
    when "http://www.w3.org/1999/xhtml" ## HTML metadata
      dcat_record[:distribution] << generate_distribution_download("HTML Metadata", "HTML", "application/html", v, k)
    when "http://iiif.io/api/image" ## IIIF image
      dcat_record[:distribution] << generate_distribution_service(v, k, nil, ["JPG"])
    when "http://iiif.io/api/presentation#manifest" ## IIIF manifest
      dcat_record[:distribution] << generate_distribution_service(v, k)
    when "http://www.isotc211.org/schemas/2005/gmd/" ## ISO 19139 metadata
      dcat_record[:distribution] << generate_distribution_download("ISO 19139 Metadata", "ISO19139", "application/xml", v, k)
    when "http://www.loc.gov/mods/v3" ## MODS metadata
      dcat_record[:distribution] << generate_distribution_download("MODS Metadata", "MODS", "application/mods+xml", v, k)
    when "http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf" ## Shapefile (download?)
      dcat_record[:distribution] << generate_distribution_download("Shapefile", "Shapefile", "application/octet-stream", v, k)
    when "http://www.opengis.net/def/serviceType/ogc/wcs" ## WCS web service
      dcat_record[:distribution] << generate_distribution_service(v, k, record['layer_id_s'], [])
    when "http://www.opengis.net/def/serviceType/ogc/wfs" ## WFS web service
      dcat_record[:distribution] << generate_distribution_service(v, k, record['layer_id_s'], downloadable_formats(record['dc_format_s'],k))
    when "http://www.opengis.net/def/serviceType/ogc/wms" ## WMS web service
      dcat_record[:distribution] << generate_distribution_service(v, k, record['layer_id_s'], downloadable_formats(record['dc_format_s'],k))
    when "http://schema.org/DownloadAction" ## Harvard downloader
      dcat_record[:distribution] << generate_distribution_service(v, k, record['layer_id_s'])
    ## when "http://schema.org/UserDownloads" ## (Is this being used?)
    when "urn:x-esri:serviceType:ArcGIS#FeatureLayer" ## ESRI feature layer
      dcat_record[:distribution] << generate_distribution_service(v, k)
    when "urn:x-esri:serviceType:ArcGIS#TiledMapLayer"
      dcat_record[:distribution] << generate_distribution_service(v, k)
    when "urn:x-esri:serviceType:ArcGIS#DynamicMapLayer"
      dcat_record[:distribution] << generate_distribution_service(v, k)
    when "urn:x-esri:serviceType:ArcGIS#ImageMapLayer"
      dcat_record[:distribution] << generate_distribution_service(v, k)
    when "http://lccn.loc.gov/sh85035852" ## Data dictionary / codebook
      dcat_record[:describedBy] = v
    else
      puts "** Unknown key: #{k} **"
    end
  end

  raise 'Missing dc_identifier_s' unless dcat_record[:@id]
  raise 'Missing dc_rights_s' unless dcat_record[:accessLevel]
  raise 'Missing solr_geom' unless dcat_record[:geom]
  raise 'Missing dc_provenance_s' unless dcat_record[:provenance]
  raise 'Missing layer_slug_s' unless dcat_record[:slug]
  raise 'Missing dc_title_s' unless dcat_record[:title]

  dcat_record.delete_if { |k, v| v.nil? }
end

##
# Create default download types given a web service URI (contingent on format field)
# @param [String, String]
# @return [Array<String>]
def downloadable_formats(dc_format_s, webservice_uri)
  case dc_format_s
  when "Shapefile"
    formats = []
    if webservice_uri == "http://www.opengis.net/def/serviceType/ogc/wms"
      ["KMZ"]
    elsif webservice_uri == "http://www.opengis.net/def/serviceType/ogc/wfs"
      ["Shapefile", "GeoJSON"]
    end
  when "GeoTIFF", "ArcGRID"
    if webservice_uri == "http://www.opengis.net/def/serviceType/ogc/wms"
      ["GeoTIFF"]
    else
      []
    end
  else
    []
  end
end

##
# Create dcat:distribution object for a download
# @param [String, String,String,String,String]
# @return [Hash]
def generate_distribution_download(title,format,mediaType,value,conformsTo = nil)
  {
    :@type => 'dcat:Distribution',
    title: title,
    format: format,
    downloadURL: value,
    mediaType: mediaType,
    conformsTo: conformsTo
  }.delete_if { |k,v| v.nil? }
end

##
# Create dcat:distribution object for a web service
# @param [String, String,String,String,String]
# @return [Hash]
def generate_distribution_service(value,conformsTo,layerId = nil,downloadableAs = nil)
  {
    :@type => 'dcat:Distribution',
    accessURL: value,
    conformsTo: conformsTo,
    layerId: layerId,
    downloadableAs: downloadableAs,
  }.delete_if { |k,v| v.nil? }
end
