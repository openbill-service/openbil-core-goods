#!/usr/bin/env sh

query="$1"
value="$2"

echo -n "Execute '$query' is equal to '$value': "
RES=`echo "$query" | psql --no-align -t -q`

if [ $? = 0 ]; then
  if [ "$RES" = "$value" ]; then
    echo 'ok'
  else
    echo "FAIL! Not equal $RES <> $2"
    exit 1
  fi
else
  echo "Error executing $query"
  exit $?
fi
