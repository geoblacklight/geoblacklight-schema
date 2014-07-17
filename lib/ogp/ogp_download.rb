#!/usr/bin/env ruby

require 'open-uri'

class DownloadOgp
  URL = {
    'tufts' => 'http://geodata.tufts.edu/solr/select',
    'stanford' => 'http://geoportal.stanford.edu/solr/ogp/select',
    'mit' => 'http://arrowsmith.mit.edu/solr/select',
    'berkeley' => 'http://gis.lib.berkeley.edu:9081/solr4/select',
    'harvard' => 'http://geodata.tufts.edu/solr/select' # Harvard uses Tufts solr index
  }
  
  FIELDS = %w{
    Abstract
    Access
    Area
    Availability
    CenterX
    CenterY
    ContentDate
    DataType
    ExternalLayerId
    FgdcText
    GeoReferenced
    HalfHeight
    HalfWidth
    Institution
    LayerDisplayName
    LayerId
    Location
    MaxX
    MaxY
    MinX
    MinY
    Name
    PlaceKeywords
    Publisher
    SrsProjectionCode
    ThemeKeywords
    WorkspaceName
  }.join(',')
  
  def download(src, i, n, w=50)
    start = 0
    i = src if i.nil?
    while start < n do
      fetch(src, i, start, w)
      start += w
    end
  end
  
  # fetch a set of Solr records from the src provider about the target institution
  #
  # @param [String] src The source provider of the Solr records
  # @param [String] target the target institution
  # @param [Integer] start
  # @param [Integer] rows
  def fetch(src, target, start, rows, datadir = 'data')
    fn = File.join(datadir, "#{src.downcase}_#{target.downcase}_#{sprintf('%05i', start)}_#{rows}.json")
    unless File.exist?(fn)
      raise "Unknown URL for #{src}" unless URL.include?(src.downcase)
      puts "Downloading #{target} #{start} to #{start+rows}"
      url = "#{URL[src.downcase]}?" + URI::encode_www_form(
                  'q' => '*:*', 
                  'fq' => "Institution:#{target}",
                  'start' => start,
                  'rows' => rows,
                  'wt' => 'json',
                  'indent' => 'on',
                  'fl' => FIELDS
                  )
      puts "    #{url}" if $DEBUG
      open(url) do |res|
        File.open(fn, 'wb') do |f|
          f.write(res.read())
        end
      end
    else
      puts "Using cache for #{target} #{start} to #{start+rows}"
    end
  end
end

# __MAIN__
ogp = DownloadOgp.new
ogp.download('Stanford', 'Stanford', 269)
ogp.download('Berkeley', 'Berkeley', 407)
ogp.download('Tufts', 'MassGIS', 596)
ogp.download('Tufts', 'Tufts', 2598)
ogp.download('Tufts', 'Harvard', 8936)
ogp.download('MIT', 'MIT', 14742)
