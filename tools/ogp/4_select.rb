#!/usr/bin/env ruby
#
# Usage: select.rb

require 'awesome_print'
require 'json'

# __MAIN__
selected = []
srand Time.now.to_i
fn = 'transformed.json'
valid = JSON::parse(File.read(fn))

# select random records
valid.each do |i|
  if rand < 0.01
    selected << i
  end
end

puts "Selected #{selected.size} random records"

# iterate through specific layer_id's
%w{
  http://arks.princeton.edu/ark:/88435/02870w62c
  http://purl.stanford.edu/jf841ys4828
  http://purl.stanford.edu/jr127wd5810
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.EZ_F7DISTRICTS_2008
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.INT_A1CNTRY_2005
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.INT_A8MISPOP_2004
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.IN_HYDERABAD_P2ROAD_2007
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.NA_N3NOREGESP_2008
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.NA_P61AIRPORTS_2009
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.SF_WC_G46LEASEAREAS_1998
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.SZ_E29VAC_2002
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.US_F7MPO_2006
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.US_MA_CAMBRIDGE_C3BASINS_2007
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.US_MA_CAMBRIDGE_G46PORCH_2010
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.US_MA_CAMBRIDGE_S1CONSV_2007
  urn:arrowsmith.mit.edu:MIT.SDE_DATA.US_MA_E25ZCTA5DCT_2000
  urn:geodata.tufts.edu:Tufts.AlgeriaLakes97
  urn:geodata.tufts.edu:Tufts.BahrainRoads94
  urn:geodata.tufts.edu:Tufts.BulgariaRegions06
  urn:geodata.tufts.edu:Tufts.CambridgeParkingLot03
  urn:geodata.tufts.edu:Tufts.CambridgeStairs03
  urn:geodata.tufts.edu:Tufts.CambridgeTaxingDistFY11
  urn:geodata.tufts.edu:Tufts.ChinaProvinces90
  urn:geodata.tufts.edu:Tufts.Denmark4DigPostCode06
  urn:geodata.tufts.edu:Tufts.Ecuador1MLake08
  urn:geodata.tufts.edu:Tufts.EgyptLakes97
  urn:geodata.tufts.edu:Tufts.IrelandRivers06
  urn:geodata.tufts.edu:Tufts.IsraelPalestineGenevaBord03
  urn:geodata.tufts.edu:Tufts.JerusalemBuildings08
  urn:geodata.tufts.edu:Tufts.MarlboroughRoads09
  urn:geodata.tufts.edu:Tufts.TogoRivers97
  urn:hul.harvard.edu:HARVARD.SDE.AMS7810_S250_U54_NG47_11
  urn:hul.harvard.edu:HARVARD.SDE.AMS7810_S250_U54_NG47_16
  urn:hul.harvard.edu:HARVARD.SDE.ARCBIKE
  urn:hul.harvard.edu:HARVARD.SDE.ARCHHYDROLN
  urn:hul.harvard.edu:HARVARD.SDE.ARCMARTASTN
  urn:hul.harvard.edu:HARVARD.SDE.BRLBOS
  urn:hul.harvard.edu:HARVARD.SDE.ESRIEURCANALS
  urn:hul.harvard.edu:HARVARD.SDE.ESRIMIZIP
  urn:hul.harvard.edu:HARVARD.SDE.KNG_POLICE
  urn:hul.harvard.edu:HARVARD.SDE.MEACOMMSTAT95
  urn:hul.harvard.edu:HARVARD.SDE.TG00ALCTY00
  urn:hul.harvard.edu:HARVARD.SDE.TG00ALKGL
  urn:hul.harvard.edu:HARVARD.SDE.TG00CAAIR00
  urn:hul.harvard.edu:HARVARD.SDE.TG00COMSA00
  urn:hul.harvard.edu:HARVARD.SDE.TG00HIUNI
  urn:hul.harvard.edu:HARVARD.SDE.TG00IDPLC
  urn:hul.harvard.edu:HARVARD.SDE.TG00ILCTY00
  urn:hul.harvard.edu:HARVARD.SDE.TG00INLKA
  urn:hul.harvard.edu:HARVARD.SDE.TG00MATRT
  urn:hul.harvard.edu:HARVARD.SDE.TG00MILKD
  urn:hul.harvard.edu:HARVARD.SDE.TG00MNUNI
  urn:hul.harvard.edu:HARVARD.SDE.TG00MTLKF
  urn:hul.harvard.edu:HARVARD.SDE.TG00MTPUMA
  urn:hul.harvard.edu:HARVARD.SDE.TG00NJPUMA
  urn:hul.harvard.edu:HARVARD.SDE.TG00NMVOT00
  urn:hul.harvard.edu:HARVARD.SDE.TG00ORLPT
  urn:hul.harvard.edu:HARVARD.SDE.TG00PRPMS00
  urn:hul.harvard.edu:HARVARD.SDE.TG00VAAIR00
  urn:hul.harvard.edu:HARVARD.SDE.TG00VATRT00
  urn:hul.harvard.edu:HARVARD.SDE.TG00VILKD
  urn:hul.harvard.edu:HARVARD.SDE.TG00VTSEC
  urn:hul.harvard.edu:HARVARD.SDE.TG00WAPUMA
  urn:hul.harvard.edu:HARVARD.SDE.TG95ALCDCPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95AZELMPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95CACTYPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95COCCDPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95HISECPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95ILUNIPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95KSPLCPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95MILKBLN
  urn:hul.harvard.edu:HARVARD.SDE.TG95MTAIRCUPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95MTURBPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95NMTRTPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95NYCTYPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95OHLPTPT
  urn:hul.harvard.edu:HARVARD.SDE.TG95ORTRTPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95SCCTYPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95VALKDLN
  urn:hul.harvard.edu:HARVARD.SDE.TG95VALKHLN
  urn:hul.harvard.edu:HARVARD.SDE.TG95VATAZPY
  urn:hul.harvard.edu:HARVARD.SDE.TG95WVLKALN
  urn:hul.harvard.edu:HARVARD.SDE.USGS15MA_GREENFIE_1890
  urn:hul.harvard.edu:HARVARD.SDE.VMAP1AQUEDCTL
  urn:hul.harvard.edu:HARVARD.SDE.VMAP1EMBANKL
  urn:hul.harvard.edu:HARVARD.SDE.VMAP1SEAICEA
  urn:hul.harvard.edu:HARVARD.SDE.VMAP1VEGTXT
  urn:hul.harvard.edu:HARVARD.SDE2.AFRICOVER_TZ_SPAT_AGG
  urn:hul.harvard.edu:HARVARD.SDE2.AM_ONC_L04L
  urn:hul.harvard.edu:HARVARD.SDE2.CH2000_L_F
  urn:hul.harvard.edu:HARVARD.SDE2.DMA50K_46751L
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI04EURREGDEMOG
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI04LAKES
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI04MXURBAN
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI04USLALNDMRK
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI06EURPLACES
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI06USBLKPOP_ME
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI07USBLKPOP_AK
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI07USBLKPOP_ME
  urn:hul.harvard.edu:HARVARD.SDE2.ESRI12USTRACTS
  urn:hul.harvard.edu:HARVARD.SDE2.EURATLAS_CITIES_1900
  urn:hul.harvard.edu:HARVARD.SDE2.G3774_P9_1849_C8
  urn:hul.harvard.edu:HARVARD.SDE2.G3802_E44_1821_N4_SH2
  urn:hul.harvard.edu:HARVARD.SDE2.G3804_N4C2_1961_G4_SH_6
  urn:hul.harvard.edu:HARVARD.SDE2.G3804_N4_2M3_1845_S7_SH_2
  urn:hul.harvard.edu:HARVARD.SDE2.G6714_N2_1826_J6
  urn:hul.harvard.edu:HARVARD.SDE2.G7064_S2_1834_K3
  urn:hul.harvard.edu:HARVARD.SDE2.H008768589_V07_0007
  urn:hul.harvard.edu:HARVARD.SDE2.MADRG_K42073B1
  urn:hul.harvard.edu:HARVARD.SDE2.MATWN_3764_B6P3_1850_P4
  urn:hul.harvard.edu:HARVARD.SDE2.ME3732_P4_1798_C3
  urn:hul.harvard.edu:HARVARD.SDE2.MGISBIOCHP
  urn:hul.harvard.edu:HARVARD.SDE2.TG10NHVTD
  urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH
  urn:hul.harvard.edu:HARVARD.SDE2.USGS_GT_CONCEPCION_MINAS_DNN
  urn:hul.harvard.edu:HARVARD.SDE2.USGS_GT_GUATEMALA_CITY_HYP
  urn:hul.harvard.edu:HARVARD.SDE2.USGS_NU_ESTELI_RDL
  urn:hul.harvard.edu:HARVARD.SDE2.USGS_NU_LEON_RRL
  urn:hul.harvard.edu:HARVARD.SDE2.USGS_NU_POSOLTEGA_DSL
  urn:hul.harvard.edu:HARVARD.SDE2.VT3754_H52G46_1836_M3
  urn:massgis.state.ma.us:MassGIS.EOPS.UCR_00_S_V
  urn:massgis.state.ma.us:MassGIS.GISDATA.ACECS_ARC
  urn:massgis.state.ma.us:MassGIS.GISDATA.FISHTRAPS_PT
  urn:massgis.state.ma.us:MassGIS.GISDATA.REGDPHEPC_POLY
}.each do |i|
  valid.each do |j|
    selected << j if j['dc_identifier_s'] == i
  end
end
puts "Selected #{selected.size} specific IDs and random records"

# iterate through specific conditions
found_case = {}
valid.each do |j|
  if !found_case['1'] && j['dc_rights_s'] == 'Public' && j['dct_provenance_s'] == 'Stanford'
    selected << j
    found_case['1'] = true
  end
  if !found_case['2'] && j['dct_references_s'] == '{}'
    selected << j
    found_case['2'] = true
  end
  %w{Berkeley Columbia\ University Harvard MIT MassGIS Tufts UCLA}.each do |i|
    if !found_case[i] && j['dct_provenance_s'] == i
      selected << j
      found_case[i] = true
    end
  end
  %w{Line Point Polygon Raster}.each do |i|
    if !found_case[i] && j['layer_geom_type_s'] == i
      selected << j
      found_case[i] = true
    end
  end
end
puts "Selected #{selected.size} specific cases and IDs and random records"


File.open('selected.json', 'wb') {|f| f << JSON.pretty_generate(selected)}