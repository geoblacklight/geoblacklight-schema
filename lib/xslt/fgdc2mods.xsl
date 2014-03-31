<?xml version="1.0" encoding="UTF-8"?>
<!-- 
     fgdc2mods.xsl - Transformation from FGDC into MODS v3 
     
     
     Copyright 2013-2014, The Board of Trustees of the Leland Stanford Junior University

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
     
     
     Created by Kim Durante and Darren Hardy, Stanford University Libraries
     
     Requires parameters:
     * geometryType: One of Point, LineString, Polygon, Curve, or Grid (Raster). 
       see
     http://www.schemacentral.com/sc/niem21/t-gml32_GeometryPropertyType.html
     * purl - e.g., http://purl.stanford.edu/aa111bb2222 or another UUID/URN
     * format - e.g., MIME type application/x-esri-shapefile
     
     May need other element sources for formats if not in 'formname' tag

     -->
<xsl:stylesheet 
  xmlns="http://www.loc.gov/mods/v3" 
  xmlns:gco="http://www.isotc211.org/2005/gco" 
  xmlns:gmi="http://www.isotc211.org/2005/gmi" 
  xmlns:gmd="http://www.isotc211.org/2005/gmd" 
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="2.0" exclude-result-prefixes="gml gmd gco gmi xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="format" select="'application/x-esri-shapefile'"/>
  <xsl:param name="geometryType"/>
  <xsl:param name="purl"/>
  <xsl:param name="zipName" select="'data.zip'"/>
  <!-- The coordinates value for MODS v3 is quite vague, 
       so we have a variety of formats: 
       GMD, WKT, WMS, GML, GeoRSS, MARC034, MARC255 (default)
       -->
  <xsl:param name="geoformat" select="'MARC255'"/>
  <xsl:param name="fileIdentifier" select="''"/>
  <xsl:template match="metadata">
    
    <!-- geometryType for dc:type -->
    <xsl:variable name="geometryType">
      <xsl:choose>
      <xsl:when test="idinfo/keywords/theme/themekey[contains(.,'line')]">
      <xsl:text>Line</xsl:text>
      </xsl:when>
      <xsl:when test="idinfo/keywords/theme/themekey[contains(.,'point')]">
        <xsl:text>Point</xsl:text>
      </xsl:when>
      <xsl:when test="idinfo/keywords/theme/themekey[contains(.,'polygon')]">
        <xsl:text>Polygon</xsl:text>
      </xsl:when>
      <xsl:when test="spdoinfo/ptvctinf/esriterm/efeageom">
        <xsl:value-of select="spdoinfo/ptvctinf/esriterm/efeageom"/>
      </xsl:when>
      <xsl:when test="spdoinfo/direct[contains(., 'Raster')]">
        <xsl:text>Raster</xsl:text>
      </xsl:when> 
      <xsl:when test="spdoinfo/ptvctinf/sdtsterm/sdtstype[contains(., 'G-polygon')]">
        <xsl:text>Polygon</xsl:text>
      </xsl:when> 
     </xsl:choose>
    </xsl:variable>
    
    <!-- institution for mods:recordContentSource -->
    <xsl:variable name="institution">
      <xsl:choose>
        <xsl:when test="contains(distinfo/distrib/cntinfo/cntorgp/cntorg, 'Harvard')">
          <xsl:text>Harvard</xsl:text>
        </xsl:when> 
        <xsl:when test="contains(distinfo/distrib/cntinfo/cntorgp/cntorg, 'Tufts')">
          <xsl:text>Tufts</xsl:text>
        </xsl:when>
        <xsl:when test="contains(distinfo/distrib/cntinfo/cntorgp/cntorg, 'MIT')">
          <xsl:text>MIT</xsl:text>
        </xsl:when>
        <xsl:when test="contains(distinfo/distrib/cntinfo/cntorgp/cntorg, 'Massachusetts')">
          <xsl:text>MassGIS</xsl:text>
        </xsl:when>
        <xsl:when test="contains(metainfo/metc/cntinfo/cntorgp/cntorg, 'MassGIS')">
          <xsl:text>MassGIS</xsl:text>
        </xsl:when>
        <xsl:when test="contains(distinfo/distrib/cntinfo/cntemail, 'state.ma.us')">
          <xsl:text>MassGIS</xsl:text>
        </xsl:when>
        <xsl:when test="contains(metainfo/metc/cntinfo/cntemail, 'ca.gov')">
          <xsl:text>Berkeley</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <!-- fileidentifier for mods:recordIdentifier -->
    <xsl:variable name="recordID">
      <xsl:choose>
        <xsl:when test="contains($institution, 'Tufts')">
          <xsl:text>urn:geodata.tufts.edu:Tufts.</xsl:text>
          <xsl:value-of select="substring-before(tokenize(base-uri(), '/')[last()], '.xml')"/>
        </xsl:when> 
        <xsl:when test="contains($institution, 'MIT')">
          <xsl:text>urn:arrowsmith.mit.edu:MIT.SDE_DATA.</xsl:text>
          <xsl:value-of select="substring-before(tokenize(base-uri(), '/')[last()], '.xml')"/>
        </xsl:when> 
        <xsl:when test="contains($institution, 'Harvard')">
          <xsl:text>urn:hul.harvard.edu:HARVARD.</xsl:text>
          <xsl:value-of select="substring-before(tokenize(base-uri(), '/')[last()], '.xml')"/>
        </xsl:when> 
        <xsl:when test="contains($institution, 'MassGIS')">
          <xsl:text>urn:massgis.state.ma.us:MassGIS.</xsl:text>
          <xsl:value-of select="substring-before(tokenize(base-uri(), '/')[last()], '.xml')"/>
        </xsl:when> 
        <xsl:when test="contains($institution, 'Berkeley')">
          <xsl:text>urn:gis.library.berkeley.edu.</xsl:text>
          <xsl:value-of select="substring-before(tokenize(base-uri(), '/')[last()], '.xml')"/>
        </xsl:when> 
      </xsl:choose>
    </xsl:variable>
      

    <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
        <titleInfo>
          <title>
            <xsl:apply-templates select="idinfo/citation/citeinfo/title"/>
          </title>
        </titleInfo>
      
      <!-- kd: need to map alternate titles 
      <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle">
          <titleInfo>
            <title displayLabel="Alternative title">
              <xsl:value-of select="."/>
            </title>
          </titleInfo>
        </xsl:for-each> -->
      
        <xsl:for-each select="idinfo/citation/citeinfo/origin">
          <name>
                <namePart>
                  <xsl:value-of select="."/>
                </namePart>
                <role>
              <roleTerm type="text" authority="marcrelator">creator</roleTerm>
                </role>
              </name>
         </xsl:for-each>
          
        <!-- typeOfResource for SW - see http://www.loc.gov/standards/mods/v3/mods-userguide-elements.html -->
        <typeOfResource>cartographic</typeOfResource>
        <typeOfResource>software, multimedia</typeOfResource>
    
        <genre>
          <xsl:attribute name="authority">lcgft</xsl:attribute>
          <xsl:attribute name="valueURI">http://id.loc.gov/authorities/genreForms/gf2011026297</xsl:attribute>
          <xsl:text>Geospatial data</xsl:text>
        </genre>
        <genre>
          <xsl:attribute name="authority">rdacontent</xsl:attribute>
          <xsl:attribute name="valueURI">http://rdvocab.info/termList/RDAContentType/1001</xsl:attribute>
          <xsl:text>cartographic dataset</xsl:text>
        </genre>
       
      <originInfo>
          <xsl:for-each select="idinfo/citation/citeinfo/pubinfo/publish">
            <publisher>
              <xsl:value-of select="."/>
            </publisher>
          </xsl:for-each>
            <xsl:for-each select="idinfo/citation/citeinfo/pubinfo/pubplace">
              <place>
                <placeTerm type="text">
                  <xsl:value-of select="."/>
                </placeTerm>
              </place>
            </xsl:for-each>
        <xsl:choose>
          
          <!-- kd: set up xsl:analysis for dates with text, special characters.... -->
          
          <!-- converts 8 digit date to YYYY -->
          <xsl:when test="number(idinfo/citation/citeinfo/pubdate[(string-length()=8)])">
            <dateIssued encoding="w3cdtf" keyDate="yes">
      
              <xsl:value-of select="substring(idinfo/citation/citeinfo/pubdate,1,4)"/>
           </dateIssued>
          </xsl:when>
          
          <!-- converts 6 digit date to YYYY -->
          <xsl:when test="number(idinfo/citation/citeinfo/pubdate[(string-length()=6)])">
            <dateIssued encoding="w3cdtf" keyDate="yes">
              <xsl:value-of select="substring(idinfo/citation/citeinfo/pubdate,1,4)"/>
            </dateIssued>
          </xsl:when>
          
          <!-- converts 4 digit date to YYYY -->
          <xsl:when test="number(idinfo/citation/citeinfo/pubdate[(string-length()=4)])">
            <dateIssued encoding="w3cdtf" keyDate="yes">
              <!-- strip MM-DD, oupput YYYY -->
              <xsl:value-of select="idinfo/citation/citeinfo/pubdate"/>
            </dateIssued>
          </xsl:when>
          
          <!-- all other pubdates -->
          <xsl:otherwise>
            <dateIssued encoding="w3cdtf" keyDate="yes">
              <xsl:value-of select="idinfo/citation/citeinfo/pubdate"/>
            </dateIssued>
          </xsl:otherwise>
 
       </xsl:choose>

            
        <xsl:for-each select="idinfo/timeperd/timeinfo/mdattim/sngdate/caldate | idinfo/timeperd/timeinfo/sngdate/caldate">
                  <dateValid>
                     <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                         <xsl:value-of select="substring(.,1,4)"/>
                  </dateValid>
        </xsl:for-each>
        
        <xsl:for-each select="idinfo/timeperd/timeinfo/rngdates">
              <dateValid>
              <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
              <xsl:attribute name="point">start</xsl:attribute>
              <xsl:value-of select="substring(begdate,1,4)"/>
             </dateValid>
             <dateValid>
              <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
              <xsl:attribute name="point">end</xsl:attribute>
              <xsl:value-of select="substring(enddate,1,4)"/>
            </dateValid>
        </xsl:for-each>    
        
        <xsl:for-each select="idinfo/citation/citeinfo/edition">
            <edition>
              <xsl:value-of select="."/>
            </edition>
          </xsl:for-each>
        </originInfo>
      
      <!-- kd: default lang is 'eng' -->
      <language>
          <languageTerm authority="iso639-2b">
            <xsl:text>eng</xsl:text>
          </languageTerm>
        </language>
      
        <physicalDescription>
          <xsl:choose>
            <xsl:when test="distinfo/stdorder/digform/digtinfo/formname[contains(.,'SHP')]">
              <form>
                <xsl:text>Shapefile</xsl:text>
              </form>
            </xsl:when>
            <xsl:when test="distinfo/stdorder/digform/digtinfo/formname">
          <form>
               <xsl:value-of select="distinfo/stdorder/digform/digtinfo/formname"/>
          </form>
            </xsl:when>
              
            <xsl:when test="distInfo/distributor/distorFormat/formatName">
              <form>
                <xsl:value-of select="distInfo/distributor/distorFormat/formatName"/>
              </form>
            </xsl:when>
       
          </xsl:choose>
          <xsl:for-each select="distinfo/stdorder/digform/digtinfo/transize">
            <extent>
                <xsl:value-of select="."/>
            </extent>
           <!-- The digitalOrigin is coded here: 
               http://www.loc.gov/standards/mods/v3/mods-userguide-elements.html#digitalorigin
            -->
          </xsl:for-each>
          <digitalOrigin>born digital</digitalOrigin>
        </physicalDescription>
        <subject>
          <cartographics>
            <xsl:choose>
              <xsl:when test="number(dataqual/lineage/srcinfo/srcscale)">
                <scale>
                  <xsl:text>1:</xsl:text>
                  <xsl:value-of select="dataqual/lineage/srcinfo/srcscale"/>
                </scale>
              </xsl:when>
              <xsl:otherwise>
                <scale>
                  <xsl:text>Scale not given.</xsl:text>
                </scale>
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
            <xsl:when test="spref/horizsys/planar/mapproj">
            <projection>
              <xsl:value-of select="spref/horizsys/planar/mapproj/mapprojn"/>
            </projection>
            </xsl:when>
              <xsl:when test="spref/horizsys/cordsysn/projcsn">
                <projection>
                  <xsl:value-of select="spref/horizsys/cordsysn/projcsn"/>
                </projection>
              </xsl:when>
            </xsl:choose>
            
        
            
            
            <xsl:for-each select="idinfo/spdom/bounding">
              <coordinates>
                <xsl:choose>
                  <xsl:when test="$geoformat = 'GMD'">
                    
                    <xsl:value-of select="westbc"/>
                    <xsl:text> -- </xsl:text>
                    <xsl:value-of select="eastbc"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="northbc"/>
                    <xsl:text> -- </xsl:text>
                    <xsl:value-of select="southbc"/>
                  </xsl:when>
                  <!-- WKT is x y, x y
                    
                         POLYGON((sw, nw, ne, se, sw))
                         -->
                  <xsl:when test="$geoformat = 'WKT'">
                    <xsl:text>POLYGON((</xsl:text>
                    <xsl:value-of select="westbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="southbc"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="westbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="northbc"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="eastbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="northbc"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="eastbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="southbc"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="westbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="southbc"/>
                    <xsl:text>))</xsl:text>
                  </xsl:when>
                  <xsl:when test="$geoformat = 'WMS'">
                    <!-- WMS
                         Uses min/max as attributes
                         
                         Example:
                         
                         <wms:BoundingBox xmlns:wms="http://www.opengis.net/wms" 
                                          CRS="EPSG:4326" 
                                          minx="-97.119945" miny="25.467075" 
                                          maxx="-82.307619" maxy="30.665492"/>
                      -->
                    <wms:BoundingBox xmlns:wms="http://www.opengis.net/wms">
                      <xsl:attribute name="CRS">EPSG:4326</xsl:attribute>
                      <xsl:attribute name="minx">
                        <xsl:value-of select="westbc"/>
                      </xsl:attribute>
                      <xsl:attribute name="miny">
                        <xsl:value-of select="southbc"/>
                      </xsl:attribute>
                      <xsl:attribute name="maxx">
                        <xsl:value-of select="eastbc"/>
                      </xsl:attribute>
                      <xsl:attribute name="maxy">
                        <xsl:value-of select="northbc"/>
                      </xsl:attribute>
                    </wms:BoundingBox>
                  </xsl:when>
                  <xsl:when test="$geoformat = 'GML'">
                    <!-- GML
                       Using SW and NE corners in (x, y) coordinates
                       
                       Example:
                       
                       <gml:Envelope xmlns:gml="http://www.opengis.net/gml/3.2" srsName="EPSG:4326">
                         <gml:lowerCorner>-97.119945 25.467075</gml:lowerCorner>
                         <gml:upperCorner>-82.307619 30.665492</gml:upperCorner>
                       </gml:Envelope>
                    -->
                    <gml:Envelope xmlns:gml="http://www.opengis.net/gml/3.2">
                      <xsl:attribute name="srsName">
                        <xsl:value-of select="//gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="//gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"/>
                      </xsl:attribute>
                      <gml:lowerCorner>
                        <xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/>
                      </gml:lowerCorner>
                      <gml:upperCorner>
                        <xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/>
                      </gml:upperCorner>
                    </gml:Envelope>
                  </xsl:when>
                  <xsl:when test="$geoformat = 'GeoRSS'">
                    <!-- GeoRSS:
                      Rectangular envelope property element containing two pairs of coordinates 
                      (lower left envelope corner, upper right envelope corner) representing 
                      latitude then longitude in the WGS84 coordinate reference system.
                      
                      Example:
                      
                      <georss:box>42.943 -71.032 43.039 -69.856</georss:box>
                      -->
                    <georss:box xmlns:georss="http://www.georss.org/georss">
                      <xsl:value-of select="southbc"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="westbc"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="northbc"/>
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="eastbc"/>
                    </georss:box>
                  </xsl:when>
                  <xsl:when test="$geoformat = 'MARC034'">
                    <!-- MARC 034
                       Subfields $d, $e, $f, and $g always appear together. The coordinates 
                       may be recorded in the form hdddmmss (hemisphere-degrees-minutes-seconds), 
                       however, other forms are also allowed, such as decimal degrees. 
                       The subelements are each right justified and unused positions contain zeros.

                       $d - Coordinates - westernmost longitude (NR)
                       $e - Coordinates - easternmost longitude (NR)
                       $f - Coordinates - northernmost latitude (NR)
                       $g - Coordinates - southernmost latitude (NR)
                       
                       Example:
                       
                       $d-097.119945$e-082.307619$f+30.665492$g+25.467075

                       See http://www.w3.org/TR/1999/REC-xslt-19991116#format-number
                    -->
                    <xsl:text>$d</xsl:text>
                    <xsl:value-of select="format-number(westbc, '+000.000000;-000.000000')"/>
                    <xsl:text>$e</xsl:text>
                    <xsl:value-of select="format-number(eastbc, '+000.000000;-000.000000')"/>
                    <xsl:text>$f</xsl:text>
                    <xsl:value-of select="format-number(nothbc, '+00.000000;-00.000000')"/>
                    <xsl:text>$g</xsl:text>
                    <xsl:value-of select="format-number(southbc, '+00.000000;-00.000000')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- MARC 255 $c:
                         Coordinates are recorded in the order of 
                         westernmost longitude, easternmost longitude, 
                         northernmost latitude, and southernmost latitude,
                         and separated with double-hyphen and / characters.
                         
                         XXX: Note that this leaves the coordinates in decimal
                              degrees whereas 255c suggests deg-min-sec.
                         
                         Example:
                         
                         -97.119945 &#x002D;&#x002D; -82.307619/30.665492 &#x002D;&#x002D; 25.467075
                         
                         See http://www.loc.gov/marc/bibliographic/bd255.html $c
                         -->
                    
                    <xsl:value-of select="westbc"/>
                    <xsl:text> -- </xsl:text>
                    <xsl:value-of select="eastbc"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="northbc"/>
                    <xsl:text> -- </xsl:text>
                    <xsl:value-of select="southbc"/>
                  </xsl:otherwise>
                </xsl:choose>
              </coordinates>
            </xsl:for-each>
          </cartographics>
        </subject>
        <xsl:for-each select="idinfo/descript/abstract">
          <abstract displayLabel="Abstract">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="."/>
          </abstract>
        </xsl:for-each>
      <xsl:for-each select="idinfo/descript/purpose">
          <abstract displayLabel="Purpose">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="."/>
          </abstract>
        </xsl:for-each>
      
        <!-- Reports, citation, other info, etc.  
        <xsl:for-each select="dataqual">
          <note displayLabel="Conceptual consistency report">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="."/>
          </note>
        </xsl:for-each>
      <xsl:for-each select="dataqual">
          <note displayLabel="Attribute accuracy report">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="."/>
          </note>
        </xsl:for-each>
        <xsl:for-each select="idinfo/datacred">
          <note displayLabel="Preferred citation">
            <xsl:attribute name="lang">eng</xsl:attribute>
            <xsl:value-of select="."/>
          </note>
        </xsl:for-each>
      <xsl:for-each select="idinfo/descript/supplinf">
          <note displayLabel="Supplemental information">
            <xsl:value-of select="."/>
          </note>
        </xsl:for-each> -->

       
        <!-- MODS relatedItem types: host, series, isReferencedby-->
 
          <xsl:for-each select="idinfo/citation/citeinfo/lworkcit">
                <relatedItem>
      <xsl:attribute name="type">host</xsl:attribute>
                  <titleInfo>
                    <title>
                      <xsl:value-of select="citeinfo/title"/>
                    </title>
                  </titleInfo>

                  <xsl:if test="citeinfo/origin">

                    <name>
                        <namePart>
                          <xsl:value-of select="citeinfo/origin"/>
                        </namePart>
                      </name>
                    
                    </xsl:if>
                   <originInfo>
                    <xsl:if test="citeinfo/pubinfo/publish">
                        <publisher>
                          <xsl:value-of select="citeinfo/pubinfo/publish"/>
                        </publisher>
                     </xsl:if>
                     <xsl:if test="citeinfo/pubdate">
                    <dateIssued encoding="w3cdtf" keyDate="yes">
                      <!-- strip MM-DD, oupput YYYY -->
                      <xsl:value-of select="substring(citeinfo/pubdate,1,4)"/>
                    </dateIssued>
                     </xsl:if>
                  </originInfo>
                </relatedItem>
          </xsl:for-each>
           
      <xsl:for-each select="idinfo/crossref">
        <relatedItem>
          <xsl:attribute name="type">isReferencedBy</xsl:attribute>
         <titleInfo>
            <title>
              <xsl:value-of select="citeinfo/title"/>
            </title>
          </titleInfo>
          
          <xsl:if test="citeinfo/origin">
              <name>
              <namePart>
                <xsl:value-of select="citeinfo/origin"/>
              </namePart>
            </name>
          </xsl:if>
          <originInfo>
            <xsl:if test="citeinfo/pubinfo/publish">
              <publisher>
                <xsl:value-of select="citeinfo/pubinfo/publish"/>
              </publisher>
            </xsl:if>
            <xsl:if test="citeinfo/pubdate">
              <dateIssued encoding="w3cdtf" keyDate="yes">
                <!-- strip MM-DD, oupput YYYY -->
                <xsl:value-of select="substring(citeinfo/pubdate,1,4)"/>
              </dateIssued>
            </xsl:if>
          </originInfo>
        </relatedItem>
      </xsl:for-each>
              
            
