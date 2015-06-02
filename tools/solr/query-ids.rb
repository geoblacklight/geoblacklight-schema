#!/usr/bin/env ruby
#
# Usage: query-ids.rb my-collection http://localhost:8080/solr query
#
require 'rsolr'

# Simple select by query class
class SolrQuery
  def initialize(collection, url)
    fail ArgumentError, 'Collection not defined' unless collection.is_a? String
    @solr = RSolr.connect(url: (url + '/' + collection))
    yield self
    close
  end

  def query(q)
    response = @solr.get 'select', params: { q: q, fl: 'uuid', rows: '10000' }
    response['response']['docs'].each { |doc| puts doc['uuid'] }
  end

  def close
    @solr.commit
    @solr = nil
  end
end

# __MAIN__
if ARGV[0] == '--help' || ARGV.size != 3
  puts 'Usage: query.rb my-collection http://localhost:8080/solr query'
  exit(-1)
end
SolrQuery.new(ARGV[0], ARGV[1]) do |sp|
  sp.query ARGV[2]
end
