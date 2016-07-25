#!/usr/bin/env ruby
#
# generate-selected.rb - Generates the `selected.json` data file with example test data
#
ARGV << 'http://localhost:8983/solr/blacklight-core' if ARGV.empty?

require 'json'
require 'rsolr'

slugs = %w(
  mit-sf-wc-g46leaseareas-1998
  mit-sz-e29vac-2002
  mit-us-f7mpo-2006
  mit-us-ma-e25zcta5dct-2000
  mit-us-ma-cambridge-c3basins-2007
  mit-int-a8mispop-2004
  mit-na-p61airports-2009
  mit-int-a1cntry-2005
  mit-us-ma-cambridge-g46porch-2010
  mit-ez-f7districts-2008
  mit-us-ma-cambridge-s1consv-2007
  mit-na-n3noregesp-2008
  mit-in-hyderabad-p2road-2007
  stanford-jf841ys4828
  stanford-jr127wd5810
  harvard-tg00hiuni
  harvard-tg00idplc
  harvard-tg00ilcty00
  harvard-tg00inlka
  harvard-tg00matrt
  harvard-tg00milkd
  harvard-tg00mnuni
  harvard-tg00mtlkf
  harvard-tg00mtpuma
  harvard-tg00njpuma
  harvard-tg00orlpt
  harvard-tg00prpms00
  harvard-tg00vaair00
  harvard-tg00vatrt00
  harvard-tg00vilkd
  harvard-tg00vtsec
  harvard-tg00wapuma
  harvard-tg95alcdcpy
  harvard-tg95azelmpy
  harvard-tg95cactypy
  harvard-tg95coccdpy
  harvard-tg95hisecpy
  harvard-kng-police
  harvard-meacommstat95
  harvard-tg00alcty00
  harvard-tg00alkgl
  harvard-tg00caair00
  harvard-ams7810-s250-u54-ng47-11
  harvard-ams7810-s250-u54-ng47-16
  harvard-arcbike
  harvard-archhydroln
  harvard-arcmartastn
  harvard-brlbos
  harvard-esrieurcanals
  harvard-esrimizip
  harvard-tg95ksplcpy
  harvard-tg95milkbln
  harvard-tg95mtaircupy
  harvard-tg95mturbpy
  harvard-tg95nmtrtpy
  harvard-tg95nyctypy
  harvard-tg95ohlptpt
  harvard-tg95ortrtpy
  harvard-tg95scctypy
  harvard-tg95valkdln
  harvard-tg95valkhln
  harvard-tg95vatazpy
  harvard-tg95wvlkaln
  harvard-usgs15ma-greenfie-1890
  harvard-vmap1aquedctl
  harvard-vmap1embankl
  harvard-vmap1seaicea
  harvard-vmap1vegtxt
  harvard-tg00nmvot00
  harvard-tg95ilunipy
  harvard-esri07usblkpop-ak
  harvard-esri07usblkpop-me
  harvard-esri12ustracts
  harvard-ch2000-l-f
  harvard-dma50k-46751l
  harvard-esri04eurregdemog
  harvard-esri04lakes
  harvard-esri04mxurban
  harvard-euratlas-cities-1900
  harvard-tg00comsa00
  harvard-g6714-n2-1826-j6
  harvard-g7064-s2-1834-k3
  harvard-g3774-p9-1849-c8
  harvard-g3802-e44-1821-n4-sh2
  harvard-g3804-n4-2m3-1845-s7-sh-2
  harvard-g3804-n4c2-1961-g4-sh-6
  harvard-africover-tz-spat-agg
  harvard-am-onc-l04l
  harvard-usgs-gt-guatemala-city-hyp
  harvard-usgs-nu-esteli-rdl
  harvard-usgs-nu-leon-rrl
  harvard-usgs-nu-posoltega-dsl
  harvard-vt3754-h52g46-1836-m3
  harvard-madrg-k42073b1
  harvard-esri04uslalndmrk
  harvard-esri06eurplaces
  harvard-esri06usblkpop-me
  harvard-matwn-3764-b6p3-1850-p4
  harvard-me3732-p4-1798-c3
  harvard-mgisbiochp
  harvard-tg10nhvtd
  harvard-tg10usaiannh
  harvard-usgs-gt-concepcion-minas-dnn
  harvard-h008768589-v07-0007
  massgis-eops-ucr-00-s-v
  massgis-acecs-arc
  massgis-fishtraps-pt
  massgis-regdphepc-poly
  tufts-jerusalembuildings08
  tufts-togorivers97
  tufts-denmark4digpostcode06
  tufts-irelandrivers06
  tufts-bulgariaregions06
  tufts-bahrainroads94
  tufts-chinaprovinces90
  tufts-israelpalestinegenevabord03
  tufts-egyptlakes97
  tufts-algerialakes97
  tufts-ecuador1mlake08
  tufts-marlboroughroads09
  tufts-cambridgeparkinglot03
  tufts-cambridgestairs03
  tufts-cambridgetaxingdistfy11
  princeton-02870w62c
)

# fetch all the slugs
solr = RSolr.connect url: ARGV[0]

selected = []
slugs.each do |slug|
  response = solr.get 'select', params: {
    q: "layer_slug_s:\"#{slug}\"",
    rows: 1
  }
  response['response']['docs'].each do |doc|
    %w(_version_ timestamp score).each do |k|
      doc.delete(k)
    end
    selected << doc
  end
end

puts JSON.pretty_generate(selected)
