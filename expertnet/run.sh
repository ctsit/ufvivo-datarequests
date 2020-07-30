#!/bin/bash

USAGE=$(cat <<EOT
Usage: $0

Queries UF VIVO using the SPARQL queries found in all .rq files in the current
working directory. Then, the resulting JSON files are archived and compressed
into a single ZIP file.

Note: if you are using Bash, you can also source this file which exposes the
QueryVIVO function that can be used to query VIVO using a single SPARQL file.

   $ source run.sh
   $ QueryVIVO myquery.rq >myquery.json

Copyright 2020 University of Florida
Written by Taeber Rapczak <taeber@ufl.edu>
EOT
)

ENDPOINT=http://sparql.vivo.ufl.edu/virtuoso/
JSON=application/sparql-results+json

QueryVIVO()
{
    FILE=$1
    curl $ENDPOINT                     \
        -H "Accept: $JSON"             \
        --compressed                   \
        --data-urlencode 'email='      \
        --data-urlencode 'password='   \
        --data-urlencode "query@$FILE"
}

# Run the following if script isn't being sourced.
return 0 2>/dev/null || {

    if [[ "$1" != "" ]]
    then
        echo "$USAGE"
        exit
    fi

    TODAY=$(date +'%Y%m%d')
    RESULTS=results-$TODAY.zip
    rm -f $RESULTS

    for each in $(ls *.rq)
    do
        echo Querying VIVO using "$each"...
        QueryVIVO $each >${each%.rq}.json
    done

    zip $RESULTS *-$TODAY.json

}

