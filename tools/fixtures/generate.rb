#!/usr/bin/env ruby

require 'json'

uri = {
      download: 'http://schema.org/downloadUrl',
      fgdc: 'http://www.opengis.net/cat/csw/csdgm',
      geojson: 'http://geojson.org/geojson-spec.html',
      html: 'http://www.w3.org/1999/xhtml',
      iiif: 'http://iiif.io/api/image',
      iso19139: 'http://www.isotc211.org/schemas/2005/gmd/',
      mods: 'http://www.loc.gov/mods/v3',
      shapefile: 'http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf',
      url: 'http://schema.org/url',
      thumbnail: 'http://schema.org/thumbnailUrl',
      wcs: 'http://www.opengis.net/def/serviceType/ogc/wcs',
      wfs: 'http://www.opengis.net/def/serviceType/ogc/wfs',
      wms: 'http://www.opengis.net/def/serviceType/ogc/wms'
    }

def generate(n, *params)
  name = "case#{n}"
  puts "Generating #{name}"
  s, w, n, e = [-5, -30, 15, 45]
  layer = Hash(*params)
  layer.merge!({
    :uuid => "http://purl.stanford.edu/#{name}",
    :dc_identifier_s => "http://purl.stanford.edu/#{name}",
    :dc_description_s => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    :dc_rights_s => 'Public',
    :dct_provenance_s => 'Stanford',
    :georss_box_s => "#{s} #{w} #{n} #{e}",
    :layer_slug_s => "stanford-#{name}",
    :layer_modified_dt  => Time.now.utc.strftime('%FT%TZ'),
    :solr_bbox  => "#{w} #{s} #{e} #{n}", # minX minY maxX maxY
    :solr_geom  => "ENVELOPE(#{w}, #{e}, #{n}, #{s})"    
  })
  layer[:dc_title_s] = "Case #{n}: #{layer[:dc_title_s]}"
  layer[:dct_references_s] = '{}' if layer[:dct_references_s].nil?
  
  json = JSON.pretty_generate(layer)
  
  File.open("data/#{name}.json", 'wb') {|f| f << json }
end

generate(1,
  dc_title_s:         'Bare requirements',
  dc_format_s: 'Paper',
  layer_geom_type_s:  'Paper Map'
)

generate(2,
  dc_title_s:         'Bare requirements with URL',
  dc_format_s: 'Paper',
  layer_geom_type_s:  'Paper Map',
  dct_references_s:   {
    uri[:url] => "http://localhost/data",
  }
)

generate(10,
  dc_title_s:         'Scanned Map',
  dc_format_s:        'TIFF',
  layer_geom_type_s:  'Scanned Map',
  dct_references_s:   {
    uri[:download] => "http://localhost/data.zip"
  }
)

generate(11,
  dc_title_s:         'Scanned Map with Thumbnail',
  dc_format_s:        'TIFF',
  layer_geom_type_s:  'Scanned Map',
  dct_references_s:   {
    uri[:thumbnail] => "http://localhost/data.jpg"
  }
)

generate(12,
  dc_title_s:         'Scanned Map with IIIF',
  dc_format_s:        'TIFF',
  layer_geom_type_s:  'Scanned Map',
  dct_references_s:   {
    uri[:iiif] => "http://localhost:8080/iiif"
  }
)

generate(20,
  dc_title_s:         'Raster with WMS only',
  dc_format_s:        'GeoTIFF',
  layer_geom_type_s:  'Raster',
  dct_references_s:   {
    uri[:wms] => "http://localhost:8080/wms"
  }
)

generate(21,
  dc_title_s:         'Shapefile with WMS only',
  dc_format_s:        'Shapefile',
  layer_geom_type_s:  'Polygon',
  dct_references_s:   {
    uri[:wms] => "http://localhost:8080/wms"
  }
)

generate(22,
  dc_title_s:         'Shapefile with WMS and download',
  dc_format_s:        'Shapefile',
  layer_geom_type_s:  'Polygon',
  dct_references_s:   {
    uri[:download] => "http://localhost/data.zip",
    uri[:wms] => "http://localhost:8080/wms"
  }
)

generate(23,
  dc_title_s:         'Shapefile with WMS and download and URL',
  dc_format_s:        'Shapefile',
  layer_geom_type_s:  'Polygon',
  dct_references_s:   {
    uri[:url] => "http://localhost/homepage",
    uri[:download] => "http://localhost/data.zip",
    uri[:wms] => "http://localhost:8080/wms"
  }
)