<!-- subjects: topic, geographic, temporal, ISO19115TopicCategory -->


      <xsl:for-each select="idinfo/keywords/place">
      <xsl:choose>
      <xsl:when test="contains(placekt, 'FIPS')"/> 
      
        <xsl:when test="placekey">
          <xsl:for-each select="placekey">
             <subject>
                <geographic>
                  <!-- adds geonames info through external process -->
                  <xsl:if test="ancestor-or-self::*/placekt">
                     <xsl:attribute name="authority">
                       <xsl:choose>
                    <xsl:when test="ancestor-or-self::*/placekt[contains(.,'LCNH')]">
                     <xsl:text>lcnaf</xsl:text>
                    </xsl:when>
                         <xsl:when test="ancestor-or-self::*/placekt[contains(.,'LCSH')]">
                           <xsl:text>lcsh</xsl:text>
                         </xsl:when>
                       <xsl:otherwise>            
                    <xsl:value-of select="ancestor-or-self::*/placekt"/>
                       </xsl:otherwise>
                       </xsl:choose>
                  </xsl:attribute>
                  
                  </xsl:if>
                
                  <xsl:attribute name="lang">eng</xsl:attribute>
                  <xsl:value-of select="."/>

                </geographic>
              </subject>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
      </xsl:for-each>
    

