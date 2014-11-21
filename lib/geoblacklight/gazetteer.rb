# encoding: UTF-8

require 'csv'

# Gazetteer data look like this:
#   "l_kw","geonames_kw","geonames_id","lc_kw","lc_id"
#   "Ahmadābād District (India)","Ahmadābād",1279234,"Ahmadābād (India : District)","n78019943"
module GeoBlacklightSchema
  class Gazetteer
    
    CSV_FN = File.join(File.dirname(__FILE__), 'gazetteer.csv')
    
    def initialize
      @registry = {}
      CSV.foreach(CSV_FN, :encoding => 'UTF-8', :headers => true) do |v|
        v = v.each { |k,v| v.to_s.strip }
        k = v[0]
        k = v[1] if k.nil? or k.empty?
        k.strip!
        @registry[k] = {
          :geonames_placename => v[1],
          :geonames_id => v[2].to_i,
          :loc_keyword => (v[3].nil? or v[3].empty?)? nil : v[3],
          :loc_id => (v[4].nil? or v[4].empty?)? nil : v[4]
        }
      end
    end

    def each
      @registry.each_key.to_a.sort.each {|k| yield k }
    end

    # @return [String] geonames name
    def find_placename(k)
      _get(k, :geonames_placename)
    end
    
    # @return [Integer] geonames id
    def find_id(k)
      _get(k, :geonames_id)
    end

    # @return [String] library of congress name
    def find_loc_keyword(k)
      _get(k, :loc_keyword)
    end
    
    # @return [String] library of congress valueURI
    def find_loc_uri(k)
      lcid = _get(k, :loc_id)
      if lcid =~ /^lcsh:(\d+)$/ or lcid =~ /^sh(\d+)$/
        "http://id.loc.gov/authorities/subjects/sh#{$1}"
      elsif lcid =~ /^lcnaf:(\d+)$/ or lcid =~ /^n(\d+)$/
        "http://id.loc.gov/authorities/names/n#{$1}"
      elsif lcid =~ /^no(\d+)$/
        "http://id.loc.gov/authorities/names/no#{$1}"
      else
        nil
      end
    end
    
    # @return [String] authority name
    def find_loc_authority(k)
      lcid = _get(k, :loc_id)
      return $1 if lcid =~ /^(lcsh|lcnaf):/
      return 'lcsh' if lcid =~ /^sh\d+$/
      return 'lcnaf' if lcid =~ /^(n|no)\d+$/
      return 'lcsh' unless find_loc_keyword(k).nil? # default to lcsh if present
      nil
    end
    

    # @see http://www.geonames.org/ontology/documentation.html
    # @return [String] geonames uri (includes trailing / as specified)
    def find_placename_uri(k)
      return nil if _get(k, :geonames_id).nil?
      "http://sws.geonames.org/#{_get(k, :geonames_id)}/"
    end
  
    # @return [String] The keyword
    def find_keyword_by_id(id)
      @registry.each do |k,v|
        return k if v[:geonames_id] == id
      end
      nil
    end

    private
    def _get(k, i)
      return nil unless @registry.include?(k.strip)
      raise ArgumentError unless i.is_a? Symbol
      @registry[k.strip][i]
    end

  end
end

