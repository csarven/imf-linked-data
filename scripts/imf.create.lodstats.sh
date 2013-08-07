#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. $HOME/lodstats-env/bin/activate

. ./imf.config.sh

#mkdir -p "$data"import
#rm "$data"import/*stats*

echo "Creating LODStats for Datasets"
find "$data"import/*.nt -not -name "*Structure*" -not -name "*imf\.*" -not -name "meta.nt" | while read i ; do lodstats -val "$i" > "$i".stats.ttl ; echo "Created $i.stats.ttl" ; done;

echo Exporting "$namespace"graph/meta ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=n-triples 'CONSTRUCT { ?s ?p ?o } WHERE { GRAPH <'"$namespace"'graph/meta> { ?s ?p ?o } }' > "$data"import/meta.nt ;

rapper -i turtle "$data"import/meta.nt > "$data"import/meta.2.nt ;
mv "$data"import/meta.2.nt "$data"import/meta.nt ;

echo Creating LODStats "$data"import/meta.nt.stats.ttl ;
lodstats -vl "$data"import/meta.nt > "$data"import/meta.nt.stats.ttl ;

echo "Fixing URI for meta stats" ;
find "$data"import/*stats.ttl -name "*[!Structure|imf.]" | while read i ; do sed -ri 's/<file:\/\/\/data\/'"$agency"'-linked-data\/data'"$state"'\/import\/([^\.]*)\.nt/<http:\/\/'"$agency"'.270a.info\/dataset\/\1/g' "$i" ; done ;


