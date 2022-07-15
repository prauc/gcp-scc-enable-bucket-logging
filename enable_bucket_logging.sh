#!/bin/bash
read -p "GCP Project ID: " GCP_PROJECT
read -p "Logs Bucket Name: " GCP_LOGS_BUCKET_NAME

GCP_LOGS_BUCKET="gs://$GCP_PROJECT-$GCP_LOGS_BUCKET_NAME/"
gsutil ls -p $GCP_PROJECT $GCP_LOGS_BUCKET
status=$?

if [[ $status == 1 ]]; then
    #Logs Bucket does not exists; creating..
    gsutil mb $GCP_LOGS_BUCKET
    gsutil iam ch group:cloud-storage-analytics@google.com:legacyBucketWriter $GCP_LOGS_BUCKET
else
    echo "Logs Bucket already exists, moving on.."
fi

while read -r bucket
do
    if [[ $bucket == $GCP_LOGS_BUCKET ]]; then
        echo "skipping logs-bucket"
        break
    fi

    gsutil logging set on -b $GCP_LOGS_BUCKET $bucket
done < <(gsutil ls -p $GCP_PROJECT)