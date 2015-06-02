#!/usr/bin/env ruby
#
# Usage: render.rb fgdc.xml [fgdc.xml...]
#
require 'nokogiri'

class RenderCLI
  @@xslt = Nokogiri::XSLT(File.read(File.join(File.dirname(__FILE__), 'fgdc2html.xsl')))

  def run(xmlfn)
    doc = Nokogiri::XML(File.read(xmlfn))
    htmlfn = xmlfn.gsub(/\.xml$/, '.html')
    File.open(htmlfn, 'wb') do |f|
      f << '<html><head>'
      f << '<style>' + File.read(File.join(File.dirname(__FILE__), 'fgdc2html.css')) + '</style>'
      f << '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>'
      f << '<script>' + File.read(File.join(File.dirname(__FILE__), 'fgdc2html.js')) + '</script>'
      f << '</head><body>'
      f << @@xslt.transform(doc)
      f << '</body></html>'
    end
  end
end

# __MAIN__
cli = RenderCLI.new
ARGV.each do |fn|
  puts "Processing #{fn}"
  cli.run(fn)
end
