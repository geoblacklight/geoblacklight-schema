<!--

Modified by Darren Hardy, Stanford University Libraries, 2014

pacioos-fgdc-html.xsl

Author: John Maurer (jmaurer@hawaii.edu)
Date: November 1, 2011 (rev. from my July 2007 original at NSIDC)

This Extensible Stylesheet Language for Transformations (XSLT) document takes
metadata in Extensible Markup Language (XML) for the U.S. Federal Geographic 
Data Committee (FGDC) Content Standard for Digital Geospatial Metadata (CSDGM) 
with Remote Sensing Extensions (RSE) and converts it into an HTML page. This 
format is used to show the full metadata record on PacIOOS's website.

For more information on the FGDC CSDGM see:

http://www.fgdc.gov/metadata/csdgm/

For more information on XSLT see:

http://en.wikipedia.org/wiki/XSLT
http://www.w3.org/TR/xslt

-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <!-- Import another XSLT file for replacing newlines with HTML <br/>'s: -->

  <xsl:import href="utils/replace-newlines.xsl"/>

  <!-- Import another XSLT file for doing other string substitutions: -->
  
  <xsl:import href="utils/replace-string.xsl"/>

  <!-- Import another XSLT file for limiting the number of decimal places: -->

  <xsl:import href="utils/strip-digits.xsl"/>

  <!-- 

  This HTML output method conforms to the following DOCTYPE statement:

    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
      "http://www.w3.org/TR/html4/loose.dtd">
  -->

  <xsl:output
    method="html"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    encoding="ISO-8859-1"
    indent="yes"/>

  <!-- VARIABLES: ***********************************************************-->

  <!-- The separator separates short names from long names. For example:
       DMSP > Defense Meteorological Satellite Program -->

  <xsl:variable name="separator">
     <xsl:text>&amp;nbsp;</xsl:text>
  </xsl:variable>

  <!-- Define a variable for creating a newline: -->

  <xsl:variable name="newline">
<xsl:text>
</xsl:text>
  </xsl:variable>

  <!-- This variable is used to link to the other metadata views.
       NOTE: TDS FMRC ID's appear like "wrf_hi/WRF_Hawaii_Regional_Atmospheric_Model_best.ncd";
       to simplify the ID's, strip everything after "/":
  -->
  <xsl:variable name="datasetIdentifier">
    <xsl:variable name="datasetIdentifierOriginal" select="metadata/idinfo/datsetid"/>
    <xsl:choose>
      <xsl:when test="contains( $datasetIdentifierOriginal, '/' )">
        <xsl:value-of select="substring-before( $datasetIdentifierOriginal, '/' )"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$datasetIdentifierOriginal"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
 
  <!-- Define a variable which creates a JavaScript array of the bounding box
       of the Spatial_Domain/Bounding element in the FGDC for use in the Google
       Maps API, which is controlled by the loadGoogleMap function inside
       the google_maps.ssi include file. NOTE: This function expects the
       bounding box to be provided in a specific order: north, south, east,
       west: -->

  <xsl:variable name="bbox">
    <!-- FGDC can only have one Spatial Domain (i.e. not multiple bounding boxes): -->
    <xsl:if test="metadata/idinfo/spdom/bounding/northbc">
      <xsl:text> [ </xsl:text>
      <xsl:value-of select="metadata/idinfo/spdom/bounding/northbc"/><xsl:text>, </xsl:text>
      <xsl:value-of select="metadata/idinfo/spdom/bounding/southbc"/><xsl:text>, </xsl:text>
      <xsl:value-of select="metadata/idinfo/spdom/bounding/eastbc"/><xsl:text>, </xsl:text>
      <xsl:value-of select="metadata/idinfo/spdom/bounding/westbc"/>
      <xsl:text> ] </xsl:text>
    </xsl:if>
  </xsl:variable>

  <!-- TOP-LEVEL: HTML ******************************************************-->

  <!-- The top-level template; Define various features for the entire page and then
       call the "metadata" template to fill in the remaining HTML: -->

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml"><xsl:value-of select="$newline"/>
    <head><xsl:value-of select="$newline"/>
    <title><xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/></title><xsl:value-of select="$newline"/>
    <xsl:comment>
