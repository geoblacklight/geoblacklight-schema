#!/usr/bin/env ruby

cmd = "bin/xsltproc-saxon lib/xslt/fgdc2mods.xsl #{ARGV[0]}"
# puts cmd
system cmd
