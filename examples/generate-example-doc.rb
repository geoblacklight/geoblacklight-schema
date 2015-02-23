#!/usr/bin/env ruby
#
# Example Ruby code to generate a GeoBlacklight Solr document in JSON format.
#
# See here for full description of the schema:
#
#   http://journal.code4lib.org/articles/9710
#
require 'json'

uri = {
  download: 'http://schema.org/downloadUrl',
  html:     'http://www.w3.org/1999/xhtml',
  url:      'http://schema.org/url',
  wms:      'http://www.opengis.net/def/serviceType/ogc/wms'
}

s, w, n, e = [-5, -30, 15, 45] # south, west, north, east
layer = {
  :uuid             => "my-uuid",
  :dc_identifier_s  => "my-uuid",
  :dc_title_s       => 'My Layer',
  :dc_description_s => "Lorem ipsum dolor sit amet...",
  :dc_rights_s      => 'Public', # or 'Restricted'
  :dct_provenance_s => 'My Institution',
  :layer_slug_s     => "my-layer-name",
  :layer_modified_dt=> Time.now.utc.strftime('%FT%TZ'),
  :dc_format_s      => 'Shapefile',
  :layer_geom_type_s=> 'Polygon',
  :georss_box_s     => "#{s} #{w} #{n} #{e}", # SW NE in WGS84
  :solr_bbox        => "ENVELOPE(#{w}, #{e}, #{n}, #{s})" # derived from georss_box_s
  :solr_geom        => "ENVELOPE(#{w}, #{e}, #{n}, #{s})" # derived from georss_box_s
}

layer[:dct_references_s] = {
  uri[:url]       => 'https://example.com/my-layer/homepage',
  uri[:download]  => 'https://example.com/my-layer/data.zip',
  uri[:wms]       => 'https://example.com/geoserver/wms',
  uri[:html]      => 'https://example.com/my-layer/metadata.html'
}.to_json.to_s

puts JSON.pretty_generate(layer)
