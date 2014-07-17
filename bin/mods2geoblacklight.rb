#!/usr/bin/env ruby

cmd = "bin/xsltproc-saxon lib/xslt/mods2geoblacklight.xsl #{ARGV[0]}"
puts cmd
system cmd
