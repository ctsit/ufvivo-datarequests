#!/bin/bash

# Runs the query in query.rq against Virtuoso and gets the results back as JSON

ENDPOINT=http://sparql.vivo.ufl.edu/virtuoso/
JSON=application/sparql-results+json

curl $ENDPOINT                      \
    -H "Accept: $JSON"              \
    --compressed                    \
    --data-urlencode "email="       \
    --data-urlencode "password="    \
    --data-urlencode query@query.rq
