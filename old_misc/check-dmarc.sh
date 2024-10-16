#!/usr/bin/env bash

unset domain
domain=$1

echo "checking reports for $domain"

if ! [[ $domain ]]; then
  echo "please supply a domain"
  exit 1
fi

apitoken=$(pass personal/admin/postmark-api/$domain)

reports=$(curl -s -X GET -H "Accept: application/json" -H "X-Api-Token: $apitoken" https://dmarc.postmarkapp.com/records/my/reports |jq .entries[].id)

for r in $reports ; do 
  curl -s -X GET -H "Accept: application/json" -H "X-Api-Token: $apitoken" https://dmarc.postmarkapp.com/records/my/reports/$r | jq
done
