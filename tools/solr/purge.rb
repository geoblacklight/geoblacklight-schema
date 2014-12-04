#!/usr/bin/env ruby
# 
# Usage: purge.rb my-collection http://localhost:8080/solr
#
require 'rsolr'

class SolrPurger
  def initialize(collection, url)
    raise ArgumentError, 'Collection not defined' unless collection.is_a? String
    @solr = RSolr.connect(:url => (url + '/' + collection))
    yield self
    close
  end
  
  def purge
    @solr.delete_by_query("*:*")
  end
  
  def close
    @solr.commit
    @solr = nil
  end
  
end

# __MAIN__
if ARGV[0] == '--help' || ARGV.size != 2
  puts 'Usage: purge.rb my-collection http://localhost:8080/solr'
  exit -1
end
SolrPurger.new(ARGV[0], ARGV[1]) do |sp|
  sp.purge
end
