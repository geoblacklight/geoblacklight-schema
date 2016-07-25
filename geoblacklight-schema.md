## <a name="resource-layer">layer</a>


A GIS data layer. See [this example](https://github.com/OpenGeoMetadata/edu.stanford.purl/blob/master/bb/099/zb/1450/geoblacklight.json) metadata layer.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **dc_creator_sm** | *array* | Author(s). *OPTIONAL* | `"George Washington, Thomas Jefferson"` |
| **dc_description_s** | *string* | Description for the layer. | `"My Description"` |
| **dc_format_s** | *string* | File format for the layer, using a controlled vocabulary. *OPTIONAL*<br/> **one of:**`"Shapefile"` or `"GeoTIFF"` or `"ArcGRID"` | `"Shapefile"` |
| **dc_identifier_s** | *string* | *DEPRECATED* (use `layer_slug_s`): Unique identifier for layer. May be same as UUID but may be an alternate identifier. | `"stanford-vr593vj7147"` |
| **dc_language_s** | *string* | Language for the layer. *OPTIONAL* | `"English"` |
| **dc_publisher_s** | *string* | Publisher. *OPTIONAL* | `"ML InfoMap"` |
| **dc_rights_s** | *string* | Access rights for the layer.<br/> **one of:**`"Public"` or `"Restricted"` | `"Public"` |
| **dc_subject_sm** | *array* | Subjects, preferrably in a controlled vocabulary. *OPTIONAL* | `"Census, Human settlements"` |
| **dc_title_s** | *string* | Title for the layer. | `"My Title"` |
| **dc_type_s** | *string* | Resource type, using DCMI Type Vocabulary. *OPTIONAL*<br/> **one of:**`"Dataset"` or `"Image"` or `"PhysicalObject"` | `"Dataset"` |
| **dct_isPartOf_sm** | *array* | Holding dataset for the layer, such as the name of a collection. *OPTIONAL* | `"Village Maps of India"` |
| **dct_issued_dt** | *date-time* | Issued date for the layer, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ). *OPTIONAL* | `"2015-01-01T12:00:00Z"` |
| **dct_provenance_s** | *string* | Institution who holds the layer. | `"Stanford"` |
| **dct_references_s** | *string* | JSON hash for external resources, where each key is a URI for the protocol or format and the value is the URL to the resource. See `dct_references_s` [detailed documentation](http://geoblacklight.org/tutorial/2015/02/09/geoblacklight-overview.html) | `"{ ... }"` |
| **dct_spatial_sm** | *array* | Spatial coverage and place names, preferrably in a controlled vocabulary. *OPTIONAL* | `"Paris, San Francisco"` |
| **dct_temporal_sm** | *array* | Temporal coverage, typically years or dates. Note that this field is not in a specific date format. *OPTIONAL* | `"1989, circa 2010, 2007-2009"` |
| **georss_box_s** | *string* | Bounding box as maximum values for S W N E. | `"12.6 -119.4 19.9 84.8"` |
| **georss_point_s** | *string* | *DEPRECATED* (use `georss_box_s`): Point representation for layer as y, x - i.e., centroid | `"12.6 -119.4"` |
| **layer_geom_type_s** | *string* | Geometry type for layer data, using controlled vocabulary.<br/> **one of:**`"Point"` or `"Line"` or `"Polygon"` or `"Raster"` or `"Scanned Map"` or `"Mixed"` | `"Point"` |
| **layer_id_s** | *string* | The complete identifier for the layer via WMS/WFS/WCS protocol. | `"druid:vr593vj7147"` |
| **layer_modified_dt** | *date-time* | Last modification date for the metadata record, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ). | `"2015-01-01T12:00:00Z"` |
| **layer_slug_s** | *string* | Unique identifier visible to the user, used for Permalinks. | `"stanford-vr593vj7147"` |
| **solr_geom** | *string* | *Derived from* `georss_box_s`. Shape of the layer as a ENVELOPE WKT using W E N S. Note that this field is indexed as a Solr spatial (RPT) field.<br/> **pattern:** `ENVELOPE(.*,.*,.*,.*)` | `"ENVELOPE(76.76, 84.76, 19.91, 12.62)"` |
| **solr_year_i** | *integer* | *Derived from* `dct_temporal_sm`. Year for which layer is valid and only a single value. Note that this field is indexed as a Solr numeric field. | `"1989"` |
| **uuid** | *string* | *DEPRECATED* (use `layer_slug_s`): Unique identifier for layer that is globally unique. | `"stanford-vr593vj7147"` |


