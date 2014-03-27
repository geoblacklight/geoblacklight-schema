
Solr schema
===========

The schema XML is on Github here: https://github.com/sul-dlss/geohydra/blob/master/solr/kurma-app-test/conf/schema.xml.

Primary key
----------

- *uuid*: Unique Identifier. Examples:
    - http://purl.stanford.edu/vr593vj7147,
    - http://ark.cdlib.org/ark:/28722/bk0012h535q,
    - urn:geodata.tufts.edu:Tufts.CambridgeGrid100_04.

Dublin Core
----------

See the [Dublin Core Elements
Guide](http://dublincore.org/documents/dcmi-terms/) for semantic descriptions
of all of these fields. We're using both DC Elements and DC Terms

- *dct_spatial_sm*: Coverage, placenames. Multiple values allowed. Example: "Paris, France".
- *dct_temporal_sm*: Coverage, years. Multiple values allowed. Example: "2010".
- *dc_creator_sm*: Author(s). Example: "Washington, George".
- *dct_issued_dt*: Date in Solr syntax. Example: "2001-01-01T00:00:00Z".
- *dc_description_s*: Description.
- *dc_format_s*: File format (not MIME types). Valid values:
    - "Shapefile"
    - "GeoTIFF"
- *dc_identifier_s*: Unique identifier. Same as UUID.
- *dc_language_s*: Language. Example: "English".
- *dc_publisher_s*: Publisher. Example: "ML InfoMap (Firm)".
- *dct_references_sm*: URLs to referenced resources. Used scheme and url parameters. scheme values are based on [CatInterop|https://github.com/OSGeo/Cat-Interop/blob/master/link_types.csv] Multiple values allowed. Example:
scheme="urn:ogc:serviceType:WebFeatureService" url="http://geowebservices-restricted.stanford.edu/geoserver
/wfs"
- *dc_rights_s*: Rights for access. Valid values:
    - "Restricted"
    - "Public"
- *dct_provenance_s*: Source institution: Examples:
    - Berkeley
    - Harvard
    - MassGIS
    - MIT
    - Stanford
    - Tufts
- *dc_subject_sm*: Subject. Multiple values allowed. Example: "Human settlements", "Census".
- *dc_title_s*: Title.
- *dc_type_s*: Resource type. dc:type=Dataset for georectified images, dc:type=Image for digitaized, non-georectified images, or dc:type=PhysicalObject for paper maps (no digitization).
- *dct_isPartOf_sm*: Collection to which the layer belongs.
- *dct_available_sm*: Date range for when the data are available.

GeoRSS metadata
===============

- *georss_point_s*: Point representation for layer -- i.e., centroid?
- *georss_box_s*: Bounding box as maximum values for S W N E. Example: "12.62309 76.76 19.91705 84.76618"
- *georss_polygon_s*: Shape of the layer as a Polygon.
Example: "n w n e s e s w n w"

Layer-specific metadata
=======================

- *layer_slug_s*. Unique identifier visible to the user, used for Permalinks.
- Example: stanford-vr593vj7147.
- *layer_id_s*. The complete identifier for the WMS/WFS/WCS layer.
Example: "druid:vr593vj7147",
- *layer_geom_type_s*. Valid values are: "Point", "Line", "Polygon", and "Raster".

Derived metadata used by Solr index
===================================

- *solr_bbox*: Bounding box as maximum values for W S E N. Example: "76.76 12.62309 84.76618 19.91705"
- *solr_geom*: Shape of the layer as a Point, LineString, or Polygon WKT.
Example: "POLYGON((76.76 19.91705, 84.76618 19.91705, 84.76618 12.62309, 76.76 12.62309, 76.76 19.91705))"
- *solr_ne_pt* (from solr_bbox). North-eastern most point of the bounding box, as (y, x). Example: "83.1,-128.5"
- *solr_sw_pt* (from solr_bbox). South-western most point of the bounding box, as (y, x). Example: "81.2,-130.1"
- *solr_year_i* (from dc_coverage_temporal_sm): Year for which layer is valid. Example: 2012.

Solr schema syntax
==================

See complete schema on https://github.com/sul-dlss/geomdtk/blob/master/solr/kurma-app-test/conf/schema.xml

Note on the types:

| Suffix | Solr data type using dynamicField |
| ------ | --------------------------------- |
| `_s` | String |
| `_sm` | String, multivalued |
| `_t` | Text, English |
| `_i` | Integer |
| `_dt` | Date time |
| `_url` | URL as a non-indexed String |
| `_bbox` | Spatial bounding box, Rectangle as (w, s, e, n) |
| `_pt` | Spatial point as (y,x) |
| `_geom` | Spatial shape as WKT |


	<?xml version="1.0" encoding="UTF-8"?>
	<schema name="GeoBlacklight" version="1.5">
	  <uniqueKey>uuid</uniqueKey>
	  <fields>
	  ...
	    <!-- Spatial field types:
    
	         Solr3:
	           <field name="my_pt">83.1,-117.312</field> 
	             as (y,x)

	         Solr4:             

	           <field name="my_bbox">-117.312 83.1 -115.39 84.31</field> 
	             as (W S E N)

	           <field name="my_geom">POLYGON((1 8, 1 9, 2 9, 2 8, 1 8))</field> 
	             as WKT for point, linestring, polygon

	      -->
	    <dynamicField name="*_pt"     type="location"     stored="true" indexed="true"/>
	    <dynamicField name="*_bbox"   type="location_rpt" stored="true" indexed="true"/>
	    <dynamicField name="*_geom"   type="location_jts" stored="true" indexed="true"/>
	  </fields>
	  <types>
	    ...
	    <fieldType name="location" class="solr.LatLonType" subFieldSuffix="_d"/>
	    <fieldType name="location_rpt" class="solr.SpatialRecursivePrefixTreeFieldType"
	               distErrPct="0.025"
	               maxDistErr="0.000009"
	               units="degrees"
	            />
	    <fieldType name="location_jts" class="solr.SpatialRecursivePrefixTreeFieldType"
	               spatialContextFactory="com.spatial4j.core.context.jts.JtsSpatialContextFactory"
	               distErrPct="0.025"
	               maxDistErr="0.000009"
	               units="degrees"
	            />
	  </types>
	</schema>


Solr queries
============

- Use the Solr query interface with LatLon data on [sul-solr-a](http://sul-solr-a/solr/#/) to try these using ogp core.
- For the polygon or JTS queries use [ogpapp-test](http://localhost:8983/solr/#/) via ssh tunnel to jetty 8983.

Solr 3: Pseudo-spatial using `solr.LatLon`
==========================================

`solr.LatLonType` does not correctly work across the international dateline in these queries. `_latlon` in these examples are assumed to be solr.LatLonType.

Search for point within 50 km of N40 W114
----------------------------------------

Note: Solr `_bbox` uses circle with radius not rectangles.

	<str name="d">50</str>
	<str name="q">*:*</str>
	<str name="sfield">solr_latlon</str>
	<str name="pt">40,-114</str>
	<str name="fq">{!geofilt}</str>


Search for single point _within_ a bounding box of SW=40,-120 NE=50,-110
-----------------------------------------------------------------------

	<str name="q">*:*</str>
	<str name="fq">solr_latlon:[40,-120 TO 50,-110]</str>

Search for bounding box _within_ a bounding box of SW=20,-160 NE=70,-70
----------------------------------------------------------------------

	<str name="q">*:*</str>
	<str name="fq">solr_sw_latlon:[20,-160 TO 70,-70] AND solr_ne_latlon:[20,-160 TO 70,-70]</str>

Solr 4 Spatial -- non JTS
=========================

`_pt` and `_bbox` in these examples are assumed to be `solr.SpatialRecursivePrefixTreeFieldType`.

Search for point _within_ a bounding box of SW=20,-160 NE=70,-70
---------------------------------------------------------------

	<str name="q">*:*</str>
	<str name="fq">solr_pt:"Intersects(-160 20 -70 70)"</str>

Search for bounding box _within_ a bounding box of SW=20,-160 NE=70,-70
-----------------------------------------------------------------------------

	<str name="q">*:*</str>
	<str name="fq">solr_sw_pt:[20,-160 TO 70,-70] AND solr_ne_pt:[20,-160 TO 70,-70]</str>


Solr 4: ... using polygon intersection
-------------------------------------------

	<str name="q">*:*</str>
	<str name="fq">solr_bbox:"Intersects(-160 20 -70 70)"</str>

Solr 4: ... using polygon containment
-------------------------------------------

	<str name="q">*:*</str>
	<str name="fq">solr_bbox:"IsWithin(-160 20 -150 30)"</str>

Solr 4: ... using polygon containment for spatial relevancy
---------------------------------------------------------------------

	<str name="q">solr_bbox:"IsWithin(-160 20 -150 30)"^10 railroads</str>
	<str name="fq">solr_bbox:"Intersects(-160 20 -150 30)"</str>


Solr 4 Spatial -- JTS
=====================

This query requires [JTS](http://tsusiatsoftware.net/jts/main.html) installed in
Solr 4, where the
`spatialContextFactory="com.spatial4j.core.context.jts.JtsSpatialContextFactory"`
for the `solr.SpatialRecursivePrefixTreeFieldType` field class.


Search for bbox _intersecting_ bounding box of SW=20,-160 NE=70,-70 using polygon intersection
----------------------------------------------------------------------------------------------------


	<str name="q">*:*</str>
	<str name="fq">solr_bbox:"Intersects(POLYGON((-160 20, -160 70, -70 70, -70 20, -160 20)))"</str>


Scoring formula
---------------------

	text^1
	dc_description_ti^2
	dc_creator_tmi^3
	dc_publisher_ti^3
	dct_isPartOf_tmi^4
	dc_subject_tmi^5
	dct_spatial_tmi^5
	dct_temporal_tmi^5
	dc_title_ti^6
	dc_rights_ti^7
	dct_provenance_ti^8
	layer_geom_type_ti^9
	layer_slug_ti^10
	dc_identifier_ti^10

Facets
------------

	<str name="facet.field">dct_spatial_sm</str>
	<str name="facet.field">dc_format_s</str>
	<str name="facet.field">dc_language_s</str>
	<str name="facet.field">dc_publisher_s</str>
	<str name="facet.field">dc_rights_s</str>
	<str name="facet.field">dct_provenance_s</str>
	<str name="facet.field">dc_subject_sm</str>
	<str name="facet.field">dct_isPartOf_sm</str>
	<str name="facet.field">layer_geom_type_s</str>
	<str name="facet.field">solr_year_i</str>

Solr example documents
======================

See https://github.com/sul-dlss/geohydra/blob/master/ogp/transform.rb.

These metadata would be generated from the OGP Schema, or MODS, or FGDC, or ISO 19139.

	  "uuid": "http://purl.stanford.edu/zy658cr1728",
	  "dc_description_s": "This point dataset shows village locations with socio-demographic and economic Census data f
	or 2001 for the Union Territory of Andaman and Nicobar Islands, India linked to the 2001 Census. Includes village s
	ocio-demographic and economic Census attribute data such as total population, population by sex, household, literac
	y and illiteracy rates, and employment by industry. This layer is part of the VillageMap dataset which includes soc
	io-demographic and economic Census data for 2001 at the village level for all the states of India. This data layer 
	is sourced from secondary government sources, chiefly Survey of India, Census of India, Election Commission, etc. T
	his map Includes data for 547 villages, 3 towns, 2 districts, and 1 union territory.; This dataset is intended for 
	researchers, students, and policy makers for reference and mapping purposes, and may be used for village level demo
	graphic analysis within basic applications to support graphical overlays and analysis with other spatial data.; ",
	  "dc_format_s": "Shapefile",
	  "dc_identifier_s": "http://purl.stanford.edu/zy658cr1728",
	  "dc_language_s": "English",
	  "dc_publisher_s": "ML InfoMap (Firm)",
	  "dc_rights_s": "Restricted",
	  "dc_subject_sm": [
	    "Human settlements",
	    "Villages",
	    "Census",
	    "Demography",
	    "Population",
	    "Sex ratio",
	    "Housing",
	    "Labor supply",
	    "Caste",
	    "Literacy",
	    "Society",
	    "",
	    "Location"
	  ],
	  "dc_title_s": "Andaman and Nicobar, India: Village Socio-Demographic and Economic Census Data, 2001",
	  "dc_type_s": "Dataset",
	  "dct_isPartOf_sm": "My Collection",
	  "dct_references_sm": [
	    "scheme=\"urn:ogc:serviceType:WebFeatureService\" url=\"http://geowebservices-restricted.stanford.edu/geoserver/wfs\"",
	    "scheme=\"urn:ogc:serviceType:WebMapService\" url=\"http://geowebservices-restricted.stanford.edu/geoserver/wms\"",
	    "scheme=\"urn:iso:dataFormat:19139\" url=\"http://purl.stanford.edu/zy658cr1728.iso19139\"",
	    "scheme=\"urn:x-osgeo:link:www\" url=\"http://purl.stanford.edu/zy658cr1728\"",
	    "scheme=\"urn:loc:dataFormat:MODS\" url=\"http://purl.stanford.edu/zy658cr1728.mods\"",
	    "scheme=\"urn:x-osgeo:link:www-thumbnail\", url=\"http://example.com/preview.jpg\""
	  ],
	  "dct_spatial_sm": [
	    "Andaman and Nicobar Islands",
	    "Andaman",
	    "Nicobar",
	    "Car Nicobar Island",
	    "Port Blair",
	    "Indira Point",
	    "Diglipur",
	    "Nancowry Island"
	  ],
	  "dct_temporal_sm": "2001-01-01T00:00:00Z",
	  "dct_issued_dt": "2000-01-01T00:00:00Z",
	  "dct_provenance_s": "Stanford",
	  "georss_box_s": "6.761581 92.234924 13.637013 94.262535",
	  "georss_polygon_s": "13.637013 92.234924 13.637013 94.262535 6.761581 94.262535 6.761581 92.234924 13.637013 92.234924",
	  "layer_slug_s": "stanford-zy658cr1728",
	  "layer_id_s": "druid:zy658cr1728",
	  "layer_srs_s": "EPSG:4326",
	  "layer_geom_type_s": "Point",
	  "solr_bbox": "92.234924 6.761581 94.262535 13.637013",
	  "solr_ne_pt": "13.637013,94.262535",
	  "solr_sw_pt": "6.761581,92.234924",
	  "solr_geom": "POLYGON((92.234924 13.637013, 94.262535 13.637013, 94.262535 6.761581, 92.234924 6.761581, 92.234924 13.637013))"
	  "score": 1.6703978
	}

Links
=====

- Solr 4: http://wiki.apache.org/solr/SolrAdaptersForLuceneSpatial4
- Solr 3: http://wiki.apache.org/solr/SpatialSearch
- JTS: http://tsusiatsoftware.net/jts/main.html