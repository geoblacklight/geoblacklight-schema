#!/usr/bin/env ruby

cmd = "xsltproc lib/xslt/fgdc2mods.xsl #{ARGV[0]}"
puts cmd
system cmd