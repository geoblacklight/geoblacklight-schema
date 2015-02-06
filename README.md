#### Introduction

This schema focuses on discovery use cases for patrons and analysts in a
research library setting, although it is likely useful in other settings. Text
search, faceted search and refinement, and spatial search and relevancy are
among the primary features that the schema enables. The schema design supports
a variety of discovery applications and GIS data types. We especially wanted to
provide for contextual collection-oriented discovery applications as well as
traditional portal applications.

The source code for the Solr implementation and the design document are on
Github:

  http://github.com/geoblacklight/geoblacklight-schema

The conf/ folder has everything you need to implement the schema in Solr 4.7,
and the examples/ folder has 100 example Solr documents that you can use. The
lib/ folder has some initial, but incomplete, implementations for metadata
format conversions (e.g., FGDC -> MODS, OGP -> GeoBlacklight, etc.).

#### Example

The `examples` folder has some Solr documents that uses this schema. First,
install the schema into a Solr 4 instance, then upload documents using
`tools/solr/upload.rb`.

#### Documentation

[Preview GeoBlacklight-Schema](docs/geoblacklight-schema.markdown)

`dct_references_s` [features and functionality](docs/dct_references_schema.markdown)

## Requirements

* Saxon-HE v9, the Home Edition from http://saxon.sourceforge.net installed as
  `vendor/saxon9he.jar`

#  Schema for GeoBlacklight

Please refer to http://journal.code4lib.org/articles/9710 which describes the schema in detail.

* Hardy, D., K. Durante. 2014. A Metadata Schema for Geospatial Resource Discovery Use Cases. _code4lib_ 25. 

Abstract: We introduce a metadata schema that focuses on GIS discovery use cases for patrons in a research library setting. Text search, faceted refinement, and spatial search and relevancy are among GeoBlacklight’s primary use cases for federated geospatial holdings. The schema supports a variety of GIS data types and enables contextual, collection-oriented discovery applications as well as traditional portal applications. One key limitation of GIS resource discovery is the general lack of normative metadata practices, which has led to a proliferation of metadata schemas and duplicate records. The ISO 19115/19139 and FGDC standards specify metadata formats, but are intricate, lengthy, and not focused on discovery. Moreover, they require sophisticated authoring environments and cataloging expertise. Geographic metadata standards target preservation and quality measure use cases, but they do not provide for simple inter-institutional sharing of metadata for discovery use cases. To this end, our schema reuses elements from Dublin Core and GeoRSS to leverage their normative semantics, community best practices, open-source software implementations, and extensive examples already deployed in discovery contexts such as web search and mapping. Finally, we discuss a Solr implementation of the schema using a “geo” extension to MODS.


