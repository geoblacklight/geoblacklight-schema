<?xml version="1.0" encoding="UTF-8"?>
<!--
     mods2geoblacklight.xsl - Transforms MODS with GML extensions into a GeoBlacklight document

     Copyright 2014, Stanford University Libraries.

     Created by Darren Hardy.

     Example usage:

     xsltproc -stringparam geoserver_root 'http://kurma-podd1.stanford.edu/geoserver'
              -stringparam purl 'http://purl-dev.stanford.edu/fw920bc5473'
              -output '/var/geomdtk/current/workspace/fw/920/bc/5473/fw920bc5473/temp/geoblacklightSolr.xml'
              '/home/geostaff/geomdtk/current/lib/geomdtk/mods2geoblacklight.xsl'
              '/var/geomdtk/current/workspace/fw/920/bc/5473/fw920bc5473/metadata/descMetadata.xml'

     Requires parameters:

       - geoserver_root - URL prefix to the geoserver
       - purl - complete URL with aa111bb1111 (len = 11)

     -->
<xsl:stylesheet xmlns="http://lucene.apache.org/solr/4/document" xmlns:gml="http://www.opengis.net/gml/3.2/" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:georss="http://www.georss.org/georss" version="1.0" exclude-result-prefixes="gml mods georss rdf xsl">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/mods:mods">
    <xsl:variable name="druid" select="substring($purl, string-length($purl)-10)"/>
    <add>
      <doc>
        <field name="uuid">
          <xsl:value-of select="$purl"/>
        </field>
        <field name="dc_identifier_s">
          <xsl:value-of select="$purl"/>
        </field>
        <field name="dct_isPartOf_sm">
          <xsl:value-of select="mods:relatedItem/mods:titleInfo/mods:title"/>
        </field>
        <field name="dc_format_s">
          <xsl:text>Shapefile</xsl:text>
        </field>
        <field name="dc_language_s">
          <xsl:text>English</xsl:text>
        </field>
        <field name="dc_rights_s">
          <xsl:text>Restricted</xsl:text>
        </field>
        <field name="dct_provenance_s">
          <xsl:text>Stanford</xsl:text>
        </field>
        <field name="dc_type_s">
          <xsl:text>Dataset</xsl:text>
        </field>
        <field name="layer_id_s">
          <xsl:text>druid:</xsl:text><xsl:value-of select="$druid"/>
        </field>
        <field name="layer_slug_s">
          <xsl:text>stanford-</xsl:text><xsl:value-of select="$druid"/>
        </field>
        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:dateValid">
            <field name="dc_date_dt">
              <xsl:value-of select="substring(mods:originInfo/mods:dateIssued, 1, 4)"/>
              <xsl:text>-01-01T01:01:01Z</xsl:text>
            </field>
          </xsl:when>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="mods:originInfo/mods:dateValid">
            <field name="solr_year_i">
              <xsl:value-of select="substring(mods:originInfo/mods:dateIssued, 1, 4)"/>
            </field>
          </xsl:when>
        </xsl:choose>
        <field name="dct_temporal_sm">
          <xsl:choose>
            <xsl:when test="mods:subject/mods:temporal">
              <xsl:value-of select="substring(mods:subject/mods:temporal, 1, 4)"/>
            </xsl:when>
            <xsl:when test="mods:originInfo/mods:dateIssued">
              <xsl:value-of select="substring(mods:originInfo/mods:dateIssued, 1, 4)"/>
            </xsl:when>
          </xsl:choose>
        </field>
        <field name="dc_title_s">
          <xsl:value-of select="mods:titleInfo/mods:title[not(@type)]"/>
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
        <field name="dc_publisher_s">
          <xsl:value-of select="mods:originInfo/mods:publisher"/>
        </field>
        <field name="dc_creator_s">
          <xsl:for-each select="mods:name">
            <xsl:value-of select="mods:namePart"/>
            <xsl:if test="position()!=last()">
              <xsl:text>; </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </field>
        <field name="dc_description_s">
          <xsl:for-each select="mods:abstract[@displayLabel='Abstract' or @displayLabel='Purpose']/text()">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </field>
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
        <xsl:for-each select="mods:subject/mods:geographic">
          <field name="dct_spatial_sm">
            <xsl:value-of select="text()"/>
          </field>
        </xsl:for-each>
        <xsl:for-each select="mods:extension[@displayLabel='geo']/rdf:RDF/rdf:Description/gml:boundedBy/gml:Envelope">
          <xsl:variable name="x2" select="number(substring-before(gml:upperCorner/text(), ' '))"/>
          <xsl:variable name="x1" select="number(substring-before(gml:lowerCorner/text(), ' '))"/>
          <xsl:variable name="y2" select="number(substring-after(gml:upperCorner/text(), ' '))"/>
          <xsl:variable name="y1" select="number(substring-after(gml:lowerCorner/text(), ' '))"/>
		  <field name="georss_box_s">
			  <georss:box>
	              <xsl:value-of select="$y1"/>
	              <xsl:text> </xsl:text>
	              <xsl:value-of select="$x1"/>
	              <xsl:text> </xsl:text>
	              <xsl:value-of select="$y2"/>
	              <xsl:text> </xsl:text>
	              <xsl:value-of select="$x2"/>
			  </georss:box>
		  </field>
          <field name="solr_geom">
            <xsl:text>POLYGON((</xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$x2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$x2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y2"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y2"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$x1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y1"/>
            <xsl:text>))</xsl:text>
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
		<field name="dct_references_sm">
			<xlink type="simple" role="urn:ogc:serviceType:WebMappingService">
				<xsl:attribute name="href">
					<xsl:value-of select="$geoserver_root"/>
	          	  	<xsl:text>/wms</xsl:text>
				</xsl:attribute>
			</xlink>
		</field>
		<field name="dct_references_sm">
			<xlink type="simple" role="urn:ogc:serviceType:WebFeatureService">
				<xsl:attribute name="href">
					<xsl:value-of select="$geoserver_root"/>
	          	  	<xsl:text>/wfs</xsl:text>
				</xsl:attribute>
			</xlink>
		</field>
      </doc>
    </add>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
