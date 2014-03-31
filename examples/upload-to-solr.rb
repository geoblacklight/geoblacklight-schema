#!/usr/bin/env ruby
#
# Usage: upload-to-solr.rb my-collection [http://localhost:8080/solr]
#
require 'json'
require 'rsolr'

class UploadToSolr
  def initialize(collection, url)
    raise ArgumentError, 'Collection not defined' unless collection.is_a? String
    @solr = RSolr.connect(:url => (url + '/' + collection))
    yield self
    close
  end
  
  def ingest(fn)
    puts "Ingesting #{fn}"
    json = JSON::parse(File.read(fn))
    n = 0
    json.each do |doc|
      next unless doc.is_a? Hash and not doc.empty?
      doc.delete('_version_')
      doc.delete('timestamp')
      putc "."
      @solr.add doc
      n += 1
      if n % 100 == 0
        @solr.commit 
        puts "\ncommit 100 records, #{n} total\n"
      end
    end
    puts "\n#{n} records\n"
    @solr.commit
  end
  
  def close
    @solr.commit
    @solr.optimize
    @solr = nil
  end
  
end


# __MAIN__
UploadToSolr.new(ARGV[0], (ARGV[1].nil?? 'http://localhost:8080/solr' : ARGV[1])) do |solr|
  Dir.glob("*.json") do |fn|
    solr.ingest(fn)
  end
end
