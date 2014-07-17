#!/usr/bin/env ruby

cmd = "xsltproc-saxon lib/xslt/mods2geoblacklight.xsl #{ARGV[0]}"
# puts cmd
system cmd
