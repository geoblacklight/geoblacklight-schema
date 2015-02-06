# Schema for dct_references in GeoBlacklight-Schema

The `dct_references_s` in GeoBlacklight-Schema contain an escaped JSON string of key value pairs. The key value pairs enable functionality in GeoBlacklight and are taken heavily from the [OGC-CatInterop](https://github.com/OSGeo/Cat-Interop) project.

A GeoBlacklight-Schema example for `dct_references_s`:

  ```xml
<field name="dct_references_s">
    {
        "http://schema.org/url":"http://purl.stanford.edu/bb509gh7292",
        "http://schema.org/downloadUrl":"http://stacks.stanford.edu/file/druid:bb509gh7292/data.zip",
        "http://www.loc.gov/mods/v3":"http://purl.stanford.edu/bb509gh7292.mods",
        "http://www.isotc211.org/schemas/2005/gmd/":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/iso19139.xml",
        "http://www.w3.org/1999/xhtml":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/default.html",
        "http://www.opengis.net/def/serviceType/ogc/wfs":"https://geowebservices-restricted.stanford.edu/geoserver/wfs",
        "http://www.opengis.net/def/serviceType/ogc/wms":"https://geowebservices-restricted.stanford.edu/geoserver/wms"
    }
</field>

  ```
## Table of reference keys

Reference Type | Reference URI (key) | Feature enabled in GeoBlacklight
---- | ------------- | ------------------------
Web Mapping Service (WMS) | http://www.opengis.net/def/serviceType/ogc/wms | Layer preview, layer preview feature inspection, downloads (vector: KMZ, raster: GeoTIFF)
Web Feature Service (WFS) | http://www.opengis.net/def/serviceType/ogc/wfs | Vector downloads in GeoJSON and Shapefile
International Image Interoperability Framework (IIIF) Image API | http://iiif.io/api/image | Image viewer using [Leaflet-IIIF](https://github.com/mejackreed/Leaflet-IIIF)
Direct download file | http://schema.org/downloadUrl | Direct file download feature
Full layer description | http://schema.org/url | Further descriptive information about layer
Metadata in ISO 19139 | http://www.isotc211.org/schemas/2005/gmd/ | Structured metadata in ISO format
Metadata in MODS | http://www.loc.gov/mods/v3 | Structured metadata in MODS format
Metadata in HTML | http://www.w3.org/1999/xhtml | Structured metadata in HTML format
