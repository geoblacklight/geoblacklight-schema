This schema focuses on discovery use cases for patrons and analysts in a research library
setting, although it is likely useful in other settings. Text search, faceted search and
refinement, and spatial search and relevancy are among the primary features that the schema
enables. The schema design supports a variety of discovery applications and GIS data types.
We especially wanted to provide for contextual collection-oriented discovery applications as
well as traditional portal applications.

#### Example

The `examples` folder has some Solr documents that uses this schema. First, install the
schema into a Solr 4 instance, then upload the documents.

    # install conf/ into your SOLR_HOME folder
    % cd examples
	% ruby upload-to-solr.rb your-collection-name http://localhost:8080

#  Schema for GeoBlacklight

### Primary key

- *uuid*: Unique Identifier. Examples:
    - `http://purl.stanford.edu/vr593vj7147`
    - `http://ark.cdlib.org/ark:/28722/bk0012h535q`
    - `urn:geodata.tufts.edu:Tufts.CambridgeGrid100_04`

### Dublin Core

See the [Dublin Core Elements
Guide](http://dublincore.org/documents/dcmi-terms/) for semantic descriptions
of all of these fields. We're using both DC Elements and DC Terms.

*dct_spatial_sm*
:	Coverage, placenames. Multiple values allowed. Example: `Paris, France`.

*dct_temporal_sm*
:	Coverage, years. Multiple values allowed. Example: `2010`

*dc_creator_sm*
:	Author(s). Example: `Washington, George`.

*dct_issued_dt*
:	Date in Solr syntax. Example: `2001-01-01T00:00:00Z`.

*dc_description_s*
: 	Description.

*dc_format_s*
:	File format (not MIME types). Valid values:
    `Shapefile`,
    `GeoTIFF`
	
*dc_identifier_s*
:	Unique identifier. Same as UUID.

*dc_language_s*
: 	Language. Example: `English`.

*dc_publisher_s*
: 	Publisher. Example: `ML InfoMap (Firm)`.

*dct_references_sm*
: 	URLs to referenced resources using XLink. 
	Role values are based on [CatInterop](https://github.com/OSGeo/Cat-Interop/blob/master/link_types.csv) Multiple values allowed. 
	Example: `<xlink link="simple" role="urn:ogc:serviceType:WebFeatureService" href="http://geowebservices-restricted.stanford.edu/geoserver/wfs"/>`

*dc_rights_s*
: 	Rights for access. Valid values:
    `Restricted`
    `Public`
	
*dct_provenance_s*: Source institution: Examples:
:    Berkeley
:    Harvard
:    MassGIS
:    MIT
:    Stanford
:    Tufts

*dc_subject_sm*
: 	Subject. Multiple values allowed. Example: `Human settlements, Census`

*dc_title_s*
: 	Title.

*dc_type_s* 
: 	Resource type. dc:type=Dataset for georectified images, dc:type=Image for
:	digitaized, non-georectified images, or dc:type=PhysicalObject for paper maps (no
:	digitization).

*dct_isPartOf_sm*
: 	Collection to which the layer belongs.

*dct_available_sm*
: 	Date range for when the data are available.

### GeoRSS

We use [GeoRSS](http://georss.org) for geometry encoding. Note that all data are in WGS84
(EPSG:4326 projection). Depending on your usage, only the bounding box field is required.

*georss_point_s*
: 	Point representation for layer -- i.e., centroid?

*georss_box_s*
: 	Bounding box as maximum values for S W N E. Example: `12.62309 76.76 19.91705 84.76618`

*georss_polygon_s*
: 	Shape of the layer as a Polygon.
:	Example: "n w n e s e s w n w"

### Layer-specific metadata

A variety of attributes are required for the discovery application. These are all layer-specific.

*layer_slug_s*
:	Unique identifier visible to the user, used for Permalinks.
:	Example: `stanford-vr593vj7147`.

*layer_id_s*
: 	The complete identifier for the WMS/WFS/WCS layer.
:	Example: `druid:vr593vj7147`

*layer_geom_type_s*
:	Valid values are: `Point`, `Line`, `Polygon`, and `Raster`.

### Derived metadata used by Solr index

For the Solr 4 implementation, we derive a few Solr-specific fields from other schema
properties.

*solr_bbox*
: 	(from `georss_box_s`). Bounding box as maximum values for W S E N. Example: `76.76 12.62309 84.76618 19.91705`

*solr_geom*
: 	(from `georss_polygon_s`). Shape of the layer as a Point, LineString, or Polygon WKT.
:	Example: `POLYGON((76.76 19.91705, 84.76618 19.91705, 84.76618 12.62309, 76.76 12.62309, 76.76 19.91705))`

*solr_ne_pt*
: 	(from `solr_bbox`). North-eastern most point of the bounding box, as (y, x). Example: `83.1,-128.5`

*solr_sw_pt*
: 	(from `solr_bbox`). South-western most point of the bounding box, as (y, x). Example: `81.2,-130.1`

*solr_year_i*
: 	(from `dc_coverage_temporal_sm`): Year for which layer is valid. Example: `2012`.

## Solr4 schema implementation

The [schema.xml](https://github.com/sul-dlss/geoblacklight-schema/blob/master/conf/schema.xml) is on Github.

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

```
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
```

# Solr queries

We provide a set of example Solr queries against this schema.

### Solr 3: Pseudo-spatial using `solr.LatLon`

`solr.LatLonType` does not correctly work across the international dateline in these queries. `_latlon` in these examples are assumed to be solr.LatLonType.

#### Search for point within 50 km of N40 W114

Note: Solr `_bbox` uses circle with radius not rectangles.

```
<str name="d">50</str>
<str name="q">*:*</str>
<str name="sfield">solr_latlon</str>
<str name="pt">40,-114</str>
<str name="fq">{!geofilt}</str>
```

#### Search for single point _within_ a bounding box of SW=40,-120 NE=50,-110

```
<str name="q">*:*</str>
<str name="fq">solr_latlon:[40,-120 TO 50,-110]</str>
```

#### Search for bounding box _within_ a bounding box of SW=20,-160 NE=70,-70

```
<str name="q">*:*</str>
<str name="fq">solr_sw_latlon:[20,-160 TO 70,-70] AND solr_ne_latlon:[20,-160 TO 70,-70]</str>
```

### Solr 4 Spatial

`_pt` and `_bbox` in these examples are assumed to be `solr.SpatialRecursivePrefixTreeFieldType`.

#### Search for point _within_ a bounding box of SW=20,-160 NE=70,-70

```
<str name="q">*:*</str>
<str name="fq">solr_pt:"Intersects(-160 20 -70 70)"</str>
```

#### Search for bounding box _within_ a bounding box of SW=20,-160 NE=70,-70

```
<str name="q">*:*</str>
<str name="fq">solr_sw_pt:[20,-160 TO 70,-70] AND solr_ne_pt:[20,-160 TO 70,-70]</str>
```


#### ... using polygon intersection

```
<str name="q">*:*</str>
<str name="fq">solr_bbox:"Intersects(-160 20 -70 70)"</str>
```

#### ... using polygon containment

```
<str name="q">*:*</str>
<str name="fq">solr_bbox:"IsWithin(-160 20 -150 30)"</str>
```

#### ... using polygon containment for spatial relevancy

This is the **primary** query used by GeoBlacklight. In this example, we score containment by
10x and issue a text query, then filter the results via intersection.

```
<str name="q">solr_bbox:"IsWithin(-160 20 -150 30)"^10 railroads</str>
<str name="fq">solr_bbox:"Intersects(-160 20 -150 30)"</str>
```

### Solr 4 Spatial *using  JTS*

This query requires [JTS](http://tsusiatsoftware.net/jts/main.html) installed in
Solr 4, where the
`spatialContextFactory="com.spatial4j.core.context.jts.JtsSpatialContextFactory"`
for the `solr.SpatialRecursivePrefixTreeFieldType` field class.

#### Search for bbox _intersecting_ bounding box of SW=20,-160 NE=70,-70 using polygon intersection

```
<str name="q">*:*</str>
<str name="fq">solr_bbox:"Intersects(POLYGON((-160 20, -160 70, -70 70, -70 20, -160 20)))"</str>
```

### Scoring formula

This is the default scoring formula in
[solrconfig.xml](https://github.com/sul-dlss/geoblacklight-schema/blob/master/conf/solrconfig.xml):

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

### Facets

These attributes are all available as facets:

	dct_isPartOf_sm
	dct_provenance_s
	dct_spatial_sm
	dc_format_s
	dc_language_s
	dc_publisher_s
	dc_rights_s
	dc_subject_sm
	layer_geom_type_s
	solr_year_i

# Solr example documents


These metadata would be generated from the OGP Schema, or MODS, or FGDC, or ISO 19139.

See https://github.com/sul-dlss/geohydra/blob/master/ogp/transform.rb.

```xml
<doc>
    <str name="uuid">http://purl.stanford.edu/qb767ss4042</str>
	
    <str name="dc_description_s">This polygon dataset shows pre-delimitation state Legislative Assembly constituency boundaries and
    data relating to the 2007 Assembly elections for the State of Uttar Pradesh, India. Map includes data for 403 constituencies.
    Includes attribute data on election parties, candidates, voters, and results. This layer is part of the Poll Map of India which
    includes parliamentary constituency boundaries for India, Assembly constituency boundaries for all states, and data relating to
    the past national elections for each State of India.; This data can be used for election analysis, forecasting, and mapping:
    Enables profiling of individual constituencies, permits historical analysis of the data, and helps predictive estimate of the
    impact of regional and state-wise electorate swings on the performance of political parties. These data are intended for
    researchers, students, and policy makers for reference and mapping purposes, and may be used for basic applications such as
    viewing, querying, and map output production.; </str>
    <str name="dc_format_s">Shapefile</str>
    <str name="dc_identifier_s">http://purl.stanford.edu/qb767ss4042</str>
    <str name="dc_language_s">English</str>
    <str name="dc_publisher_s">ML InfoMap (Firm)</str>
    <str name="dc_rights_s">Restricted</str>
    <arr name="dc_subject_sm">
      <str>Boundaries</str>
      <str>Elections</str>
      <str>Political Parties</str>
      <str>Politics and government</str>
      <str>Society</str>
      <str>Voting</str>
    </arr>
    <str name="dc_title_s">Uttar Pradesh, India: Pre Delimitation State Assembly Constituency Boundaries and Election Data, 2007</str>
    <str name="dc_type_s">Dataset</str>
	
    <arr name="dct_isPartOf_sm">
      <str>PollMap of India</str>
    </arr>
    <arr name="dct_references_sm">
      <str><xlink type="simple" role="urn:iso:dataFormat:ISO19139" href="http://purl.stanford.edu/qb767ss4042.iso19139"/></str>
      <str><xlink type="simple" role="urn:loc:dataFormat:MODS" href="http://purl.stanford.edu/qb767ss4042.mods"/></str>
      <str><xlink type="simple" role="urn:ogc:serviceType:WebFeatureService" href="http://geowebservices-restricted.stanford.edu/geoserver/wfs"/></str>
      <str><xlink type="simple" role="urn:ogc:serviceType:WebMapService" href="http://geowebservices-restricted.stanford.edu/geoserver/wms"/></str>
      <str><xlink type="simple" role="urn:x-osgeo:link:www" href="http://purl.stanford.edu/qb767ss4042"/></str>
      <str><xlink type="simple" role="urn:x-osgeo:link:www-thumbnail" href="https://stacks.stanford.edu/file/druid:qb767ss4042/preview.jpg"/></str>
    </arr>
    <arr name="dct_spatial_sm">
      <str>Agra</str>
      <str>Ghāziābād</str>
      <str>Khatauli</str>
      <str>Kushinagar</str>
      <str>Lucknow</str>
      <str>Meerut</str>
      <str>Muzaffarnagar</str>
      <str>Rāmpur</str>
      <str>Sahāranpur</str>
      <str>Uttar Pradesh</str>
      <str>Vārānasi</str>
    </arr>
    <arr name="dct_temporal_sm">
      <str>2007-01-01T00:00:00Z</str>
    </arr>
    <date name="dct_issued_dt">2000-01-01T00:00:00Z</date>
    <str name="dct_provenance_s">Stanford</str>
    
	<str name="georss_box_s"><georss:box>23.9 77.1 30.4 84.6</georss:box></str>
    <str name="georss_polygon_s"><georss:polygon>30.4 77.1 30.4 84.6 23.9 84.6 23.9 77.1 30.4 77.1</georss:polygon></str>
	
    <str name="layer_slug_s">stanford-qb767ss4042</str>
    <str name="layer_id_s">druid:qb767ss4042</str>
    <str name="layer_srs_s">EPSG:4326</str>
    <str name="layer_geom_type_s">Polygon</str>
	
    <str name="solr_bbox">77.1 23.9 84.6 30.4</str>
    <double name="solr_ne_pt_0_d">30.4</double>
    <double name="solr_ne_pt_1_d">84.6</double>
    <str name="solr_ne_pt">30.4,84.6</str>
    <double name="solr_sw_pt_0_d">23.9</double>
    <double name="solr_sw_pt_1_d">77.1</double>
    <str name="solr_sw_pt">23.9,77.1</str>
    <str name="solr_geom">POLYGON((77.1 30.4, 84.6 30.4, 84.6 23.9, 77.1 23.9, 77.1 30.4))</str>
    <long name="_version_">1464112144206266368</long>
    <date name="timestamp">2014-03-31T17:15:48.267Z</date>
    <float name="score">3.2848911</float>
</doc>
```

# Links

- Solr 4: http://wiki.apache.org/solr/SolrAdaptersForLuceneSpatial4
- Solr 3: http://wiki.apache.org/solr/SpatialSearch
- JTS: http://tsusiatsoftware.net/jts/main.html