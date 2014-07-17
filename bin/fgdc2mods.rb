#!/usr/bin/env ruby

cmd = "xsltproc-saxon lib/xslt/fgdc2mods.xsl #{ARGV[0]}"
puts cmd
system cmd