<xsl:choose> 
  
  <xsl:when test="idinfo/keywords/temporal/tempkey">
    <xsl:for-each select="idinfo/keywords/temporal/tempkey">
    <subject>
      <temporal>
        <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
        <xsl:value-of select="substring(.,1,4)"/>
      </temporal>
    </subject>
    </xsl:for-each>
  </xsl:when>  
    
      <xsl:when test="idinfo/timeperd/timeinfo/mdattim/sngdate/caldate | idinfo/timeperd/timeinfo/sngdate/caldate">
        <xsl:for-each select="idinfo/timeperd/timeinfo/mdattim/sngdate/caldate | idinfo/timeperd/timeinfo/sngdate/caldate">
         <subject>
             <temporal>
                   <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
                   <xsl:value-of select="substring(.,1,4)"/>
             </temporal>
         </subject>
        </xsl:for-each>
      </xsl:when>    
      
      <xsl:when test="idinfo/timeperd/timeinfo/rngdates">
        <xsl:for-each select="idinfo/timeperd/timeinfo/rngdates">
        <subject>
          <temporal>
            <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
            <xsl:attribute name="point">start</xsl:attribute>
            <xsl:value-of select="substring(begdate,1,4)"/>
          </temporal>
          <temporal>
            <xsl:attribute name="encoding">w3cdtf</xsl:attribute>
            <xsl:attribute name="point">end</xsl:attribute>
            <xsl:value-of select="substring(enddate,1,4)"/>
          </temporal>
        </subject>
        </xsl:for-each>
      </xsl:when>    
   </xsl:choose>      
     
       
    <xsl:for-each select="idinfo/keywords/theme">
          <xsl:choose>
            <xsl:when test="themekt[contains(.,'19115')]">
            <xsl:for-each select="themekey">
           <subject>
            <topic>
              <xsl:attribute name="authority">ISO19115TopicCategory</xsl:attribute>
               
             <!-- kd: do we need authorityURI? -->
               <xsl:attribute name="authorityURI">
                 <xsl:text>http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_TopicCategoryCode</xsl:text>
                </xsl:attribute>


              <xsl:if test="contains(.,'farming')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Farming</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'biota')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Biology and Ecology</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'climatologyMeteorologyAtmosphere')">\
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Climatology, Meteorology and Atmosphere</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'boundaries')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Boundaries</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'elevation')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Elevation</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'environment')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Environment</xsl:text>
                </xsl:if> 
                <xsl:if test="contains(.,'geoscientificInformation')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Geoscientific Information</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'health')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Health</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'imageryBaseMapsEarthCover')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Imagery and Base Maps</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'intelligenceMilitary')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Military</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'inlandWaters')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Inland Waters</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'location')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Location</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'oceans')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Oceans</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'planningCadastre')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Planning and Cadastral</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'structure')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Structures</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'transportation')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Transportation</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'utilitiesCommunication')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Utilities and Communication</xsl:text>
                </xsl:if>
                <xsl:if test="contains(.,'society')">
                  <xsl:attribute name="valueURI"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:text>Society</xsl:text>
                </xsl:if>
 
            </topic>
          </subject>
            </xsl:for-each>
            </xsl:when>
          
            <xsl:when test="contains(themekt, 'LCSH')">
              <xsl:for-each select="themekey">
                <subject>
                  <topic>
                    <xsl:attribute name="authority">lcsh</xsl:attribute>
                    <xsl:attribute name="lang">eng</xsl:attribute>
                    <xsl:value-of select="."/>
                  </topic>
                </subject>
               </xsl:for-each>
            </xsl:when>
            
            <!-- GCMD keywords -->
            <xsl:when test="contains(themekt, 'GCMD')">
             <xsl:for-each select="tokenize(themekey, ' &gt; ')">
              <subject>
                <topic>
                  <xsl:attribute name="authority">gcmd</xsl:attribute>
                  <xsl:attribute name="lang">eng</xsl:attribute>
                  <xsl:value-of select="."/>
                </topic>
              </subject>
            </xsl:for-each>
            </xsl:when>
           <xsl:otherwise>
             
             <xsl:for-each select="themekey">
              <subject>
                <topic>
                  <xsl:attribute name="lang">eng</xsl:attribute>
                <xsl:value-of select="."/>
               </topic>
              </subject>
            </xsl:for-each>
              </xsl:otherwise>
          </xsl:choose>   
  </xsl:for-each>
    
        <!-- TODO: Need a metadata practice for GIS Dataset's Online Resource. -->
        <!-- access rights to be mapped from restrictionCode/otherRestrictions/APO -->
        <xsl:for-each select="idinfo/accconst">
          <accessCondition type="restriction on access">
            <xsl:value-of select=". "/>
          </accessCondition>
        </xsl:for-each>
      <xsl:for-each select="idinfo/useconst">
        <accessCondition type="use and reproduction">
          <xsl:value-of select=". "/>
        </accessCondition>
      </xsl:for-each>
      
      <!-- MODS recordInfo -->
      
      <recordInfo>
        <recordContentSource>
          <xsl:value-of select="$institution"/>
        </recordContentSource>
        <recordIdentifier>
          <xsl:value-of select="$recordID"/>
        </recordIdentifier>
        <recordOrigin>This record was translated from FGDC Content Standards for Digital Geospatial Metadata to MODS v.3 using an xsl transformation.</recordOrigin>
          <languageOfCataloging>
            <languageTerm authority="iso639-2b" type="code">eng</languageTerm>
          </languageOfCataloging>
      </recordInfo>
        
        <!-- Output minimal geo extension to MODS -->
      <xsl:if test="idinfo/spdom/bounding">
        <extension displayLabel="geo" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <rdf:RDF xmlns:gml="http://www.opengis.net/gml/3.2/" xmlns:dc="http://purl.org/dc/elements/1.1/">
            <rdf:Description>
              <xsl:attribute name="rdf:about">
                <xsl:value-of select="$purl"/>
              </xsl:attribute>
              <!-- Output MIME type -->
              <dc:format>
                <xsl:value-of select="$format"/>
              </dc:format>
              <!-- Output Dataset# point, linestring, polygon, raster, etc. -->
              <dc:type>
                <xsl:text>Dataset#</xsl:text>
                <xsl:value-of select="$geometryType"/>
              </dc:type>
              <gml:boundedBy>
                <gml:Envelope>
                  <xsl:attribute name="gml:srsName">
                    <xsl:text>EPSG:4326</xsl:text>
                  </xsl:attribute>
                  <gml:lowerCorner>
                    <xsl:value-of select="idinfo/spdom/bounding/westbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="idinfo/spdom/bounding/southbc"/>
                  </gml:lowerCorner>
                  <gml:upperCorner>
                    <xsl:value-of select="idinfo/spdom/bounding/eastbc"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="idinfo/spdom/bounding/northbc"/>
                  </gml:upperCorner>
                </gml:Envelope>
              </gml:boundedBy>
            </rdf:Description>
          </rdf:RDF>
        </extension>
      </xsl:if>
      
    </mods>
  </xsl:template>
</xsl:stylesheet>
