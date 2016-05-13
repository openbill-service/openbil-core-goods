#!/usr/bin/env sh

query="$1"
value="$2"

echo -n "\tExecute '$query' is equal to '$value': "
RES=`echo "$query" | psql --no-align -t -q`

if [ $? = 0 ]; then
  if [ "$RES" = "$value" ]; then
    echo 'ok'
  else
    echo "FAIL! Not equal '$RES' <> '$value'"
    exit 1
  fi
else
  echo "Error executing $query"
  exit $?
fi
