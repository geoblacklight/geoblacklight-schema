#!/usr/bin/env ruby
#
# Usage: render.rb iso.xml [iso.xml...]
#
require 'nokogiri'

class RenderCLI
  @@xslt = Nokogiri::XSLT(File.read(File.join(File.dirname(__FILE__), 'iso-html.xsl')))
  
  def run(xmlfn)
    doc = Nokogiri::XML(File.read(xmlfn))
    htmlfn = xmlfn.gsub(/\.xml$/, '.html')
    File.open(htmlfn, 'wb') do |f|
      f << @@xslt.transform(doc)
    end
  end
end

# __MAIN__
cli = RenderCLI.new
ARGV.each do |fn|
  puts "Processing #{fn}"
  cli.run(fn)
end
