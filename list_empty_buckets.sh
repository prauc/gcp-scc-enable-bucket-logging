#!/bin/bash
read -p "GCP Project ID: " GCP_PROJECT

while read -r bucket
do
    gsutil ls "$bucket*" > /dev/null 2>&1
    items=$?

    if [[ $items == 1 ]]; then
        echo $bucket
    fi
done < <(gsutil ls -p $GCP_PROJECT)