If you want to show polylines on a Google Map (like the rectangle used to
outline the data set geographic coverage), you need to include the VML
namespace in the html tag and the following CSS code in an XHTML compliant
doctype to make everything work properly in IE:
</xsl:comment><xsl:value-of select="$newline"/>
    <style type="text/css">

  v\:* {
    behavior:url(#default#VML);
  }

  .callouthead {
    font-size: 85%;
    font-weight: bold;
    color: #003366;
    padding: 4px 4px 0 4px;
    margin: 0;
  }

  .callouttext {
    font-size: .88em;
    font-weight: normal;
    padding: 2px 4px 0 5px;
    margin: 0;
  }

  .wrapline {
    /* http://perishablepress.com/press/2010/06/01/wrapping-content/ */
    white-space: pre;           /* CSS 2.0 */
    white-space: pre-wrap;      /* CSS 2.1 */
    white-space: pre-line;      /* CSS 3.0 */
    white-space: -pre-wrap;     /* Opera 4-6 */
    white-space: -o-pre-wrap;   /* Opera 7 */
    white-space: -moz-pre-wrap; /* Mozilla */
    white-space: -hp-pre-wrap;  /* HP Printers */
    word-wrap: break-word;
    width: 475px;
  }

</style><xsl:value-of select="$newline"/>
    </head><xsl:value-of select="$newline"/>
    <body><xsl:value-of select="$newline"/>
    <table width="99%" border="0" cellspacing="2" cellpadding="0">
      <tr>
        <td valign="top">
          <table width="98%" border="0" align="center" cellpadding="2" cellspacing="8" style="margin-top: -20px;">
            <tr>
              <td valign="top" >
                <h2 style="margin-right: 185px; text-transform: none;"><xsl:value-of select="metadata/idinfo/citation/citeinfo/title"/></h2>
                <ul>
                  <li><a href="#Identification_Information">Identification Information</a></li>
                  <xsl:if test="string-length( metadata/dataqual )">
                    <li><a href="#Data_Quality_Information">Data Quality Information</a></li>
                  </xsl:if>
                  <xsl:if test="string-length( metadata/spdoinfo )">
                    <li><a href="#Spatial_Data_Organization_Information">Spatial Data Organization Information</a></li>
                  </xsl:if>
                  <xsl:if test="string-length( metadata/spref )">
                    <li><a href="#Spatial_Reference_Information">Spatial Reference Information</a></li>
                  </xsl:if>
                  <xsl:if test="string-length( metadata/eainfo )">
                    <li><a href="#Entity_and_Attribute_Information">Entity and Attribute Information</a></li>
                  </xsl:if>
                  <li><a href="#Distribution_Information">Distribution Information</a></li>
                  <li><a href="#Metadata_Reference_Information">Metadata Reference Information</a></li>
                </ul>
                <xsl:apply-templates select="metadata"/>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <xsl:comment> END MAIN CONTENT </xsl:comment><xsl:value-of select="$newline"/>
  </body><xsl:value-of select="$newline"/>
    </html>
  </xsl:template>

  <!-- The second-level template: match all the main elements of the FGDC and
       process them separately. The order of these elements is maintained in
       the resulting document: -->

  <!-- ROOT: ****************************************************************-->

  <xsl:template match="metadata">
    <xsl:apply-templates select="idinfo"/>
    <xsl:apply-templates select="dataqual"/>
    <xsl:apply-templates select="spdoinfo"/>
    <xsl:apply-templates select="spref"/>
    <xsl:apply-templates select="eainfo"/>
    <xsl:apply-templates select="distinfo"/>
    <xsl:apply-templates select="metainfo"/>
  </xsl:template>

  <!-- IDENTIFICATION_INFORMATION: ******************************************-->

  <xsl:template match="idinfo">
    <hr/>
    <h3><a name="Identification_Information"></a>Identification Information:</h3>
    <xsl:apply-templates select="datsetid"/>
    <xsl:apply-templates select="citation"/>
    <xsl:apply-templates select="descript"/>
    <xsl:apply-templates select="timeperd"/>
    <xsl:apply-templates select="status"/>
    <xsl:apply-templates select="spdom"/>
    <xsl:apply-templates select="keywords"/>
    <xsl:apply-templates select="taxonomy"/>
    <xsl:apply-templates select="plainsid"/>
    <xsl:apply-templates select="accconst"/>
    <xsl:apply-templates select="useconst"/>
    <xsl:apply-templates select="ptcontac"/>
    <xsl:apply-templates select="browse"/>
    <xsl:apply-templates select="datacred"/>
    <xsl:apply-templates select="secinfo"/>
    <xsl:apply-templates select="native"/>
    <xsl:apply-templates select="crossref"/>
    <xsl:apply-templates select="tool"/>
    <xsl:apply-templates select="agginfo"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template>

  <xsl:template match="datsetid">
    <xsl:if test="string-length( . )">
      <h4 style="display: inline;">Dataset Identifier:</h4>
      <p style="display: inline;"><xsl:value-of select="."/></p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="citation">
    <h4>Citation:</h4> 
    <xsl:call-template name="citeinfo">
      <xsl:with-param name="element" select="citeinfo"/>
      <xsl:with-param name="italicize-heading" select="true()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="descript">
    <h4>Description:</h4>
    <xsl:apply-templates select="abstract"/>
    <xsl:apply-templates select="purpose"/>
    <xsl:apply-templates select="documnts"/>
  </xsl:template>

  <xsl:template match="abstract">
    <p><b><i>Abstract:</i></b></p>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="purpose">
    <p><b><i>Purpose: </i></b><xsl:value-of select="."/></p>
  </xsl:template>

  <xsl:template match="documnts">
    <p><b><i>Documentation:</i></b></p>
    <blockquote>
    <p><b>User's Guide:</b></p>
      <blockquote>
        <xsl:call-template name="citeinfo">
          <xsl:with-param name="element" select="userguid/citeinfo"/>
          <xsl:with-param name="italicize-heading" select="false()"/>
        </xsl:call-template>
      </blockquote>
    </blockquote>
  </xsl:template>

  <xsl:template match="timeperd">
    <h4>Time Period of Content:</h4>
    <xsl:call-template name="timeinfo">
      <xsl:with-param name="element" select="timeinfo"/>
      <xsl:with-param name="italicize-heading" select="true()"/>
    </xsl:call-template>
    <p><b><i>Currentness Reference: </i></b><xsl:value-of select="current"/></p>
  </xsl:template>

  <xsl:template match="status">
    <xsl:if test="string-length( . )">
      <h4>Status:</h4>
      <p>
        <b><i>Progress: </i></b><xsl:value-of select="progress"/><br/>
        <b><i>Maintenance and Update Frequency: </i></b><xsl:value-of select="update"/>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="spdom">
    <h4>Spatial Domain:</h4>
    <xsl:if test="string-length( descgeog )">
      <p><b><i>Description of Geographic Extent:</i></b></p>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="descgeog"/>
        </xsl:call-template>
      </p>
    </xsl:if>
    <p><b><i>Bounding Coordinates:</i></b></p>
    <blockquote>
      <p>
        <b>West Bounding Coordinate: </b>
        <xsl:call-template name="strip-digits">
          <xsl:with-param name="element" select="bounding/westbc"/>
          <xsl:with-param name="num-digits" select="5"/>
        </xsl:call-template>&#176;<br/>
        <b>East Bounding Coordinate: </b>
        <xsl:call-template name="strip-digits">
          <xsl:with-param name="element" select="bounding/eastbc"/>
          <xsl:with-param name="num-digits" select="5"/>
        </xsl:call-template>&#176;<br/>
        <b>North Bounding Coordinate: </b>
        <xsl:call-template name="strip-digits">
          <xsl:with-param name="element" select="bounding/northbc"/>
          <xsl:with-param name="num-digits" select="5"/>
        </xsl:call-template>&#176;<br/>
        <b>South Bounding Coordinate: </b>
        <xsl:call-template name="strip-digits">
          <xsl:with-param name="element" select="bounding/southbc"/>
          <xsl:with-param name="num-digits" select="5"/>
        </xsl:call-template>&#176;<br/>
      </p>
    </blockquote>
    <xsl:for-each select="boundalt">
      <p><b><i>Bounding Altitudes:</i></b></p>
      <blockquote>
        <p>
          <b>Altitude Minimum: </b>
          <xsl:call-template name="strip-digits">
            <xsl:with-param name="element" select="altmin"/>
            <xsl:with-param name="num-digits" select="5"/>
          </xsl:call-template><br/>
          <b>Altitude Maximum: </b>
          <xsl:call-template name="strip-digits">
            <xsl:with-param name="element" select="altmax"/>
            <xsl:with-param name="num-digits" select="5"/>
          </xsl:call-template><br/>
          <b>Altitude Distance Units: </b><xsl:value-of select="altunits"/><br/>
        </p>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="dsgpoly">
      <p><b><i>Data Set G-Polygon:</i></b></p>
      <blockquote>
        <xsl:for-each select="dsgpolyo">
          <p><b>Data Set G-Polygon Outer G-Ring:</b></p>
          <blockquote>
            <xsl:apply-templates select="grngpoin"/>
            <xsl:apply-templates select="gring"/>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="dsgpolyx">
          <p><b>Data Set G-Polygon Exclusion G-Ring:</b></p>
          <blockquote>
            <xsl:apply-templates select="grngpoin"/>
            <xsl:apply-templates select="gring"/>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="keywords">
    <h4>Keywords:</h4>
    <xsl:apply-templates select="theme"/>
    <xsl:apply-templates select="place"/>
    <xsl:apply-templates select="stratum"/>
    <xsl:apply-templates select="temporal"/>
  </xsl:template>

  <!--Create keywords indices (keys) so that we can do a unique sort below: -->

  <xsl:key name="values_by_id" match="themekey" use="."/>

  <xsl:template match="theme">
    <p><b><i>Theme:</i></b></p>
    <blockquote>
      <p>
        <!-- Try to link to the relevant thesaurus online if possible: -->
        <xsl:choose>
          <xsl:when test="contains( themekt, 'NASA Global Change Master Directory (GCMD) Science Keywords' )">
            <b>Theme Keyword Thesaurus: </b><a href="http://gcmd.gsfc.nasa.gov/Resources/valids/gcmd_parameters.html" target="_blank"><xsl:value-of select="themekt"/></a><br/>
          </xsl:when>
          <xsl:when test="contains( themekt, 'NASA Global Change Master Directory (GCMD) Project Keywords' )">
            <b>Theme Keyword Thesaurus: </b><a href="http://gcmd.gsfc.nasa.gov/Resources/valids/projects.html" target="_blank"><xsl:value-of select="themekt"/></a><br/>
          </xsl:when>
          <xsl:when test="contains( themekt, 'NASA Global Change Master Directory (GCMD) Instrument Keywords' )">
            <b>Theme Keyword Thesaurus: </b><a href="http://gcmd.gsfc.nasa.gov/Resources/valids/sensors.html" target="_blank"><xsl:value-of select="themekt"/></a><br/>
          </xsl:when>
          <xsl:when test="contains( themekt, 'NASA Global Change Master Directory (GCMD) Platform Keywords' )">
            <b>Theme Keyword Thesaurus: </b><a href="http://gcmd.gsfc.nasa.gov/Resources/valids/sources.html" target="_blank"><xsl:value-of select="themekt"/></a><br/>
          </xsl:when>
          <xsl:when test="contains( themekt, 'ISO 19115 Topic Categories' )">
            <b>Theme Keyword Thesaurus: </b><a href="http://gcmd.nasa.gov/User/difguide/iso_topics.html" target="_blank"><xsl:value-of select="themekt"/></a><br/>
          </xsl:when>
          <xsl:otherwise>
            <b>Theme Keyword Thesaurus: </b><xsl:value-of select="themekt"/><br/>
          </xsl:otherwise>
        </xsl:choose>
        <!--
        Do unique sort method below instead to remove duplicates...
        <xsl:for-each select="themekey">
          <xsl:sort select="."/>
          <b>Theme Keyword: </b>
          <xsl:call-template name="replace-string">
            <xsl:with-param name="element" select="."/>
            <xsl:with-param name="old-string" select="'>'"/>
            <xsl:with-param name="new-string" select="$separator"/>
          </xsl:call-template>
          <br/>
        </xsl:for-each>
        -->
        <xsl:for-each select="themekey[ count( . | key( 'values_by_id', translate( normalize-space( . ), ',', '' ) )[ 1 ]) = 1 ]">
          <xsl:sort select="."/>
          <xsl:if test=". != '&gt;'">
            <xsl:variable name="keyword">
              <xsl:call-template name="replace-string">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="old-string">&gt;</xsl:with-param>
                <xsl:with-param name="new-string"><xsl:value-of select="$separator"/></xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="keyword2">
              <xsl:call-template name="replace-string">
                <xsl:with-param name="element" select="$keyword"/>
                <xsl:with-param name="old-string">&amp;gt;</xsl:with-param>
                <xsl:with-param name="new-string"><xsl:value-of select="$separator"/></xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <b>Keyword: </b><xsl:value-of select="$keyword2" disable-output-escaping="yes"/><br/>
          </xsl:if>
        </xsl:for-each>
      </p>
    </blockquote>
  </xsl:template>

  <xsl:template match="place">
    <p><b><i>Place:</i></b></p>
    <blockquote>
      <p>
        <!-- Try to link to the relevant thesaurus online if possible: -->
        <xsl:choose>
          <xsl:when test="contains( placekt, 'NASA Global Change Master Directory (GCMD) Location Keywords' )">
            <b>Place Keyword Thesaurus: </b><a href="http://gcmd.gsfc.nasa.gov/Resources/valids/location.html" target="_blank"><xsl:value-of select="placekt"/></a><br/>
          </xsl:when>
          <xsl:otherwise>
            <b>Place Keyword Thesaurus: </b><xsl:value-of select="placekt"/><br/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="placekey">
          <xsl:sort select="."/>
          <xsl:variable name="placekeyword">
            <xsl:call-template name="replace-string">
              <xsl:with-param name="element" select="."/>
              <xsl:with-param name="old-string">&gt;</xsl:with-param>
              <xsl:with-param name="new-string"><xsl:value-of select="$separator"/></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="placekeyword2">
            <xsl:call-template name="replace-string">
              <xsl:with-param name="element" select="$placekeyword"/>
              <xsl:with-param name="old-string">&amp;gt;</xsl:with-param>
              <xsl:with-param name="new-string"><xsl:value-of select="$separator"/></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <b>Place Keyword: </b><xsl:value-of select="$placekeyword2" disable-output-escaping="yes"/><br/>
        </xsl:for-each>
      </p>
    </blockquote>
  </xsl:template>

  <xsl:template match="stratum">
    <p><b><i>Stratum:</i></b></p>
    <blockquote>
      <p>
        <xsl:for-each select="stratkt">
          <b>Stratum Keyword Thesaurus: </b><xsl:value-of select="." /><br/>
        </xsl:for-each>
        <xsl:for-each select="stratkey">
          <xsl:sort select="."/>
          <b>Stratum Keyword: </b>
          <xsl:call-template name="replace-string">
            <xsl:with-param name="element" select="."/>
            <xsl:with-param name="old-string" select="'>'"/>
            <xsl:with-param name="new-string" select="$separator"/>
          </xsl:call-template>
          <br/>
        </xsl:for-each>
      </p>
    </blockquote>
  </xsl:template>

  <xsl:template match="temporal">
    <p><b><i>Temporal:</i></b></p>
    <blockquote>
      <p>
        <!-- Try to link to the relevant thesaurus online if possible: -->
        <xsl:choose>
          <xsl:when test="contains( tempkt, 'NASA Global Change Master Directory (GCMD) Chronostratigraphic Unit Keywords' )">
            <b>Temporal Keyword Thesaurus: </b><a href="http://gcmd.gsfc.nasa.gov/Resources/valids/chrono_unit.html" target="_blank"><xsl:value-of select="tempkt"/></a><br/>
          </xsl:when>
          <xsl:otherwise>
            <b>Temporal Keyword Thesaurus: </b><xsl:value-of select="tempkt"/><br/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="tempkey">
          <xsl:sort select="."/>
          <b>Temporal Keyword: </b>
          <xsl:call-template name="replace-string">
            <xsl:with-param name="element" select="."/>
            <xsl:with-param name="old-string" select="'>'"/>
            <xsl:with-param name="new-string" select="$separator"/>
          </xsl:call-template>
          <br/>
        </xsl:for-each>
      </p>
    </blockquote>
  </xsl:template>

  <xsl:template match="taxonomy">
    <h4>Taxonomy:</h4>
    <xsl:for-each select="keywtax">
      <p><b><i>Keywords/Taxon:</i></b></p>
      <blockquote>
        <p>
          <b>Taxonomic Keyword Thesaurus: </b><xsl:value-of select="taxonkt"/><br/>
          <xsl:for-each select="taxonkey">
            <xsl:sort select="."/>
            <b>Taxonomic Keyword: </b>
            <xsl:call-template name="replace-string">
              <xsl:with-param name="element" select="."/>
              <xsl:with-param name="old-string" select="'>'"/>
              <xsl:with-param name="new-string" select="$separator"/>
            </xsl:call-template>
            <br/>
          </xsl:for-each>
        </p>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="taxonsys">
      <p><b><i>Taxonomic System:</i></b></p>
      <blockquote>
        <xsl:for-each select="classsys">
          <p><b>Classification System/Authority:</b></p>
          <blockquote>
            <xsl:for-each select="classcit">
              <p><b>Classification System Citation:</b></p>
              <blockquote>
                <xsl:call-template name="citeinfo">
                  <xsl:with-param name="element" select="citeinfo"/>
                  <xsl:with-param name="italicize-heading" select="false()"/>
                </xsl:call-template>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="classmod">
              <p><b>Classification System Modifications:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="idref">
          <p><b>Identification Reference:</b></p>
          <blockquote>
            <xsl:call-template name="citeinfo">
              <xsl:with-param name="element" select="citeinfo"/>
              <xsl:with-param name="italicize-heading" select="false()"/>
            </xsl:call-template>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="ider">
          <p><b>Identifer:</b></p>
          <blockquote>
            <xsl:call-template name="cntinfo">
              <xsl:with-param name="element" select="cntinfo"/>
            </xsl:call-template>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="taxonpro">
          <p><b>Taxonomic Procedures:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="taxoncom">
          <p><b>Taxonomic Completeness:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="vouchers">
          <p><b>Vouchers:</b></p>
          <blockquote>
            <p><b>Specimen: </b><xsl:value-of select="specimen" /></p>
            <p><b>Repository:</b></p>
            <blockquote>
              <xsl:for-each select="reposit">
                <xsl:call-template name="cntinfo">
                  <xsl:with-param name="element" select="cntinfo"/>
                </xsl:call-template>
              </xsl:for-each>
            </blockquote>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="taxongen">
      <p><b><i>General Taxonomic Coverage:</i></b></p>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="."/>
        </xsl:call-template>
      </p>
    </xsl:for-each>
    <p><b><i>Taxonomic Classification:</i></b></p>
    <xsl:apply-templates select="taxoncl" />
  </xsl:template>

  <!-- Taxonomic Classification (recursive): -->

  <xsl:template match="taxoncl">
      <div style="margin-left: 15px;"><font color="#6e6e6e"><b><xsl:value-of select="taxonrn" />: </b><xsl:value-of select="taxonrv" /></font>
      <xsl:for-each select="common">
        <div style="margin-left: 15px;"><font color="#6e6e6e"><b>Common Name: </b><xsl:value-of select="." /></font></div>
      </xsl:for-each>
      <xsl:apply-templates select="taxoncl" />
      </div>
  </xsl:template>

  <xsl:template match="plainsid">
    <xsl:if test="string-length( platflnm ) and string-length( instflnm )">
      <h4>Platform and Instrument Identification:</h4>
      <p>
        <b><i>Platform Full Name: </i></b><xsl:value-of select="platflnm"/><br/>
        <xsl:if test="platfsnm">
          <b><i>Platform Short Name: </i></b><xsl:value-of select="platfsnm"/><br/>
        </xsl:if>
        <b><i>Instrument Full Name: </i></b><xsl:value-of select="instflnm"/><br/>
        <xsl:if test="instshnm">
          <b><i>Instrument Short Name: </i></b><xsl:value-of select="instshnm"/><br/>
        </xsl:if>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="accconst">
    <h4>Access Constraints:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="useconst">
    <h4>Use Constraints:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="ptcontac">
    <xsl:if test="string-length( cntinfo/cntorgp/cntorg )
               or string-length( cntinfo/cntperp/cntper )">
      <h4>Point of Contact:</h4>
      <xsl:call-template name="cntinfo">
        <xsl:with-param name="element" select="cntinfo"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="browse">
    <xsl:if test="string-length( browsen )">
      <h4>Browse Graphic:</h4>
      <p>
        <!--<a href="{browsen}" target="_blank"><img src="{browsen}" height="260" border="0"/></a><br/>-->
        <a href="{browsen}" class="browse fancybox fancybox.image"><img src="{browsen}" height="400" border="0"/></a><br/>
        <a href="{browsen}" class="browse fancybox fancybox.image">View full image</a>
      </p>
      <p><b><i>Browse Graphic File Name: </i></b><a href="{browsen}"><xsl:value-of select="browsen"/></a></p>
      <p><b><i>Browse Graphic File Description:</i></b></p>
      <p>     
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="browsed"/>
        </xsl:call-template>
      </p>
      <p><b><i>Browse Graphic File Type: </i></b><xsl:value-of select="browset"/></p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="datacred">
    <h4>Data Set Credit:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="secinfo">
    <h4>Security Information:</h4>
    <xsl:for-each select="secsys">
      <p><b><i>Security Classification System: </i></b><xsl:value-of select="." /></p>
    </xsl:for-each>
    <xsl:for-each select="secclass">
      <p><b><i>Security Classification: </i></b><xsl:value-of select="." /></p>
    </xsl:for-each>
    <xsl:for-each select="sechandl">
      <p><b><i>Security Handling Description:</i></b></p>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="."/>
        </xsl:call-template>
      </p>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="native">
    <h4>Native Data Set Environment:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="crossref">
    <h4>Cross Reference:</h4>
    <xsl:call-template name="citeinfo">
      <xsl:with-param name="element" select="citeinfo"/>
      <xsl:with-param name="italicize-heading" select="true()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tool">
    <h4>Analytical Tool:</h4>
    <p><b><i>Analytical Tool Description:</i></b></p>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="tooldesc"/>
      </xsl:call-template>
    </p>
    <xsl:for-each select="toolacc">
      <p><b><i>Tool Access Information:</i></b></p>
      <blockquote>
        <xsl:for-each select="onlink">
          <p><b>Online Linkage: </b><a href="{.}"><xsl:value-of select="."/></a></p>
        </xsl:for-each>
        <p><b>Tool Access Instructions:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="toolinst"/>
          </xsl:call-template>
        </p>
        <xsl:for-each select="toolcomp">
          <p><b>Tool Computer and Operating System:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="toolcont">
      <p><b><i>Tool Contact:</i></b></p>
      <xsl:call-template name="cntinfo">
        <xsl:with-param name="element" select="cntinfo"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="toolcite">
      <p><b><i>Tool Citation:</i></b></p>
      <xsl:call-template name="citeinfo">
        <xsl:with-param name="element" select="citeinfo"/>
        <xsl:with-param name="italicize-heading" select="false()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="agginfo">
    <xsl:if test="string-length( conpckid/datsetid )">
      <h4>Aggregation Information:</h4>
      <p><b><i>Container Packet ID:</i></b></p>
      <blockquote>
        <p>
          <b>Dataset Identifier: </b>
          <a href="{concat( '/data/', translate( conpckid/datsetid, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz' ), '.html' )}"><xsl:value-of select="translate( conpckid/datsetid, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' )"/></a>
        </p>
      </blockquote>
    </xsl:if>
  </xsl:template>

  <!-- DATA_QUALITY_INFORMATION *********************************************-->

  <xsl:template match="dataqual">
    <hr/>
    <h3><a name="Data_Quality_Information"></a>Data Quality Information:</h3>
    <xsl:apply-templates select="attracc"/>
    <xsl:apply-templates select="logic"/>
    <xsl:apply-templates select="complete"/>
    <xsl:apply-templates select="posacc"/>
    <xsl:apply-templates select="lineage"/>
    <xsl:apply-templates select="cloud"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template> 

  <xsl:template match="attracc">
    <h4>Attribute Accuracy:</h4>
    <xsl:for-each select="attraccr">
      <p><b><i>Attribute Accuracy Report:</i></b></p>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="."/>
        </xsl:call-template>
      </p> 
    </xsl:for-each>
    <xsl:for-each select="qattracc">
      <p><b><i>Quantitative Attribute Accuracy Assessment:</i></b></p>
      <blockquote>
        <xsl:for-each select="attraccv">
          <p><b>Attribute Accuracy Value: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="attracce">
          <p><b>Attribute Accuracy Explanation:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="logic">
    <h4>Logical Consistency Report:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="complete">
    <h4>Completeness Report:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="posacc">
    <h4>Positional Accuracy:</h4>
    <xsl:for-each select="horizpa">
      <p><b><i>Horizontal Positional Accuracy:</i></b></p>
      <blockquote>
        <xsl:for-each select="horizpar">
          <p><b>Horizontal Positional Accuracy Report:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="qhorizpa">
          <p><b>Quantitative Horizontal Positional Accuracy Assessment:</b></p>
          <blockquote>
            <xsl:for-each select="horizpav">
              <p><b>Horizontal Positional Accuracy Value: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
            <xsl:for-each select="horizpae">
              <p><b>Horizontal Positional Accuracy Explanation:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="vertacc">
      <p><b><i>Vertical Positional Accuracy:</i></b></p>
      <blockquote>
        <xsl:for-each select="vertaccr">
          <p><b>Vertical Positional Accuracy Report:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="qvertpa">
          <p><b>Quantitative Vertical Positional Accuracy Assessment:</b></p>
          <blockquote>
            <xsl:for-each select="vertaccv">
              <p><b>Vertical Positional Accuracy Value: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
            <xsl:for-each select="vertacce">
              <p><b>Vertical Positional Accuracy Explanation:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="lineage">
    <h4>Lineage:</h4>
    <xsl:for-each select="method">
      <p><b><i>Methodology:</i></b></p>
      <blockquote> 
        <p><b>Methodology Type: </b><xsl:value-of select="methtype"/></p>
        <xsl:for-each select="methodid">
          <p><b>Methodolgy Identifier:</b></p>
          <blockquote>
            <p><b>Methodolgy Keyword Thesaurus: </b><xsl:value-of select="methkt"/></p>
            <xsl:for-each select="methkey">
              <p><b>Methodology Keyword: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
        <p><b>Methodology Description:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="methdesc"/>
          </xsl:call-template>
        </p>
        <xsl:for-each select="methcite">
          <p><b>Methodology Citation:</b></p>
          <blockquote>
            <xsl:call-template name="citeinfo">
              <xsl:with-param name="element" select="citeinfo"/>
              <xsl:with-param name="italicize-heading" select="false()"/>
            </xsl:call-template>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="srcinfo">
      <p><b><i>Source Information:</i></b></p>
      <blockquote>
        <xsl:for-each select="srccite">
          <p><b>Source Citation:</b></p>
          <blockquote>
            <xsl:call-template name="citeinfo">
              <xsl:with-param name="element" select="citeinfo"/>
              <xsl:with-param name="italicize-heading" select="false()"/>
            </xsl:call-template>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="srcscale">
          <p><b>Source Scale Denominator: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="typesrc">
          <p><b>Type of Source Media: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="srctime">
          <p><b>Source Time Period of Content:</b></p>
          <blockquote>
            <xsl:call-template name="timeinfo">
              <xsl:with-param name="element" select="timeinfo"/>
              <xsl:with-param name="italicize-heading" select="false()"/>
            </xsl:call-template>
            <xsl:for-each select="srccurr">
              <p><b>Source Currentness Reference: </b><xsl:value-of select="."/></p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="srccitea">
          <p><b>Source Citation Abbreviation: </b> <xsl:value-of select="."/></p>
        </xsl:for-each>
        <xsl:for-each select="srccontr">
          <p><b>Source Contribution:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="procstep">
      <p><b><i>Process Step:</i></b></p>
      <blockquote>
        <p><b>Process Description:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="procdesc"/>
          </xsl:call-template>
        </p>
        <xsl:for-each select="srcused">
          <p><b>Source Used Citation Abbreviation:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <p>
          <b>Process Date: </b>
          <xsl:call-template name="date">
            <xsl:with-param name="element" select="procdate"/>
          </xsl:call-template>
        </p>
        <xsl:for-each select="proctime">
          <p><b>Process Time: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="srcprod">
          <p><b>Source Produced Citation Abbreviation:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="proccont">
          <p><b>Process Contact:</b></p>
          <blockquote>
            <xsl:call-template name="cntinfo">
              <xsl:with-param name="element" select="cntinfo"/>
            </xsl:call-template>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="cloud">
    <h4 style="display: inline;">Cloud Cover:</h4>
    <p style="display: inline;"><xsl:value-of select="." /></p>
  </xsl:template>

  <!-- SPATIAL_DATA_ORGANIZATION_INFORMATION: *******************************-->

  <xsl:template match="spdoinfo">
    <hr/>
    <h3><a name="Spatial_Data_Organization_Information"></a>Spatial Data Organization Information:</h3>
    <xsl:apply-templates select="indspref"/>
    <xsl:apply-templates select="direct"/>
    <xsl:apply-templates select="ptvctinf"/>
    <xsl:apply-templates select="rastinfo"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template>

  <xsl:template match="indspref">
    <h4>Indirect Spatial Reference Method:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="direct">
    <h4 style="display: inline;">Direct Spatial Reference Method:</h4>
    <p style="display: inline;"><xsl:value-of select="." /></p>
  </xsl:template>

  <xsl:template match="ptvctinf">
    <h4>Point and Vector Object Information:</h4>
    <xsl:for-each select="sdtsterm">
      <p><b><i>Spatial Data Transfer Standard (<a href="http://en.wikipedia.org/wiki/Spatial_Data_Transfer_Standard" target="_blank">SDTS</a>) Terms Description:</i></b></p>
      <blockquote>
        <xsl:for-each select="sdtstype">
          <p><b>SDTS Point and Vector Object Type: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="ptvctcnt">
          <p><b>Point and Vector Object Count: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="vpfterm">
      <p><b><i>Vector Product Format (<a href="http://en.wikipedia.org/wiki/Vector_Product_Format" target="_blank">VPF</a>) Terms Description:</i></b></p>
      <blockquote>
        <xsl:for-each select="vpflevel">
          <p><b>VPF Topology Level: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="vpfinfo">
          <p><b>VPF Point and Vector Object Information:</b></p>
          <blockquote>
            <xsl:for-each select="vpftype">
              <p><b>VPF Point and Vector Object Type: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
            <xsl:for-each select="ptvctcnt">
              <p><b>Point and Vector Object Count: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="rastinfo">
    <h4>Raster Object Information:</h4>
    <xsl:for-each select="rasttype">
      <p><b><i>Raster Object Type: </i></b><xsl:value-of select="." /></p>
    </xsl:for-each>
    <xsl:for-each select="rowcount">
      <p><b><i>Row Count: </i></b><xsl:value-of select="." /></p>
    </xsl:for-each>
    <xsl:for-each select="colcount">
      <p><b><i>Column Count: </i></b><xsl:value-of select="." /></p>
    </xsl:for-each>
    <xsl:for-each select="vrtcount">
      <p><b><i>Vertical Count: </i></b><xsl:value-of select="." /></p>
    </xsl:for-each>
  </xsl:template>

  <!-- SPATIAL_REFERENCE_INFORMATION: ***************************************-->

  <xsl:template match="spref">
    <hr/>
    <h3><a name="Spatial_Reference_Information"></a>Spatial Reference Information:</h3>
    <xsl:apply-templates select="horizsys"/>
    <xsl:apply-templates select="vertdef"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template>

  <xsl:template match="horizsys">
    <h4>Horizontal Coordinate System Definition:</h4>
    <xsl:for-each select="geograph">
      <p><b><i>Geographic:</i></b></p>
      <blockquote>
        <xsl:for-each select="latres">
          <p><b>Latitude Resolution: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="longres">
          <p><b>Longitude Resolution: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="geogunit">
          <p><b>Geographic Coordinate Units: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="planar">
      <p><b><i>Planar:</i></b></p>
      <blockquote>
        <xsl:for-each select="mapproj">
          <p><b>Map Projection:</b></p>
          <blockquote>
            <xsl:for-each select="mapprojn">
              <p><b>Map Projection Name: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
            <xsl:for-each select="albers">
              <p><b>Albers Conical Equal Area:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="azimequi">
              <p><b>Azimuthal Equidistant:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="equicon">
              <p><b>Equidistant Conic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="equirect">
              <p><b>Equirectangular:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="gvnsp">
              <p><b>General Vertical Near-sided Perspective:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="gnomonic">
              <p><b>Gnomonic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="lamberta">
              <p><b>Lambert Azimuthal Equal Area:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="lambertc">
              <p><b>Lambert Conformal Conic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="mercator">
              <p><b>Mercator:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="modsak">
              <p><b>Modified Stereographic for Alaska:</b></p>
              <blockquote>
                <xsl:apply-templates select="feast"/>
                <xsl:apply-templates select="fnorth"/>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="miller">
              <p><b>Miller Cylindrical:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="obqmerc">
              <p><b>Oblique Mercator:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="orthogr">
              <p><b>Orthographic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="polarst">
              <p><b>Polar Stereographic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="polycon">
              <p><b>Polyconic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="robinson">
              <p><b>Robinson:</b></p>
              <blockquote>
                <xsl:apply-templates select="longpc"/>
                <xsl:apply-templates select="feast"/>
                <xsl:apply-templates select="fnorth"/>
              </blockquote>  
            </xsl:for-each>
            <xsl:for-each select="sinusoid">
              <p><b>Sinusoidal:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="spaceobq">
              <p><b>Space Oblique Mercator (Landsat):</b></p>
              <blockquote>
                <xsl:apply-templates select="landsat"/>
                <xsl:apply-templates select="pathnum"/>
                <xsl:apply-templates select="feast"/>
                <xsl:apply-templates select="fnorth"/>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="stereo">
              <p><b>Stereographic:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="transmer">
              <p><b>Transverse Mercator:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="vdgrin">
              <p><b>van der Grinten:</b></p>
              <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:for-each select="otherprj">
              <p><b>Other Projection's Definition:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="gridsys">
          <p><b>Grid Coordinate System:</b></p>
          <blockquote>
            <xsl:for-each select="gridsysn">
              <p><b>Grid Coordinate System Name: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
            <xsl:for-each select="utm">
              <p><b>Universal Transverse Mercator:</b></p>
              <blockquote>
                <xsl:for-each select="utmzone">
                  <p><b>UTM Zone Number: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="transmer">
                  <p><b>Transverse Mercator:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="transmer"/>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="ups">
              <p><b>Universal Polar Stereographic:</b></p>
              <blockquote>
                <xsl:for-each select="upszone">
                  <p><b>UPS Zone Identifier: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="polarst">
                  <p><b>Polar Stereographic:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="polarst"/>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="spcs">
              <p><b>State Plane Coordinate System:</b></p>
              <blockquote>
                <xsl:for-each select="spcszone">
                  <p><b>SPCS Zone Identifier: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="lambertc">
                  <p><b>Lambert Conformal Conic:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="lambertc"/>
                <xsl:for-each select="transmer">
                  <p><b>Transverse Mercator:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="transmer"/>
                <xsl:for-each select="obqmerc">
                  <p><b>Oblique Mercator:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="obqmerc"/>
                <xsl:for-each select="polycon">
                  <p><b>Polyconic:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="polycon"/>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="arcsys">
              <p><b>ARC Coordinate System:</b></p>
              <blockquote>
                <xsl:for-each select="arczone">
                  <p><b>ARC System Zone Identifier: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="equirect">
                  <p><b>Equirectangular:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="equirect"/>
                <xsl:for-each select="azimequi">
                  <p><b>Azimuthal Equidistant:</b></p>
                </xsl:for-each>
                <xsl:apply-templates select="azimequi"/>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="othergrd">
              <p><b>Other Grid System's Definition:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="localp">
          <p><b>Local Planar:</b></p>
          <blockquote>
            <xsl:for-each select="localpd">
              <p><b>Local Planar Description:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
            <xsl:for-each select="localpgi">
              <p><b>Local Planar Georeference Information:</b></p>
              <p>
                <xsl:call-template name="replace-newlines">
                  <xsl:with-param name="element" select="."/>
                </xsl:call-template>
              </p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
        <xsl:for-each select="planci">
          <p><b>Planar Coordinate Information:</b></p>
          <blockquote>
            <xsl:for-each select="plance">
              <p><b>Planar Coordinate Encoding Method: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
            <xsl:for-each select="coordrep">
              <p><b>Coordinate Representation:</b></p>
              <blockquote>
                <xsl:for-each select="absres">
                  <p><b>Abscissa Resolution: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="ordres">
                  <p><b>Ordinate Resolution: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="distbrep">
              <p><b>Distance and Bearing Representation:</b></p>
              <blockquote>
                <xsl:for-each select="distres">
                  <p><b>Distance Resolution: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="bearres">
                  <p><b>Bearing Resolution: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="bearunit">
                  <p><b>Bearing Units: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="bearrefd">
                  <p><b>Bearing Reference Direction: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
                <xsl:for-each select="bearrefm">
                  <p><b>Bearing Reference Meridian: </b><xsl:value-of select="." /></p>
                </xsl:for-each>
              </blockquote>
            </xsl:for-each>
            <xsl:for-each select="plandu">
              <p><b>Planar Distance Units: </b><xsl:value-of select="." /></p>
            </xsl:for-each>
          </blockquote>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="local">
      <p><b><i>Local:</i></b></p>
      <blockquote>
        <xsl:for-each select="localdes">
          <p><b>Local Description:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="localgeo">
          <p><b>Local Georeference Information:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="geodetic">
      <p><b><i>Geodetic Model:</i></b></p>
      <blockquote>
        <xsl:for-each select="horizdn">
          <p><b>Horizontal Datum Name: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="ellips">
          <p><b>Ellipsoid Name: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="semiaxis">
          <p><b>Semi-major Axis: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="denflat">
          <p><b>Denominator of Flattening Ratio: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="vertdef">
    <h4>Vertical Coordinate System Definition:</h4>
    <xsl:for-each select="altsys">
      <p><b><i>Altitude System Definition:</i></b></p>
      <blockquote>
        <xsl:for-each select="altdatum">
          <p><b>Altitude Datum Name: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="altres">
          <p><b>Altitude Resolution: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="altunits">
          <p><b>Altitude Distance Units: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="altenc">
          <p><b>Altitude Encoding Method: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:for-each select="depthsys">
      <p><b><i>Depth System Definition:</i></b></p>
      <blockquote>
        <xsl:for-each select="depthdn">
          <p><b>Depth Datum Name: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="depthres">
          <p><b>Depth Resolution: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="depthdu">
          <p><b>Depth Distance Units: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="depthem">
          <p><b>Depth Encoding Method: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
  </xsl:template>
 
  <xsl:template match="grngpoin">
    <p><b>G-Ring Point:</b></p>
    <blockquote>
      <xsl:for-each select="gringlat">
        <p><b>G-Ring Latitude: </b><xsl:value-of select="." />&#176;</p>
      </xsl:for-each>
      <xsl:for-each select="gringlon">
        <p><b>G-Ring Longitude: </b><xsl:value-of select="." />&#176;</p>
      </xsl:for-each>
    </blockquote>
  </xsl:template>

  <xsl:template match="gring">
    <p><b>G-Ring:</b></p>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <!-- Map Projections: -->

  <xsl:template match="albers | equicon | lambertc">
    <blockquote>
      <xsl:apply-templates select="stdparll"/>
      <xsl:apply-templates select="longcm"/>
      <xsl:apply-templates select="latprjo"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="gnomonic | lamberta | orthogr | stereo | gvnsp">
    <blockquote>
      <xsl:for-each select="../gvnsp">
        <xsl:apply-templates select="heightpt"/>
      </xsl:for-each>
      <xsl:apply-templates select="longpc"/>
      <xsl:apply-templates select="latprjc"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="miller | sinusoid | vdgrin | equirect | mercator">
    <blockquote>
      <xsl:for-each select="../equirect">
        <xsl:apply-templates select="stdparll"/>
      </xsl:for-each>
      <xsl:for-each select="../mercator">
        <xsl:apply-templates select="stdparll"/>
        <xsl:apply-templates select="sfequat"/>
      </xsl:for-each>
      <xsl:apply-templates select="longcm"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="azimequi | polycon">
    <blockquote>
      <xsl:apply-templates select="longcm"/>
      <xsl:apply-templates select="latprjo"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="transmer">
    <blockquote>
      <xsl:apply-templates select="sfctrmer"/>
      <xsl:apply-templates select="longcm"/>
      <xsl:apply-templates select="latprjo"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
  
  
  <xsl:template match="polarst">
    <blockquote>
      <xsl:apply-templates select="svlong"/>
      <xsl:apply-templates select="stdparll"/>
      <xsl:apply-templates select="sfprjorg"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="obqmerc">
    <blockquote>
      <xsl:apply-templates select="sfctrlin"/>
      <xsl:apply-templates select="obqlazim"/>
      <xsl:apply-templates select="obqlpt"/>
      <xsl:apply-templates select="latprjo"/>
      <xsl:apply-templates select="feast"/>
      <xsl:apply-templates select="fnorth"/>
    </blockquote>
  </xsl:template>
    
  <!-- Map Projection Parameters: -->

  <xsl:template match="stdparll">
    <p><b>Standard Parallel: </b><xsl:value-of select="." />&#176;</p>
  </xsl:template>
  
  <xsl:template match="longcm">
    <p><b>Longitude of Central Meridian: </b><xsl:value-of select="." />&#176;</p>
  </xsl:template>
  
  <xsl:template match="latprjo">
    <p><b>Latitude of Projection Origin: </b><xsl:value-of select="." />&#176;</p>
  </xsl:template>
  
  <xsl:template match="feast">
    <p><b>False Easting: </b><xsl:value-of select="." /></p>
  </xsl:template>
  
  <xsl:template match="fnorth">
    <p><b>False Northing: </b><xsl:value-of select="." /></p>
  </xsl:template>
  
  <xsl:template match="sfequat">
    <p><b>Scale Factor at Equator: </b><xsl:value-of select="." /></p>
  </xsl:template>
  
  <xsl:template match="heightpt">
    <p><b>Height of Perspective Point Above Surface: </b><xsl:value-of select="." /></p>
  </xsl:template>
  
  <xsl:template match="longpc">
    <p><b>Longitude of Projection Center: </b><xsl:value-of select="." />&#176;</p>
  </xsl:template>
  
  <xsl:template match="latprjc">
    <p><b>Latitude of Projection Center: </b><xsl:value-of select="." />&#176;</p>
  </xsl:template>
  
  <xsl:template match="sfctrlin">
    <p><b>Scale Factor at Center Line: </b><xsl:value-of select="." /></p>
  </xsl:template>
  
  <xsl:template match="obqlazim">
    <p><b>Oblique Line Azimuth:</b></p>
    <blockquote>
      <xsl:for-each select="azimangl">
        <p><b>Azimuthal Angle: </b><xsl:value-of select="." />&#176;</p>
      </xsl:for-each>
      <xsl:for-each select="azimptl">
        <p><b>Azimuthal Measure Point Longitude: </b><xsl:value-of select="." />&#176;</p>
      </xsl:for-each>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="obqlpt">
    <p><b>Oblique Line Point:</b></p>
    <blockquote>
        <p><b>Oblique Line Latitude: </b><xsl:value-of select="obqllat[1]" />&#176;</p>
        <p><b>Oblique Line Longitude: </b><xsl:value-of select="obqllong[1]" />&#176;</p>
        <p><b>Oblique Line Latitude: </b><xsl:value-of select="obqllat[2]" />&#176;</p>
        <p><b>Oblique Line Longitude: </b><xsl:value-of select="obqllong[2]" />&#176;</p>
    </blockquote>
  </xsl:template>
  
  <xsl:template match="svlong">
    <p><b>Straight Vertical Longitude from Pole: </b><xsl:value-of select="." />&#176;</p>
  </xsl:template>
  
  <xsl:template match="sfprjorg">
    <p><b>Scale Factor at Projection Origin: </b><xsl:value-of select="." /></p>
  </xsl:template>

  <xsl:template match="landsat">
    <p><b>Landsat Number: </b><xsl:value-of select="." /></p>
  </xsl:template>

  <xsl:template match="pathnum">
    <p><b>Path Number: </b><xsl:value-of select="." /></p>
  </xsl:template>

  <xsl:template match="sfctrmer">
    <p><b>Scale Factor at Central Meridian: </b><xsl:value-of select="." /></p>
  </xsl:template>

  <!-- ENTITY_AND_ATTRIBUTE_INFORMATION: ************************************-->

  <xsl:template match="eainfo">
    <hr/>
    <h3><a name="Entity_and_Attribute_Information"></a>Entity and Attribute Information:</h3>
    <xsl:apply-templates select="detailed"/>
    <xsl:apply-templates select="overview"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template>

  <xsl:template match="detailed">
    <h4>Detailed Description:</h4>
    <xsl:for-each select="enttyp">
      <p><b><i>Entity Type:</i></b></p>
      <blockquote>
        <xsl:for-each select="enttypl">
          <p><b>Entity Type Label: </b><xsl:value-of select="." /></p>
        </xsl:for-each>
        <xsl:for-each select="enttypd">
          <p><b>Entity Type Definition:</b></p>
          <p>   
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
        <xsl:for-each select="enttypds">
          <p><b>Entity Type Definition Source:</b></p>
          <p>
            <xsl:call-template name="replace-newlines">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </p>
        </xsl:for-each>
      </blockquote>
    </xsl:for-each>
    <xsl:if test="string-length( attr )">
      <p><b><i>Attributes:</i></b></p>
      <ul>
        <xsl:for-each select="attr">
          <xsl:sort select="attrlabl"/>
          <li><xsl:text disable-output-escaping="yes">&lt;a href="#attr</xsl:text><xsl:value-of select="attrlabl"/><xsl:text disable-output-escaping="yes">"/&gt;</xsl:text><xsl:value-of select="attrlabl"/><xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text></li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    <xsl:apply-templates select="attr"/>
  </xsl:template>

  <!-- Attribute (recursive): -->

  <xsl:template match="attr">
    <xsl:text disable-output-escaping="yes">&lt;a name="attr</xsl:text><xsl:value-of select="attrlabl"/><xsl:text disable-output-escaping="yes">"/&gt;</xsl:text><p><b><i>Attribute:</i></b></p><xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
    <blockquote>
      <xsl:for-each select="attrlabl">
        <p><b>Attribute Label: </b><xsl:value-of select="." /></p>
      </xsl:for-each>
      <xsl:for-each select="attrdef">
        <p><b>Attribute Definition:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="attrdefs">
        <p><b>Attribute Definition Source:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="attrdomv">
        <p><b>Attribute Domain Values:</b></p>
        <blockquote>
          <xsl:for-each select="edom">
            <p><b>Enumerated Domain:</b></p>
            <blockquote>
              <xsl:for-each select="edomv">
                <p><b>Enumerated Domain Value: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="edomvd">
                <p><b>Enumerated Domain Value Definition:</b></p>
                <p>
                  <xsl:call-template name="replace-newlines">
                    <xsl:with-param name="element" select="."/>
                  </xsl:call-template>
                </p>
              </xsl:for-each>
              <xsl:for-each select="edomvds">
                <p><b>Enumerated Domain Value Definition Source:</b></p>
                <p>
                  <xsl:call-template name="replace-newlines">
                    <xsl:with-param name="element" select="."/>
                  </xsl:call-template>
                </p>
              </xsl:for-each>
              <xsl:apply-templates select="attr"/>
            </blockquote>
          </xsl:for-each>
          <xsl:for-each select="rdom">
            <p><b>Range Domain:</b></p>
            <blockquote>
              <xsl:for-each select="rdommin">
                <p><b>Range Domain Minimum: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="rdommax">
                <p><b>Range Domain Maximum: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="attrunit">
                <p><b>Attribute Units of Measure: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="attrmres">
                <p><b>Attribute Measurement Resolution: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:apply-templates select="attr"/>
            </blockquote>
          </xsl:for-each>
          <xsl:for-each select="codesetd">
            <p><b>Codeset Domain:</b></p>
            <blockquote>
              <xsl:for-each select="codesetn">
                <p><b>Codeset Name: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="codesets">
                <p><b>Codeset Source: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
            </blockquote>
          </xsl:for-each>
          <xsl:for-each select="udom">
            <p><b>Unrepresentable Domain:</b></p>
            <p>
              <xsl:call-template name="replace-newlines">
                <xsl:with-param name="element" select="."/>
              </xsl:call-template>
            </p>
          </xsl:for-each>
        </blockquote>
      </xsl:for-each>
      <xsl:for-each select="begdatea">
        <p>
          <b>Beginning Date of Attribute Values: </b>
          <xsl:call-template name="date">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="enddatea">
        <p><b>Ending Date of Attribute Values: </b>
          <xsl:call-template name="date">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="attrvai">
        <p><b>Attribute Value Accuracy Information:</b></p>
        <blockquote>
          <xsl:for-each select="attrva">
            <p><b>Attribute Value Accuracy: </b><xsl:value-of select="." /></p>
          </xsl:for-each>
          <xsl:for-each select="attrvae">
            <p><b>Attribute Value Accuracy Explanation:</b></p>
            <p>
              <xsl:call-template name="replace-newlines">
                <xsl:with-param name="element" select="."/>
              </xsl:call-template>
            </p>
          </xsl:for-each>
        </blockquote>
      </xsl:for-each>
      <xsl:for-each select="attrmfrq">
        <p><b>Attribute Measurement Frequency:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
    </blockquote>
  </xsl:template>

  <xsl:template match="overview">
    <h4>Overview Description:</h4>
    <xsl:for-each select="eaover">
      <p><b><i>Entity and Attribute Overview:</i></b></p>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="procdesc"/>
        </xsl:call-template>
      </p>
    </xsl:for-each>
    <xsl:for-each select="eadetcit">
      <p><b><i>Entity and Attribute Detail Citation:</i></b></p>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="procdesc"/>
        </xsl:call-template>
      </p>
    </xsl:for-each>
  </xsl:template>

  <!-- DISTRIBUTION_INFORMATION: ********************************************-->

  <xsl:template match="distinfo">
    <hr/>
    <h3><a name="Distribution_Information"></a>Distribution Information:</h3>
    <xsl:apply-templates select="distrib"/>
    <xsl:apply-templates select="resdesc"/>
    <xsl:apply-templates select="distliab"/>
    <xsl:apply-templates select="stdorder"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p> 
  </xsl:template>

  <xsl:template match="distrib">
    <h4>Distributor:</h4>
    <xsl:call-template name="cntinfo">
      <xsl:with-param name="element" select="cntinfo"/>
    </xsl:call-template>
  </xsl:template> 

  <xsl:template match="resdesc"> 
    <xsl:if test="string-length( . )">
      <h4>Resource Description:</h4>
      <p><xsl:value-of select="."/></p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="distliab">
    <xsl:if test="string-length( . ) and not( contains( ., 'Unknown' ) )">
      <h4>Distribution Liability:</h4>
      <p>
        <xsl:call-template name="replace-newlines">
          <xsl:with-param name="element" select="."/>
        </xsl:call-template>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="stdorder"> 
    <xsl:if test="string-length( fees )">
      <h4>Standard Order Process:</h4>
      <xsl:apply-templates select="digform"/>
      <p><b><i>Fees: </i></b><xsl:value-of select="fees"/></p>
      <xsl:if test="string-length( ordering )">
        <p><b><i>Ordering Instructions: </i></b><xsl:value-of select="ordering"/></p>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="digform">
    <p><b><i>Digital Form:</i></b></p>
    <blockquote>
      <xsl:apply-templates select="digtinfo"/> 
      <xsl:apply-templates select="digtopt"/>
    </blockquote>
  </xsl:template>

  <xsl:template match="digtinfo">
    <p><b>Digital Transfer Information:</b></p>
    <blockquote>
      <p><b>Format Name: </b><xsl:value-of select="formname"/></p>
      <xsl:for-each select="formvern">
        <p><b>Format Version Number: </b><xsl:value-of select="." /></p>
      </xsl:for-each>
      <xsl:for-each select="formverd">
        <p>
          <b>Format Version Date: </b>
          <xsl:call-template name="date">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="formspec">
        <p><b>Format Specification:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="asciistr">
        <p><b>ASCII File Structure:</b></p>
        <blockquote>
          <xsl:for-each select="recdel">
            <p><b>Record Delimiter: </b><xsl:value-of select="." /></p>
          </xsl:for-each>
          <xsl:for-each select="numheadl">
            <p><b>Number Header Lines: </b><xsl:value-of select="." /></p>
          </xsl:for-each>
          <xsl:for-each select="deschead">
            <p><b>Description of Header Content:</b></p>
            <p>
              <xsl:call-template name="replace-newlines">
                <xsl:with-param name="element" select="."/>
              </xsl:call-template>
            </p>
          </xsl:for-each>
          <xsl:for-each select="orienta">
            <p><b>Orientation: </b><xsl:value-of select="." /></p>
          </xsl:for-each>
          <xsl:for-each select="casesens">
            <p><b>Case Sensitive: </b><xsl:value-of select="." /></p>
          </xsl:for-each>
          <xsl:for-each select="authent">
            <p><b>Authentication: </b></p>
            <p>
              <xsl:call-template name="replace-newlines">
                <xsl:with-param name="element" select="."/>
              </xsl:call-template>
            </p>
          </xsl:for-each>
          <xsl:for-each select="quotech">
            <p><b>Quote Character: </b><xsl:value-of select="." /></p>
          </xsl:for-each>
          <xsl:for-each select="datafiel">
            <p><b>Data Field:</b></p>
            <blockquote>
              <p><b>Data Field Name: </b><xsl:value-of select="dfieldnm" /></p>
              <xsl:for-each select="missingv">
                <p><b>Missing Value Code: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="dfwidthd">
                <p><b>Data Field Width Delimiter: </b><xsl:value-of select="." /></p>
              </xsl:for-each>
              <xsl:for-each select="dfwidth">
                <p><b>Data Field Width: </b> <xsl:value-of select="." /></p>
              </xsl:for-each>
            </blockquote>
          </xsl:for-each>
        </blockquote>
      </xsl:for-each>
      <xsl:for-each select="formcont">
        <p><b>Format Information Content:</b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
      <xsl:for-each select="filedec">
        <p><b>File Decompression Technique: </b><xsl:value-of select="." /></p>
      </xsl:for-each>
      <xsl:for-each select="transize">
        <p><b>Transfer Size: </b><xsl:value-of select="." /> MB</p>
      </xsl:for-each>
    </blockquote>
  </xsl:template>

  <xsl:template match="digtopt">
    <font color="#6e6e6e">
    <p><b>Digital Transfer Option:</b></p>
    <blockquote>
      <p><b>Online Option:</b></p>
      <blockquote>
        <p><b>Computer Contact Information:</b></p>
        <blockquote>
          <p><b>Network Address:</b></p>
          <blockquote>
            <xsl:variable name="url">
              <!-- Replace PacIOOS internal URL with external proxy: -->
              <xsl:call-template name="replace-string">
                <xsl:with-param name="element" select="onlinopt/computer/networka/networkr"/>
                <xsl:with-param name="old-string">lawelawe.soest.hawaii.edu:8080</xsl:with-param>
                <xsl:with-param name="new-string">oos.soest.hawaii.edu</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <span style="float: left; margin-right: 4px;"><b>Network Resource Name: </b></span><a href="{$url}"><div class="wrapline"><xsl:value-of select="$url"/></div></a>
            <!--<div class="wrapline"><b>Network Resource Name: </b><a href="{$url}"><xsl:value-of select="$url"/></a></p>-->
          </blockquote>
        </blockquote>
      </blockquote>
    </blockquote>
    </font>
  </xsl:template>

  <!-- METADATA_REFERENCE_INFORMATION: **************************************-->
 
  <xsl:template match="metainfo">
    <hr/>
    <h3><a name="Metadata_Reference_Information"></a>Metadata Reference Information:</h3>
    <xsl:apply-templates select="metd"/>
    <xsl:apply-templates select="metrd"/>
    <xsl:apply-templates select="metfrd"/>
    <xsl:apply-templates select="metc"/>
    <xsl:apply-templates select="metstdn"/>
    <xsl:apply-templates select="metstdv"/>
    <xsl:apply-templates select="mettc"/>
    <xsl:apply-templates select="metac"/>
    <xsl:apply-templates select="metuc"/>
    <xsl:apply-templates select="metsi"/>
    <xsl:apply-templates select="metextns"/>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template>

  <xsl:template match="metd">
    <h4 style="display: inline;">Metadata Date:</h4>
    <p style="display: inline;">
      <xsl:call-template name="date">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
    <p></p>
  </xsl:template>

  <xsl:template match="metrd">
    <h4>Metadata Review Date:</h4>
    <p>
      <xsl:call-template name="date">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="metfrd">
    <h4>Metadata Future Review Date:</h4>
    <p>
      <xsl:call-template name="date">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="metc">
    <h4>Metadata Contact:</h4>
    <xsl:call-template name="cntinfo">
      <xsl:with-param name="element" select="cntinfo"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="metstdn">
    <h4>Metadata Standard Name:</h4>
    <p><xsl:value-of select="."/></p>
  </xsl:template>

  <xsl:template match="metstdv">
    <h4>Metadata Standard Version:</h4>
    <p><xsl:value-of select="."/></p>
  </xsl:template>

  <xsl:template match="mettc">
    <h4 style="display: inline;">Metadata Time Convention:</h4>
    <p style="display: inline;"><xsl:value-of select="." /></p>
  </xsl:template>

  <xsl:template match="metac">
    <h4>Metadata Access Constraints:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="metuc">
    <h4>Metadata Use Constraints:</h4>
    <p>
      <xsl:call-template name="replace-newlines">
        <xsl:with-param name="element" select="."/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template match="metsi">
    <h4>Metadata Security Information:</h4>
    <blockquote>
      <xsl:for-each select="metscs">
        <p><b><i>Metadata Security Classification System: </i></b><xsl:value-of select="." /></p>
      </xsl:for-each>
      <xsl:for-each select="metsc">
        <p><b><i>Metadata Security Classification: </i></b><xsl:value-of select="." /></p>
      </xsl:for-each>
      <xsl:for-each select="metshd">
        <p><b><i>Metadata Security Handling Description:</i></b></p>
        <p>
          <xsl:call-template name="replace-newlines">
            <xsl:with-param name="element" select="."/>
          </xsl:call-template>
        </p>
      </xsl:for-each>
    </blockquote>
  </xsl:template>

  <xsl:template match="metextns">
    <h4>Metadata Extensions:</h4>
    <blockquote>
      <xsl:for-each select="onlink">
        <p><b><i>Online Linkage:</i></b> <a href="{.}"><xsl:value-of select="."/></a></p>
      </xsl:for-each>
      <xsl:for-each select="metprof">
        <p><b><i>Profile Name: </i></b> <xsl:value-of select="." /></p>
      </xsl:for-each>
    </blockquote>
  </xsl:template>

  <!-- NAMED TEMPLATES: *****************************************************-->

  <!-- template: citeinfo ***************************************************-->

  <xsl:template name="citeinfo">
    <xsl:param name="element"/>
    <xsl:param name="italicize-heading"/>
    <xsl:choose>
      <xsl:when test="$italicize-heading">
        <p><b><i>Citation Information:</i></b></p>
      </xsl:when>
      <xsl:otherwise>
        <p><b>Citation Information:</b></p>
      </xsl:otherwise>
    </xsl:choose>
    <blockquote>
      <p>
      <xsl:for-each select="$element/origin">
        <b>Originator: </b><xsl:value-of select="."/><br/>
      </xsl:for-each>
      <xsl:if test="string-length( $element/pubdate )"> 
        <b>Publication Date: </b>
        <xsl:call-template name="date">
          <xsl:with-param name="element" select="$element/pubdate"/>
        </xsl:call-template><br/>
      </xsl:if>
      <b>Title: </b><xsl:value-of select="$element/title"/><br/>
      <xsl:if test="string-length( $element/edition )">
        <b>Edition: </b><xsl:value-of select="$element/edition"/><br/>
      </xsl:if>
      <xsl:if test="string-length( $element/geoform )">
        <b>Geospatial Data Presentation Form: </b><xsl:value-of select="$element/geoform"/><br/>
      </xsl:if>
      <xsl:if test="string-length( $element/serinfo/sername ) and string-length( $element/serinfo/issue )">
        <b>Series Information:</b><br/>
        <blockquote>
          <b>Series Name: </b><xsl:value-of select="$element/serinfo/sername"/><br/>
          <b>Issue Identification: </b><xsl:value-of select="$element/serinfo/issue"/><br/>
        </blockquote>
      </xsl:if>
      <xsl:if test="string-length( $element/pubinfo/pubplace ) and string-length( $element/pubinfo/publish )">
        <b>Publication Information:</b><br/>
        <blockquote>
          <p>
          <b>Publication Place: </b><xsl:value-of select="$element/pubinfo/pubplace"/><br/>
          <b>Publisher: </b><xsl:value-of select="$element/pubinfo/publish"/><br/>
          </p>
        </blockquote>
      </xsl:if>
      <xsl:if test="string-length( $element/onlink )">
        <p><b>Online Linkage: </b><a href="{$element/onlink}"><xsl:value-of select="$element/onlink"/></a></p>
      </xsl:if>
      </p>
    </blockquote>
  </xsl:template>

  <!-- template: cntinfo ****************************************************-->

  <xsl:template name="cntinfo">
    <xsl:param name="element"/>
    <p><b><i>Contact Information:</i></b></p>
    <blockquote>
      <!-- Choose whether to use cntorgp or cntperp: -->
      <xsl:choose>
        <xsl:when test="$element/cntorgp">
          <p><b>Contact Organization Primary:</b></p>
          <blockquote>
            <p>
              <b>Contact Organization: </b><xsl:value-of select="$element/cntorgp/cntorg"/><br/>
              <xsl:if test="string-length( $element/cntorgp/cntper )">
                <b>Contact Person: </b><xsl:value-of select="$element/cntorgp/cntper"/><br/>
              </xsl:if>
            </p>
          </blockquote>
        </xsl:when>
        <xsl:otherwise>
          <p><b>Contact Person Primary:</b></p>
          <blockquote>
            <p>
              <b>Contact Person: </b><xsl:value-of select="$element/cntperp/cntper"/><br/>
              <xsl:if test="$element/cntperp/cntorg">
                <b>Contact Organization: </b><xsl:value-of select="$element/cntperp/cntorg"/><br/>
              </xsl:if>
            </p>
          </blockquote>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="$element/cntaddr">
        <xsl:if test="string-length( address ) or string-length( city ) or string-length( state ) or string-length( postal ) or string-length( country )">
          <p><b>Contact Address:</b></p>
          <blockquote>
            <p>
              <b>Address Type: </b><xsl:value-of select="addrtype"/><br/>
              <xsl:if test="string-length( address )">
                <b>Address:</b><br/><br/>
                <xsl:for-each select="address">
                  <xsl:if test="string-length( . )">
                    <xsl:value-of select="."/><br/>
                  </xsl:if>
                </xsl:for-each>
                <br/>
              </xsl:if>
              <xsl:if test="string-length( city )">
                <b>City: </b><xsl:value-of select="city"/><br/>
              </xsl:if>
              <xsl:if test="string-length( state )">
                <b>State or Province: </b><xsl:value-of select="state"/><br/>
              </xsl:if>
              <xsl:if test="string-length( postal )">
                <b>Postal Code: </b><xsl:value-of select="postal"/><br/>
              </xsl:if>
              <xsl:if test="string-length( country )">
                <b>Country: </b><xsl:value-of select="country"/><br/>
              </xsl:if>
            </p>
          </blockquote>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="string-length( $element/cntvoice )
                 or string-length( $element/cntfax )
                 or string-length( $element/cntemail )">
        <p>
          <xsl:for-each select="$element/cntvoice">
            <xsl:if test="string-length( . ) and . != 'Unknown'">
              <b>Contact Voice Telephone: </b><xsl:value-of select="."/><br/>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="$element/cntfax">
            <xsl:if test="string-length( . ) and . != 'Unknown'">
              <b>Contact Facsimile Telephone: </b><xsl:value-of select="."/><br/>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="$element/cntemail">
            <xsl:if test="string-length( . ) and . != 'Unknown'">
              <b>Contact Electronic Mail Address: </b><a href="mailto:{.}"><xsl:value-of select="."/></a><br/>
            </xsl:if>
          </xsl:for-each>
        </p>
      </xsl:if>
    </blockquote>
  </xsl:template>

  <!-- template: timeinfo **************************************************-->

  <xsl:template name="timeinfo">
    <xsl:param name="element"/>
    <xsl:param name="italicize-heading"/>
    <xsl:choose>
      <xsl:when test="$italicize-heading">
        <p><b><i>Time Period Information:</i></b></p>
      </xsl:when>
      <xsl:otherwise>
        <p><b>Time Period Information:</b></p>
      </xsl:otherwise>
    </xsl:choose>
    <blockquote>
      <p><b>Range of Dates/Times:</b></p>
      <blockquote>
        <p>
          <b>Beginning Date: </b>
          <xsl:call-template name="date">
            <xsl:with-param name="element" select="$element/rngdates/begdate"/>
          </xsl:call-template><br/>
          <b>Ending Date: </b>
          <xsl:call-template name="date">
            <xsl:with-param name="element" select="$element/rngdates/enddate"/>
          </xsl:call-template>
        </p>
      </blockquote>
    </blockquote>
  </xsl:template>

  <!-- template: date ******************************************************-->

  <xsl:template name="date">
    <xsl:param name="element"/>
    <xsl:choose>
      <xsl:when test="contains( $element, 'known' )">
        <xsl:value-of select="$element"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="year" select="substring($element, 1, 4)"/>
        <xsl:variable name="month" select="substring($element, 5, 2)"/>
        <xsl:variable name="day" select="substring($element, 7, 2)"/>
        <xsl:if test="$month = '01'">
          <xsl:text>January </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '02'">
          <xsl:text>February </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '03'">
          <xsl:text>March </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '04'">
          <xsl:text>April </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '05'">
          <xsl:text>May </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '06'">
          <xsl:text>June </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '07'">
          <xsl:text>July </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '08'">
          <xsl:text>August </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '09'">
          <xsl:text>September </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '10'">
          <xsl:text>October </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '11'">
          <xsl:text>November </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '12'">
          <xsl:text>December </xsl:text>
        </xsl:if>
        <xsl:if test="string-length( $day )">
          <xsl:choose>
            <xsl:when test="$day = '01'">
              <xsl:variable name="daydisplay" select="'1'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '02'">
              <xsl:variable name="daydisplay" select="'2'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '03'">
              <xsl:variable name="daydisplay" select="'3'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '04'">
              <xsl:variable name="daydisplay" select="'4'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '05'">
              <xsl:variable name="daydisplay" select="'5'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '06'">
              <xsl:variable name="daydisplay" select="'6'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '07'">
              <xsl:variable name="daydisplay" select="'7'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '08'">
              <xsl:variable name="daydisplay" select="'8'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '09'">
              <xsl:variable name="daydisplay" select="'9'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$day"/><xsl:text>, </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:value-of select="$year"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
