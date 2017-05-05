#!/bin/bash
#
# Script for checking webserver SSL rating by Qualys SSL Labs
# Script is using domain list file (one domain per line) to ask sslabs API, return a rating in ABC, converts to number for exposing to Prometheus as a grade
SSL_BIN=/sslcheck/ssllabs-scan
EXPORTER_PATH="/var/lib/nginx/html/metrics/index.html"
EXPORTER_TMP_PATH="/var/lib/nginx/html/metrics/index.html.tmp"
DOMAINS_FILE="/sslcheck/domains.txt"

declare -A grades
grades=( ["A+"]=100 ["A"]=90 ["A-"]=80 ["B"]=70 ["C"]=60 ["D"]=50 ["E"]=40 ["F"]=30 ["M"]=20 ["T"]=10 )

while true
do
  rm -f $EXPORTER_TMP_PATH
  while IFS=: read host team;
  do
    RESULT=`${SSL_BIN} -grade $host | awk '{gsub (/"/, "", $2); print $2}'`
# Check if output is a valid value from the array. If none assign a metric with 1.
    if [[ -n "${grades[$RESULT]}" ]]; then
      echo "web_ssllabs_grade{hostname=\"$host\",team=\"$team\"} ${grades[$RESULT]}" >> $EXPORTER_TMP_PATH
    else
      echo "web_ssllabs_grade{hostname=\"$host\",team=\"$team\"} 1" >> $EXPORTER_TMP_PATH
    fi
  done <$DOMAINS_FILE
  cp -a $EXPORTER_TMP_PATH $EXPORTER_PATH
  echo 'Sleeping for 6 hours'
  sleep 21600
done
