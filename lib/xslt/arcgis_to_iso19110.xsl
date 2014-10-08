<?xml version="1.0" encoding="utf-8"?>
<!--   ArcGIS to ISO19110 feature cataloging methodology transformation
        This file transforms ArcGIS formatted metadata into ISO19110 xml. Metadata expresses entity and attribute information and is linked to the 19139 record using the 'uuid' attribute.
          created 2013-07 by Kim Durante, Stanford University Libraries. -->

<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:gco="http://www.isotc211.org/2005/gco" 
  xmlns:gfc="http://www.isotc211.org/2005/gfc" 
  xmlns:gmd="http://www.isotc211.org/2005/gmd" 
  xmlns:gml="http://www.opengis.net/gml/3.2" 
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <xsl:template match="/">
  <gfc:FC_FeatureCatalogue xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" 
    xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns="http://www.isotc211.org/2005/gfc" xsi:schemaLocation="http://www.isotc211.org/2005/gfc http://www.isotc211.org/2005/gfc/gfc.xsd">

    <xsl:attribute name="uuid">
      <xsl:value-of select="metadata/contInfo/FetCatDesc/catCitation/citId"/>
    </xsl:attribute>
      
       <xsl:apply-templates select="child::node()"/>
     </gfc:FC_FeatureCatalogue>
  </xsl:template> 
 
  <xsl:template match="metadata">
        <gmx:name>
              <gco:CharacterString>
                 <xsl:value-of select="contInfo/FetCatDesc/catCitation/resTitle"/>
              </gco:CharacterString>
         </gmx:name>
         <gmx:scope>
          <gco:CharacterString>
          <xsl:for-each select="dataIdInfo/themeKeys/keyword">
            <xsl:value-of select="."/>
              <xsl:if test="position()!=last()">
              <xsl:text>; </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </gco:CharacterString>
         </gmx:scope>
          <gmx:versionNumber>
            <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
           </gmx:versionNumber>
         <gmx:versionDate>
            <gco:Date>
             <xsl:choose>
              <xsl:when test="contInfo/FetCatDesc/catCitation/date/pubDate">
                <xsl:value-of select="substring(dataIdInfo/idCitation/date/pubDate,1,4)"/>
              </xsl:when>
              <xsl:when test="dataIdInfo/idCitation/date/pubDate">
                <xsl:value-of select="substring(dataIdInfo/idCitation/date/pubDate,1,4)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            </gco:Date>
          </gmx:versionDate>
            <gmx:language>
              <gco:CharacterString>
                <xsl:value-of select="'eng; US'"/>
              </gco:CharacterString>
            </gmx:language>
          <gmx:characterSet>
            <gmd:MD_CharacterSetCode>
              <xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode</xsl:attribute>
              <xsl:attribute name="codeListValue">utf8</xsl:attribute>
              <xsl:attribute name="codeSpace">ISOTC211/19115</xsl:attribute>
            </gmd:MD_CharacterSetCode>
          </gmx:characterSet>
    <xsl:choose>
    <xsl:when test="contInfo/FetCatDesc/catCitation/citRespParty/rpOrgName">  
        <gfc:producer>
            <gmd:CI_ResponsibleParty>
                              <gmd:organisationName>
                            <gco:CharacterString>
                              <xsl:value-of select="contInfo/FetCatDesc/catCitation/citRespParty/rpOrgName"/>
                          </gco:CharacterString>
                </gmd:organisationName>
          
              <gmd:role>
                <gmd:CI_RoleCode>
                  <xsl:attribute name="codeList">
                    <xsl:value-of select="'http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode'"/></xsl:attribute>
                  <xsl:attribute name="codeListValue">
                    <xsl:value-of select="'originator'"/>
                  </xsl:attribute>
                  <xsl:attribute name="codeSpace">
                      <xsl:value-of select="'006'"/>
                  </xsl:attribute>
                </gmd:CI_RoleCode>
              </gmd:role>
            </gmd:CI_ResponsibleParty>
          </gfc:producer>
          </xsl:when>
  <xsl:when test="contInfo/FetCatDesc/catCitation/citRespParty/rpIndName">  
    <gfc:producer>
      <gmd:CI_ResponsibleParty>
        <gmd:individualName>
          <gco:CharacterString>
            <xsl:value-of select="contInfo/FetCatDesc/catCitation/citRespParty/rpIndName"/>
          </gco:CharacterString>
        </gmd:individualName>
        
        <gmd:role>
          <gmd:CI_RoleCode>
            <xsl:attribute name="codeList">
              <xsl:value-of select="'http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode'"/></xsl:attribute>
            <xsl:attribute name="codeListValue">
              <xsl:value-of select="'originator'"/>
            </xsl:attribute>
            <xsl:attribute name="codeSpace">
              <xsl:value-of select="'006'"/>
            </xsl:attribute>
          </gmd:CI_RoleCode>
        </gmd:role>
      </gmd:CI_ResponsibleParty>
    </gfc:producer>
  </xsl:when>
    </xsl:choose>
        <xsl:for-each select="eainfo/detailed">
                            <gfc:featureType>
                <gfc:FC_FeatureType>
                    <xsl:for-each select="enttyp">
                  <gfc:typeName>
                    <xsl:for-each select="enttypl">
                      <gco:LocalName>
                        <xsl:value-of select="."/>
                      </gco:LocalName>
                    </xsl:for-each>
                  </gfc:typeName>
                    <gfc:definition>
                    <xsl:for-each select="enttypd">
                      <gco:CharacterString>
                        <xsl:value-of select="."/>
                      </gco:CharacterString>
                    </xsl:for-each>
                  </gfc:definition>
                    </xsl:for-each>
                  <gfc:isAbstract>
                    <gco:Boolean>false</gco:Boolean>
                  </gfc:isAbstract>
                  <gfc:featureCatalogue>
                    <xsl:attribute name="uuidref">
                      <xsl:value-of select="//contInfo/FetCatDesc/catCitation/citId"/>
                    </xsl:attribute>
                  </gfc:featureCatalogue>
                  <xsl:for-each select="attr">
                      <gfc:carrierOfCharacteristics>
                      <gfc:FC_FeatureAttribute>
                        <!-- for range values -->
                        
                          <xsl:for-each select="attrlabl">
                             <gfc:memberName>
                                 <gco:LocalName>
                                    <xsl:value-of select="."/>
                                 </gco:LocalName>
                               </gfc:memberName>
                             </xsl:for-each>
                        
                        <xsl:for-each select="attrdef">
                            <gfc:definition>
                              <gco:CharacterString>
                                     <xsl:value-of select="."/>
                               </gco:CharacterString>
                                  </gfc:definition>
                              </xsl:for-each>
                        
                        <gfc:cardinality>
                            <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
                          </gfc:cardinality>
                        
                        <xsl:for-each select="attrdefs">
                          <gfc:definitionReference>
                            <gfc:FC_DefinitionReference>
                              <gfc:definitionSource>
                                <gfc:FC_DefinitionSource>
                                  <gfc:source>
                                    <gmd:CI_Citation>
                                      <gmd:title>
                                        <gco:CharacterString><xsl:value-of select="."/>
                                      </gco:CharacterString>
                                      </gmd:title>
                                      <gmd:date>
                                        <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
                                      </gmd:date>
                                      <gmd:citedResponsibleParty>
                                        <gmd:CI_ResponsibleParty>
                                          <gmd:organisationName>
                                            <gco:CharacterString>
                                              <xsl:value-of select="."/>
                                            </gco:CharacterString>
                                          </gmd:organisationName>
                                          <gmd:role>
                                            <gmd:CI_RoleCode>
                                              <xsl:attribute name="codeList">
                                                <xsl:value-of select="'http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode'"/>
                                              </xsl:attribute>
                                              <xsl:attribute name="codeListValue">
                                                <xsl:value-of select="'resourceProvider'"/>
                                              </xsl:attribute>
                                              <xsl:attribute name="codeSpace">
                                                <xsl:value-of select="'001'"/>
                                              </xsl:attribute>
                                            </gmd:CI_RoleCode>
                                          </gmd:role>
                                        </gmd:CI_ResponsibleParty>
                                      </gmd:citedResponsibleParty>
                                    </gmd:CI_Citation>
                                  </gfc:source>
                                </gfc:FC_DefinitionSource>
                              </gfc:definitionSource>
                            </gfc:FC_DefinitionReference>
                          </gfc:definitionReference>
                        </xsl:for-each>
                        
                      <xsl:for-each select="attrtype">
                          <gfc:valueType>
                            <gco:TypeName>
                              <gco:aName>
                                <gco:CharacterString>
                                  <xsl:value-of select="."/>
                                </gco:CharacterString>
                              </gco:aName>
                            </gco:TypeName>
                          </gfc:valueType>
                        </xsl:for-each>
                        
                    <xsl:for-each select="attrdomv/edom">
                          <gfc:listedValue>
                            <gfc:FC_ListedValue>
                              <xsl:for-each select="edomv">
                                <gfc:label>
                                  <gco:CharacterString>
                                    <xsl:value-of select="."/>
                                  </gco:CharacterString>
                                </gfc:label>
                              </xsl:for-each>
                              <xsl:for-each select="edomvd">
                                <gfc:definition>
                                  <gco:CharacterString>
                                    <xsl:value-of select="."/>
                                  </gco:CharacterString>
                                </gfc:definition>
                              </xsl:for-each>
                              <xsl:for-each select="edomvds">
                                <gfc:definitionReference>
                                  <gfc:FC_DefinitionReference>
                                    <gfc:definitionSource>
                                      <gfc:FC_DefinitionSource>
                                        <gfc:source>
                                          <gmd:CI_Citation>
                                            <gmd:title>
                                              <gco:CharacterString>
                                                  <xsl:value-of select="."/>
                                                </gco:CharacterString>
                                            </gmd:title>
                                            <gmd:date>
                                              <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
                                            </gmd:date>
                                            <gmd:citedResponsibleParty>
                                              <gmd:CI_ResponsibleParty>
                                                <gmd:organisationName>
                                                  <gco:CharacterString>
                                                    <xsl:value-of select="."/>
                                                  </gco:CharacterString>
                                                </gmd:organisationName>
                                                <gmd:role>
                                                  <gmd:CI_RoleCode>
                                                    <xsl:attribute name="codeList">
                                                      <xsl:value-of select="'http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode'"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="codeListValue">
                                                      <xsl:value-of select="'resourceProvider'"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="codeSpace">
                                                      <xsl:value-of select="'001'"/>
                                                    </xsl:attribute>
                                                  </gmd:CI_RoleCode>
                                                </gmd:role>
                                              </gmd:CI_ResponsibleParty>
                                            </gmd:citedResponsibleParty>
                                          </gmd:CI_Citation>
                                        </gfc:source>
                                      </gfc:FC_DefinitionSource>
                                    </gfc:definitionSource>
                                  </gfc:FC_DefinitionReference>
                                </gfc:definitionReference>
                              </xsl:for-each>
                            </gfc:FC_ListedValue>
                          </gfc:listedValue>
                        </xsl:for-each>
                        
                        
                        <xsl:for-each select="attudomv/codesetd">
                          <gfc:listedValue>
                            <gfc:FC_ListedValue>
                                  <xsl:for-each select="codesetn">
                                <gfc:label>
                                  <gco:CharacterString>
                                    <xsl:value-of select="."/>
                                  </gco:CharacterString>
                                </gfc:label>
                              </xsl:for-each>
                              <gfc:definitionReference>
                                <gfc:FC_DefinitionReference>
                                  <xsl:for-each select="codesets">
                                    <gfc:definitionSource>
                                      <gfc:FC_DefinitionSource>
                                        <gfc:source>
                                          <gmd:CI_Citation>
                                            <gmd:title>
                                              <gco:CharacterString>
                                                 <xsl:value-of select="."/>
                                              </gco:CharacterString>
                                            </gmd:title>
                                                     <gmd:date>
                                                      <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
                                                       </gmd:date>
                                            <gmd:citedResponsibleParty>
                                              <gmd:CI_ResponsibleParty>
                                                <gmd:organisationName>
                                                  <gco:CharacterString>
                                                    <xsl:value-of select="."/>
                                                  </gco:CharacterString>
                                                </gmd:organisationName>
                                                <gmd:role>
                                                  <gmd:CI_RoleCode>
                                                    <xsl:attribute name="codeList">
                                                      <xsl:value-of select="'http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode'"/>
                                                    </xsl:attribute>
                                                      <xsl:attribute name="codeListValue">
                                                      <xsl:value-of select="'resourceProvider'"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="codeSpace">
                                                        <xsl:value-of select="'001'"/>
                                                    </xsl:attribute>
                                                  </gmd:CI_RoleCode>
                                                </gmd:role>
                                              </gmd:CI_ResponsibleParty>
                                            </gmd:citedResponsibleParty>
                                          </gmd:CI_Citation>
                                        </gfc:source>
                                      </gfc:FC_DefinitionSource>
                                    </gfc:definitionSource>
                                  </xsl:for-each>
                                </gfc:FC_DefinitionReference>
                              </gfc:definitionReference>
                            </gfc:FC_ListedValue>
                          </gfc:listedValue>
                        </xsl:for-each>
                      </gfc:FC_FeatureAttribute>
                           </gfc:carrierOfCharacteristics>
                     </xsl:for-each>
                  </gfc:FC_FeatureType>
              </gfc:featureType>
                    </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>
