## <a name="resource-dc_creator_sm">dc_creator_sm</a>


Author(s).


## <a name="resource-dc_description_s">dc_description_s</a>


Description for the layer.


## <a name="resource-dc_format_s">dc_format_s</a>


File format for the layer, using a controlled vocabulary.


## <a name="resource-dc_identifier_s">dc_identifier_s</a>


Unique identifier for layer. May be same as UUID but may be an alternate identifier.


## <a name="resource-dc_language_s">dc_language_s</a>


Language for the layer. Example: English.


## <a name="resource-dc_publisher_s">dc_publisher_s</a>


Publisher. Example: ML InfoMap.


## <a name="resource-dc_rights_s">dc_rights_s</a>


Access rights for the layer.


## <a name="resource-dc_subject_sm">dc_subject_sm</a>


Subjects, preferrably in a controlled vocabulary. Examples: Census, Human settlements.


## <a name="resource-dc_title_s">dc_title_s</a>


Title for the layer.


## <a name="resource-dc_type_s">dc_type_s</a>


Resource type, using DCMI Type Vocabulary.


## <a name="resource-dct_isPartOf_sm">dct_isPartOf_sm</a>


Holding dataset for the layer, such as the name of a collection. Example: Village Maps of India.


## <a name="resource-dct_issued_dt">dct_issued_dt</a>


Issued date for the layer, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ).


## <a name="resource-dct_provenance_s">dct_provenance_s</a>


Institution who holds the layer.


## <a name="resource-dct_references_s">dct_references_s</a>


JSON hash for external resources, where each key is a URI for the protocol or format and the value is the URL to the resource.


## <a name="resource-dct_spatial_sm">dct_spatial_sm</a>


Spatial coverage and place names, preferrably in a controlled vocabulary. Example: 'Paris, France'.


## <a name="resource-dct_temporal_sm">dct_temporal_sm</a>


Temporal coverage, typically years or dates. Example: 1989, circa 2010, 2007-2009. Note that this field is not in a specific date format.


## <a name="resource-georss_box_s">georss_box_s</a>


Bounding box as maximum values for S W N E.


## <a name="resource-georss_point_s">georss_point_s</a>


Point representation for layer as y, x - i.e., centroid. Example: 12.6 -119.4.


## <a name="resource-layer_geom_type_s">layer_geom_type_s</a>


Geometry type for layer data, using controlled vocabulary.


## <a name="resource-layer_id_s">layer_id_s</a>


The complete identifier for the layer via WMS/WFS/WCS protocol


## <a name="resource-layer_modified_dt">layer_modified_dt</a>


Last modification date for the metadata record, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ).


## <a name="resource-layer_slug_s">layer_slug_s</a>


Unique identifier visible to the user, used for Permalinks


## <a name="resource-solr_geom">solr_geom</a>


Derived from georss_polygon_s or georss_box_s. Shape of the layer as a ENVELOPE WKT using W E N S. Note that this field is indexed as a Solr spatial (RPT) field.


## <a name="resource-solr_year_i">solr_year_i</a>


Derived from dct_temporal_sm. Year for which layer is valid and only a single value. Note that this field is indexed as a Solr numeric field.


## <a name="resource-uuid">uuid</a>


Unique identifier for layer that is globally unique.


