# Schema for dct_references in GeoBlacklight-Schema

The `dct_references_s` in GeoBlacklight-Schema contain an escaped JSON string of key value pairs. The key value pairs enable functionality in GeoBlacklight and are taken heavily from the [OGC-CatInterop](https://github.com/OSGeo/Cat-Interop) project.

A GeoBlacklight-Schema example for `dct_references_s`:

  ```js
{
  // A URL to access further descriptive information 
  "http://schema.org/url":"http://purl.stanford.edu/bb509gh7292",
  // A direct file download
  "http://schema.org/downloadUrl":"http://stacks.stanford.edu/file/druid:bb509gh7292/data.zip",
  // A MODS metadata document
  "http://www.loc.gov/mods/v3":"http://purl.stanford.edu/bb509gh7292.mods",
  // An ISO19139 metadata document
  "http://www.isotc211.org/schemas/2005/gmd/":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/iso19139.xml",
  // An HTML metadata document
  "http://www.w3.org/1999/xhtml":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/default.html",
  // A WFS Service
  "http://www.opengis.net/def/serviceType/ogc/wfs":"https://geowebservices-restricted.stanford.edu/geoserver/wfs",
  // A WMS Service
  "http://www.opengis.net/def/serviceType/ogc/wms":"https://geowebservices-restricted.stanford.edu/geoserver/wms"
}
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
ArcGIS FeatureLayer | urn:x-esri:serviceType:ArcGIS#FeatureLayer| Previewing of ArcGIS FeatureLayer Service
ArcGIS TiledMapLayer | urn:x-esri:serviceType:ArcGIS#TiledMapLayer | Previewing of ArcGIS TiledMapLayer Service
ArcGIS DynamicMapLayer | urn:x-esri:serviceType:ArcGIS#DynamicMapLayer | Previewing of ArcGIS DynamicMapLayer Service
ArcGIS ImageMapLayer | urn:x-esri:serviceType:ArcGIS#ImageMapLayer | Previewing of ArcGIS ImageMapLayer Service
