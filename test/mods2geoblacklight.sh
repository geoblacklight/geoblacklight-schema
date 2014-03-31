export PATH=../bin:$PATH
test -d mods || mkdir mods
set -x
for fn in mods/*.xml; do
  if [ ! -r geoblacklight/`basename $fn` ]; then
    xsltproc -stringparam geoserver_root 'http://kurma-podd1.stanford.edu/geoserver' \
		  -stringparam purl 'http://purl.stanford.edu/aa111bb2222' \
			../lib/xslt/mods2geoblacklight.xsl $fn > geoblacklight/`basename $fn`
  fi
done
