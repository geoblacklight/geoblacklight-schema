#!/usr/bin/env ruby
require 'awesome_print'
require 'nokogiri'
require 'json'

srcdir = '/var/cache/opengeometadata/edu.stanford.purl'

layers = JSON.parse(File.open('transformed.json', 'rb').read)
raise RuntimeError unless layers.is_a?(Array) && layers.first.is_a?(Hash)

Dir.glob("#{srcdir}/**/geoblacklight.xml").each do |fn|
  puts "Loading #{fn}"
  doc = Nokogiri::XML(File.open(fn, 'rb').read)
  # ap({:doc => doc})
  new_layer = {}
  doc.xpath('//solr:field', 'xmlns:solr' => 'http://lucene.apache.org/solr/4/document').each do |field|
    k = field['name'].to_s.strip.to_sym
    if k.to_s =~ /_sm$/
      if new_layer[k].nil?
        new_layer[k] = []
      end
      new_layer[k] << field.content
    else
      new_layer[k] = field.content
    end
  end
  # ap({:new_layer => new_layer})
  layers << new_layer
end

File.open('transformed.json', 'wb') do |f|
  f << JSON::pretty_generate(layers)
end

puts "Transformed now has #{layers.size} layers"