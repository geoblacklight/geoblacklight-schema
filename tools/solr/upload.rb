#!/usr/bin/env ruby
#
# Usage: upload.rb http://localhost:8080/my-collection file1.xml [file2.json...]
#
require 'rsolr'
require 'nokogiri'

if ARGV.size < 2
  puts 'Usage: upload.rb http://localhost:8080/my-collection file1.xml [file2.json...]'
  exit(-1)
end

stop_on_error = false

solr = RSolr.connect(url: ARGV.delete_at(0))

ARGV.each do |fn|
  puts "Processing #{fn}"
  begin
    if fn =~ /.xml$/
      doc = Nokogiri::XML(File.open(fn, 'rb').read)
      solr.update(data: doc.to_xml)
    elsif fn =~ /.json$/
      doc = JSON.parse(File.open(fn, 'rb').read)
      solr.add doc
    else
      fail "Unknown file type: #{fn}"
    end
  rescue => e
    puts "ERROR: #{e}: #{e.backtrace}"
    raise e if stop_on_error
  end
end

solr.commit
