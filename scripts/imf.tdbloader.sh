#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./imf.config.sh

echo "Removing $db";
rm -rf "$db";

ls -1S "$data"import/*.nt | grep -Ev "Structure|prov" | while read i ; do file=$(basename "$i"); DataSetCode=${file%.*}; java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/"$DataSetCode" "$i"; done ;

for i in "$data"import/*.Structure.nt ; do java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$i" ; done

#java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.prov.archive.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.prov.retrieval.rdf


java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.exactMatch.worldbank.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.exactMatch.transparency.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.exactMatch.dbpedia.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.exactMatch.bfs.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.exactMatch.fao.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.exactMatch.ecb.nt
#java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"imf.property.meta.nt

./imf.tdbstats.sh
#real    22m16.591s
#user    18m12.588s
#sys     0m37.668s
