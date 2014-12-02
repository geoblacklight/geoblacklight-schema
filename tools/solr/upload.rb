#!/usr/bin/env ruby
# 
# Usage: upload.rb http://localhost:8080/my-collection file1.xml file2.json
#
require 'rsolr'
require 'nokogiri'

solr = RSolr.connect :url => ARGV.delete_at(0) 

ARGV.each do |fn|
  puts "Processing #{fn}"
  if fn =~ /.xml$/
    doc = Nokogiri::XML(File.open(fn, 'rb').read)
    solr.update :data => doc.to_xml
  elsif fn =~ /.json$/
    doc = JSON.parse(File.open(fn, 'rb').read)
    solr.add doc
  else
    raise RuntimeError, "Unknown file type: #{fn}"
  end
end

solr.commit
