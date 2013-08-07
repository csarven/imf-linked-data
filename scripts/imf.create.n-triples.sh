#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./imf.config.sh

mkdir -p "$data"import ;
rm "$data"import/*.nt ;

ls -1 "$data"*.rdf | grep -E "Structure|prov" | while read i ; do file=$(basename "$i"); dataSetCode=${file%.*}; rapper -g "$i" > "$data"import/"$dataSetCode".nt ; done

#This is fugly!
while read j ; do find "$data" -name "$j*[!Structure|prov].rdf" | while read i ; do file=$(basename "$i"); dataSetCode=${file%.*}; rapper -g "$i" >> "$data"import/"$j".nt ; done ; done < "$data"../scripts/"$agency".data.txt

#real    6m20.731s
#user    6m5.380s
#sys     0m10.064s
