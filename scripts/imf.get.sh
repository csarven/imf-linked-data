#!/bin/bash

. ./imf.config.sh

imfNamespace="http://sdmxws.imf.org/RestSDMX2/sdmx.ashx/";

rm "$data""$agency".prov.retrieval.rdf

echo '<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:sdmx="http://purl.org/linked-data/sdmx#">' > "$data""$agency".prov.retrieval.rdf ;

echo "Building a list of DataSetCodes";
xpath -q -e "/message:Structure/message:KeyFamilies/KeyFamily/@id" "$data"../scripts/DatasetList.xml | perl -pe 's/(.*)(?=id=\")id=\"(.*)(?=\")(.*)/$2/' | sort -u > "$data"../scripts/"$agency".data.txt


while read DataSetCode ; do
sleep 0.1
    dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
    dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

    downloadURL="$imfNamespace""GetKeyFamily/""$DataSetCode""/IMF/?resolveRef=true" ;

    echo "$DataSetCode" ;

#    wget -c -t 1 --timeout 300 --no-http-keep-alive "$downloadURL" -O "$data""$DataSetCode".Structure.xml;

sleep 1
    dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
    dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

    echo '
    <rdf:Description rdf:about="http://imf.270a.info/provenance/activity/'$dtstartd'">
        <rdf:type rdf:resource="http://www.w3.org/ns/prov#Activity"/>
        <prov:startedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtstart'</prov:startedAtTime>
        <prov:endedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtend'</prov:endedAtTime>
        <prov:wasAssociatedWith rdf:resource="http://csarven.ca/#i"/>
        <prov:used rdf:resource="https://launchpad.net/ubuntu/+source/wget"/>
        <prov:used rdf:resource="'$downloadURL'"/>
        <prov:generated>
            <rdf:Description rdf:about="http://imf.270a.info/data/'$DataSetCode'.Structure.xml">
                <dcterms:identifier>'$DataSetCode'</dcterms:identifier>
            </rdf:Description>
        </prov:generated>
        <rdfs:label xml:lang="en">Retrieved '$DataSetCode'</rdfs:label>
        <rdfs:comment xml:lang="en">'$DataSetCode' retrieved from source and saved to local filesystem.</rdfs:comment>
    </rdf:Description>' >> "$data""$agency".prov.retrieval.rdf ;

done < "$data"../scripts/"$agency".data.txt


for i in "$data"*Structure.xml ; do xmllint --format "$i" > temp.xml && mv temp.xml "$i" ; done ;

while read DataSetCode ; do     echo "Copying $DataSetCode REF_AREAs";     xpath -q -e "/message:Structure/message:CodeLists/CodeList[@id = 'CL_AREA']/Code[@parentCode = 'COU']/@value" "$data""$DataSetCode".Structure.xml | perl -pe 's/(.*)(?=value=\")value=\"(.*)(?=\")(.*)/$2/' | sort -u > "$data""$DataSetCode".CL_AREA.txt ; done < "$data"../scripts/"$agency".data.txt ;


while read DataSetCode ; do
    while read j ; do
sleep 0.1
        dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
        dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

        downloadURL="$imfNamespace""GetData?dataflow=""$DataSetCode""&key=""$j""&format=generic_v2" ;

        title=$(xpath -q -e "/message:Structure/message:KeyFamilies/KeyFamily/Name/text()" "$data""$DataSetCode".Structure.xml) ;

        echo "$DataSetCode $j - $title" ;

#        wget -c -t 1 --timeout 300 --no-http-keep-alive "$downloadURL" -O "$data""$DataSetCode"".$j".xml ;

sleep 1
        dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
        dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

        downloadURL="$imfNamespace""GetData?dataflow=""$DataSetCode""&amp;key=""$j""&amp;format=generic_v2" ;

        echo '
        <rdf:Description rdf:about="http://imf.270a.info/provenance/activity/'$dtstartd'">
            <rdf:type rdf:resource="http://www.w3.org/ns/prov#Activity"/>
            <prov:startedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtstart'</prov:startedAtTime>
            <prov:endedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtend'</prov:endedAtTime>
            <prov:wasAssociatedWith rdf:resource="http://csarven.ca/#i"/>
            <prov:used rdf:resource="https://launchpad.net/ubuntu/+source/wget"/>
            <prov:used rdf:resource="'$downloadURL'"/>
            <prov:generated>
                <rdf:Description rdf:about="http://imf.270a.info/data/'$DataSetCode'.'$j'.xml">
                    <dcterms:identifier>'$DataSetCode'</dcterms:identifier>
                    <dcterms:title xml:lang="en">'$title'</dcterms:title>
                </rdf:Description>
            </prov:generated>
            <rdfs:label xml:lang="en">Retrieved '$DataSetCode'</rdfs:label>
            <rdfs:comment xml:lang="en">'$DataSetCode' retrieved from source and saved to local filesystem.</rdfs:comment>
        </rdf:Description>' >> "$data""$agency".prov.retrieval.rdf ;
    done < "$data""$DataSetCode".CL_AREA.txt ;
done < "$data"../scripts/"$agency".data.txt

echo -e "\n</rdf:RDF>" >> "$data""$agency".prov.retrieval.rdf ;

#real    53m4.538s
#user    0m23.272s
#sys     0m5.832s
