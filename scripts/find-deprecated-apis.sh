#!/bin/bash

if [ $# -eq 0 ];then
	echo "Usage: $(basename $0) deprecated-apis.txt"
	exit 1
elif [ ! -f "$1" ];then
	echo "ERROR: unable to access $1"
	exit 1
fi

APIFILE="$1"
for api in $(awk '{ver=gensub(/(.+)\/(.+)/, "\\2.\\1", "g", $2);print $1"."ver}' ${APIFILE});do
	echo "=== ${api} ==="
	oc get apirequestcounts ${api} \
  		-o jsonpath='{range .status.last24h..byUser[*]}{..byVerb[*].verb}{","}{.username}{","}{.userAgent}{"\n"}{end}' \
  		| sort -k 2 -t, -u | column -t -s, -NVERBS,USERNAME,USERAGENT
done
