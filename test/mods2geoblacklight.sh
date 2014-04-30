export PATH=../bin:$PATH
test -d geoblacklight || mkdir geoblacklight
set -x
find mods -name 'stanford*.xml' -print | while read fn; do
  ofn="geoblacklight/`basename $fn`"
  if [ ! -r "$ofn" ]; then
    xsltproc \
      -stringparam geoserver_root 'http://kurma-podd1.stanford.edu/geoserver' \
      -stringparam now `date -u "+%Y-%m-%dT%H:%M:00Z"` \
			../lib/xslt/mods2geoblacklight.xsl "$fn" > "$ofn"
    # -stringparam purl 'http://purl.stanford.edu/aa111bb2222' \
  fi
done
