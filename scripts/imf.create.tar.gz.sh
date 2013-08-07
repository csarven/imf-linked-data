#!/bin/bash

. ./imf.config.sh

cd "$data"
tar -cvzf meta.tar.gz *Structure.rdf imf.*rdf

tar -cvzf data.tar.gz *.rdf --exclude='*Structure*' --exclude='imf.*'

