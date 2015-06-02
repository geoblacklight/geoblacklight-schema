#!/usr/bin/env ruby
#
# Usage: purge.rb my-collection http://localhost:8080/solr query
#
require 'rsolr'

# Purges documents by query
class SolrPurger
  def initialize(collection, url)
    fail ArgumentError, 'Collection not defined' unless collection.is_a? String
    @solr = RSolr.connect(url: (url + '/' + collection))
    yield self
    close
  end

  def purge(q)
    @solr.delete_by_query(q)
  end

  def close
    @solr.commit
    @solr = nil
  end
end

# __MAIN__
if ARGV[0] == '--help' || ARGV.size != 3
  puts 'Usage: purge.rb my-collection http://localhost:8080/solr query'
  exit(-1)
end
SolrPurger.new(ARGV[0], ARGV[1]) do |sp|
  sp.purge ARGV[2]
end
