<?xml version="1.0" encoding="UTF-8"?>
<!--
     mods2geoblacklight.xsl - Transforms MODS with GML extensions into a GeoBlacklight document

     Copyright 2014, Stanford University Libraries.

     Created by Darren Hardy.

     Example usage:

     xsltproc -stringparam geoserver_root 'http://kurma-podd1.stanford.edu/geoserver'
              -stringparam now '2014-04-30T21:17:41Z'
              -output '/var/geomdtk/current/workspace/fw/920/bc/5473/fw920bc5473/temp/geoblacklightSolr.xml'
              '/home/geostaff/geomdtk/current/lib/geomdtk/mods2geoblacklight.xsl'
              '/var/geomdtk/current/workspace/fw/920/bc/5473/fw920bc5473/metadata/descMetadata.xml'

     Requires parameters:

       - geoserver_root - URL prefix to the geoserver
       - now - the current date/time

     -->
<xsl:stylesheet xmlns="http://lucene.apache.org/solr/4/document" xmlns:gml="http://www.opengis.net/gml/3.2/" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="gml mods rdf xsl dc">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/mods:mods">
    <!-- XXX: Handle other institution naming schemes -->
    <xsl:variable name="purl" select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/@rdf:about"/>
    <xsl:variable name="druid" select="substring($purl, string-length($purl)-10)"/>
    <add>
      <doc>
        <field name="uuid">
          <xsl:value-of select="$purl"/>
        </field>
        <field name="dc_identifier_s">
          <xsl:value-of select="$purl"/>
        </field>
        <field name="dc_title_s">
          <xsl:value-of select="mods:titleInfo/mods:title[not(@type)]/text()"/>
        </field>
        <field name="dc_description_s">
          <xsl:for-each select="mods:abstract[@displayLabel='Abstract' or @displayLabel='Purpose']">
            <xsl:value-of select="text()"/>
          </xsl:for-each>
        </field>
        <!-- XXX: Handle other institutions - get from MODS -->
        <field name="dc_rights_s">
          <xsl:text>Restricted</xsl:text>
        </field>
        <!-- XXX: Handle other institutions -->
        <field name="dct_provenance_s">
          <xsl:text>Stanford</xsl:text>
        </field>
        <field name="dct_references_s">
          <xsl:text>{</xsl:text>
          <xsl:text>"http://schema.org/url":"</xsl:text>              
          <xsl:value-of select="$purl"/>
          <xsl:text>",</xsl:text>
          <xsl:text>"http://schema.org/thumbnailUrl":"</xsl:text>              
          <xsl:value-of select="$purl"/>
          <xsl:text>.jpg",</xsl:text>
          <xsl:text>"http://www.loc.gov/mods/v3":"</xsl:text>              
          <xsl:value-of select="$purl"/>
          <xsl:text>.mods",</xsl:text>
          <xsl:text>"http://www.isotc211.org/schemas/2005/gmd/":"</xsl:text>              
          <xsl:value-of select="$purl"/>
          <xsl:text>.iso19139",</xsl:text>
          <xsl:text>"http://www.opengis.net/def/serviceType/ogc/wms":"</xsl:text>
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wms",</xsl:text>
          <xsl:text>"http://www.opengis.net/def/serviceType/ogc/wfs":"</xsl:text>
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wfs",</xsl:text>
          <xsl:text>"http://www.opengis.net/def/serviceType/ogc/wcs":"</xsl:text>
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wcs"</xsl:text>
          <xsl:text>}</xsl:text>
        </field>
        <!-- XXX: Handle other institution naming schemes -->
        <field name="layer_id_s">
          <xsl:text>druid:</xsl:text><xsl:value-of select="$druid"/>
        </field>
        <!-- XXX: Handle other institutions -->
        <field name="layer_slug_s">
          <xsl:text>stanford-</xsl:text><xsl:value-of select="$druid"/>
        </field>
        <xsl:for-each select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/dc:type">
          <field name="layer_geom_type_s">
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
        <field name="layer_modified_dt">
          <xsl:value-of select='$now'/>
        </field>
        <!-- XXX: handle GeoTIFF -->
        <field name="dc_format_s">
          <xsl:text>Shapefile</xsl:text>
        </field>
        <!-- XXX: Handle other languages - get from MODS -->
        <field name="dc_language_s">
          <xsl:text>English</xsl:text>
        </field>
        <!-- XXX: Handle Image and PhysicalObject -->
        <field name="dc_type_s">
          <xsl:text>Dataset</xsl:text>
        </field>
        <field name="dc_publisher_s">
          <xsl:value-of select="mods:originInfo/mods:publisher"/>
        </field>
        <xsl:for-each select="mods:name">
          <field name="dc_creator_sm">
            <xsl:value-of select="mods:namePart"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="mods:subject/mods:topic">
          <field name="dc_subject_sm">
            <xsl:choose>
              <xsl:when test="@authority='ISO19115topicCategory'">
                <xsl:value-of select="@valueURI"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="text()"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:dateIssued">
            <field name="dct_issued_s">
              <xsl:value-of select="mods:originInfo/mods:dateIssued"/>
            </field>
          </xsl:when>
        </xsl:choose>
        <xsl:for-each select="mods:subject/mods:temporal">
          <field name="dct_temporal_sm">
            <xsl:value-of select="text()"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="mods:relatedItem/mods:titleInfo/mods:title">
          <field name="dct_isPartOf_sm">
            <xsl:value-of select="text()"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="mods:subject/mods:geographic">
          <field name="dct_spatial_sm">
            <xsl:value-of select="text()"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/dc:coverage">
          <field name="dct_spatial_sm">
            <xsl:value-of select="@dc:title"/>
          </field>
          <xsl:if test="@rdf:resource!=''">
            <field name="dc_relation_sm">
              <xsl:value-of select="@rdf:resource"/>
            </field>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/gml:boundedBy/gml:Envelope">
          <xsl:variable name="x2" select="number(substring-before(gml:upperCorner/text(), ' '))"/><!-- E -->
          <xsl:variable name="x1" select="number(substring-before(gml:lowerCorner/text(), ' '))"/><!-- W -->
          <xsl:variable name="y2" select="number(substring-after(gml:upperCorner/text(), ' '))"/><!-- N -->
          <xsl:variable name="y1" select="number(substring-after(gml:lowerCorner/text(), ' '))"/><!-- S -->
          <field name="georss_box_s">
            <xsl:value-of select="$y1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x2"/>
          </field>
          <field name="georss_polygon_s">
            <xsl:text></xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x1"/>
          </field>
          <field name="solr_geom">
            <xsl:text>ENVELOPE(</xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$x2"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$y2"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text>)</xsl:text>
          </field>
          <field name="solr_bbox">
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$x2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y2"/>
          </field>
          <field name="solr_sw_pt">
            <xsl:value-of select="$y1"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$x1"/>
          </field>
          <field name="solr_ne_pt">
            <xsl:value-of select="$y2"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$x2"/>
          </field>
        </xsl:for-each>
        <field name="solr_year_i">
          <xsl:value-of select="substring(mods:subject/mods:temporal[1]/text(), 1, 4)"/>
        </field>
        <field name="solr_wms_url">
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wms</xsl:text>
        </field>
        <!-- XXX: need to check for WFS vs WCS -->
        <field name="solr_wfs_url">
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wfs</xsl:text>
        </field>
        <field name="solr_wcs_url">
          <xsl:value-of select="$geoserver_root"/>
          <xsl:text>/wcs</xsl:text>
        </field>
      </doc>
    </add>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
