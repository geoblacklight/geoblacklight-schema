<?xml version="1.0" encoding="UTF-8"?>
<!--
     mods2ogp.xsl - Transforms MODS with GML extensions into an OGP Solr document

     Copyright 2013, Stanford University Libraries.

     Created by Darren Hardy.

     For OGP Solr schema, see:

       https://github.com/OpenGeoportal/ogpSolrConfig/blob/master/ogpSolrConfig/SolrConfig/schema.xml

     Example usage:

     xsltproc -stringparam geoserver_root 'http://kurma-podd1.stanford.edu/geoserver'
              -stringparam purl 'http://purl-dev.stanford.edu/fw920bc5473'
              -output '/var/geomdtk/current/workspace/fw/920/bc/5473/fw920bc5473/temp/ogpSolr.xml'
              '/home/geostaff/geomdtk/current/lib/geomdtk/mods2ogp.xsl'
              '/var/geomdtk/current/workspace/fw/920/bc/5473/fw920bc5473/metadata/descMetadata.xml'

     Requires parameters:

       - geoserver_root - URL prefix to the geoserver
       - purl - complete URL with aa111bb1111 (len = 11)

     -->
<xsl:stylesheet xmlns="http://lucene.apache.org/solr/4/document" xmlns:gml="http://www.opengis.net/gml/3.2/" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="gml mods rdf xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/mods:mods">
    <xsl:variable name="druid" select="substring($purl, string-length($purl)-10)"/>
    <add>
      <doc>
        <field name="LayerId">
          <!-- REQUIRED -->
          <xsl:value-of select="$druid"/>
        </field>
        <field name="Name">
          <!-- REQUIRED -->
          <xsl:value-of select="$druid"/>
        </field>
        <field name="ExternalLayerId">
          <xsl:value-of select="$purl"/>
        </field>
        <field name="CollectionId">
          <xsl:value-of select="mods:relatedItem/mods:titleInfo/mods:title"/>
        </field>
        <field name="Access">
          <!-- REQUIRED: Uses Public due to GIS-7 -->
          <xsl:text>Public</xsl:text>
        </field>
        <field name="Institution">
          <!-- REQUIRED -->
          <xsl:text>Stanford</xsl:text>
        </field>
        <field name="WorkspaceName">
          <xsl:text>druid</xsl:text>
        </field>
        <field name="GeoReferenced">
          <xsl:text>true</xsl:text>
        </field>
        <field name="Availability">
          <xsl:text>Online</xsl:text>
        </field>
        <xsl:comment>XXX - MODS data are year only but OGP's solr schema requires full date</xsl:comment>
        <field name="ContentDate">
          <xsl:choose>
            <xsl:when test="mods:subject/mods:temporal">
              <xsl:value-of select="substring(mods:subject/mods:temporal, 1, 4)"/>
              <xsl:text>-01-01T00:00:00Z</xsl:text>
            </xsl:when>
            <xsl:when test="mods:originInfo/mods:dateIssued">
              <xsl:value-of select="substring(mods:originInfo/mods:dateIssued, 1, 4)"/>
              <xsl:text>-01-01T00:00:00Z</xsl:text>
            </xsl:when>
          </xsl:choose>
        </field>
        <field name="LayerDisplayName">
          <!-- REQUIRED -->
          <xsl:value-of select="mods:titleInfo/mods:title[not(@type)]"/>
        </field>
        <!-- <xsl:value-of select="'XXX'"/> -->
        <xsl:for-each select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/dc:type">
          <field name="DataType">
            <xsl:choose>
              <xsl:when test="substring(., 9)='LineString'">
                <xsl:text>Line</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='substring(., 9)'/><!-- strip Dataset# prefix -->
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </xsl:for-each>
        <field name="Publisher">
          <xsl:value-of select="mods:originInfo/mods:publisher"/>
        </field>
        <field name="Originator">
          <xsl:for-each select="mods:name">
            <xsl:value-of select="mods:namePart"/>
            <xsl:if test="position()!=last()">
              <xsl:text>; </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </field>
        <field name="Abstract">
          <xsl:for-each select="mods:abstract[@displayLabel='Abstract' or @displayLabel='Purpose']/text()">
            <xsl:value-of select="."/>
            <xsl:text>; </xsl:text>
          </xsl:for-each>
        </field>
        <field name="ThemeKeywords">
          <xsl:for-each select="mods:subject/mods:topic">
            <xsl:choose>
              <xsl:when test="@authority='ISO19115topicCategory'">
                <xsl:value-of select="@valueURI"/>
              </xsl:when>
              
              <xsl:otherwise>
                <xsl:value-of select="text()"/>
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text>; </xsl:text>
          </xsl:for-each>
          
        </field>
        <field name="PlaceKeywords">
          <xsl:for-each select="mods:subject/mods:geographic">
            <xsl:value-of select="text()"/>
            <xsl:text>; </xsl:text>
          </xsl:for-each>
        </field>
        <xsl:for-each select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/gml:boundedBy/gml:Envelope">
          <xsl:variable name="x2" select="number(substring-before(gml:upperCorner/text(), ' '))"/>
          <xsl:variable name="x1" select="number(substring-before(gml:lowerCorner/text(), ' '))"/>
          <xsl:variable name="y2" select="number(substring-after(gml:upperCorner/text(), ' '))"/>
          <xsl:variable name="y1" select="number(substring-after(gml:lowerCorner/text(), ' '))"/>
          <field name="MinX">
            <xsl:value-of select="$x1"/>
          </field>
          <field name="MinY">
            <xsl:value-of select="$y1"/>
          </field>
          <field name="MaxX">
            <xsl:value-of select="$x2"/>
          </field>
          <field name="MaxY">
            <xsl:value-of select="$y2"/>
          </field>
          <xsl:comment> XXX: doesn't work across meridian </xsl:comment>
          <field name="CenterX">
            <xsl:value-of select="($x2 - $x1) div 2 + $x1"/>
          </field>
          <xsl:comment> XXX: doesn't work across meridian </xsl:comment>
          <field name="CenterY">
            <xsl:value-of select="($y2 - $y1) div 2 + $y1"/>
          </field>
          <xsl:comment> XXX: in degrees ??? </xsl:comment>
          <field name="HalfWidth">
            <xsl:value-of select="($x2 - $x1) div 2"/>
          </field>
          <xsl:comment> XXX: in degrees ??? </xsl:comment>
          <field name="HalfHeight">
            <xsl:value-of select="($y2 - $y1) div 2"/>
          </field>
          <xsl:comment> XXX: in degrees**2 ??? </xsl:comment>
          <field name="Area">
            <xsl:value-of select="round(($y2 - $y1) * ($x2 - $x1))"/>
          </field>
          <field name="SrsProjectionCode">
            <xsl:value-of select="@srsName"/>
          </field>
        </xsl:for-each>
        <field name="Location">
          <!-- output is JSON so we wrap in CDATA -->
          <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
          <xsl:text>{
              "wms":       ["</xsl:text>
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wms"],
              "wfs":       ["</xsl:text>
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wfs"],
              "purl":      ["</xsl:text>
          <xsl:value-of select="$purl"/>
          <xsl:text>"] }</xsl:text>
          <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
        <field name="FgdcText"/>
      </doc>
    </add>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
