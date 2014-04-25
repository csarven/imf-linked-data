#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./imf.config.sh

rm "$data""$agency".observations.meta.nt
ls -1S "$data"import/*.nt | grep -Ev "Structure|prov|meta" | while read i ; do file=$(basename "$i"); DataSetCode=${file%.*}; echo "<$namespace""dataset/$DataSetCode> <http://www.w3.org/2000/01/rdf-schema#seeAlso> <$namespace""data/$agency.observations.ttl> ." >> "$data""$agency".observations.meta.nt ; done
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data""$agency".observations.meta.nt
