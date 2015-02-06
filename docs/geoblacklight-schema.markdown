# GeoBlacklight-Schema

Table View

Properties | Type | Controlled Values | Description
---------- | ---- | ------------ |-----------
uuid | string || Unique identifier for layer that is globally unique.
dc_identifier_s | string || Unique identifier for layer. May be same as UUID but may be an alternate identifier.
c_title_s | string || Title for the layer.
dc_description_s | string || Description for the layer.
dc_rights_s | string | "Public", "Restricted" | Access rights for the layer. Must be Public or Restricted.
dct_provenance_s | string || Institution who holds the layer.
dct_references_s | string || JSON hash for external resources, where each key is a URI for the protocol or format and the value is the URL to the resource.
georss_box_s | string || Bounding box as maximum values for S W N E. Example: 12.6 -119.4 19.9 84.8.
layer_id_s | string || The complete identifier for the layer via WMS/WFS/WCS protocol. Example: druid:vr593vj7147.
layer_geom_type_s | string | "Point", "Line", "Polygon", "Raster", "Scanned Map", "Paper Map", "Mixed" | Geometry type for layer data.
layer_modified_dt | string || Last modification date for the metadata record in the Solr date/time format. Example: 2014-04-30T13:48:51Z. Note that this field is indexed as a Solr date-time field.
layer_slug_s | string || Unique identifier visible to the user, used for Permalinks. Example: stanford-vr593vj7147.
solr_bbox | string || Derived from georss_box_s. Bounding box as maximum values for W S E N. Example: 76.76 12.62 84.76 19.91. Note that this field is indexed as a Solr spatial field.
solr_geom | string || Derived from georss_polygon_s or georss_box_s. Shape of the layer as a ENVELOPE WKT using W E N S. Example: ENVELOPE(76.76, 84.76, 19.91, 12.62). Note that this field is indexed as a Solr spatial field.
solr_year_i | integer || Derived from dct_temporal_sm. Year for which layer is valid and only a single value. Example: 1989. Note that this field is indexed as a Solr numeric field.
dc_creator_sm | multivalued string || Author(s). Example: George Washington, Thomas Jefferson.
dc_format_s | string || File format for the layer. Examples: Shapefile, GeoTIFF, ArcGRID.
dc_language_s | string || Language for the layer. Example: English.
dc_publisher_s | string || Publisher. Example: ML InfoMap.
dc_subject_sm | multivalued string || Subjects, preferrably in a controlled vocabulary. Examples: Census, Human settlements.
dc_type_s | string | "Dataset", "Image", "PhysicalObject" | Resource type.
dct_spatial_sm | multivalued string || Spatial coverage and place names. Example: Paris, France.
dct_temporal_sm | string || Temporal coverage, typically years or dates. Example: 1989, 2010.
dct_issued_dt | string || Issued date for the layer.
dct_isPartOf_sm | multivalued string || Holding dataset for the layer, such as the name of a collection. Example: Village Maps of India.
georss_point_s | string || Point representation for layer as y, x - i.e., centroid. Example: 12.6 -119.4.