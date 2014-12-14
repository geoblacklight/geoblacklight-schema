#!/usr/bin/env ruby
#
# Usage: render.rb fgdc.xml [fgdc.xml...]
#
require 'nokogiri'

class RenderCLI
  @@xslt = Nokogiri::XSLT(File.read(File.join(File.dirname(__FILE__), 'fgdc-html.xsl')))
  
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
  cli.run(fn)
end
