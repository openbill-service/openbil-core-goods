#!/usr/bin/env sh

query="$1"
value="$2"

echo -n "\tExecute '$query' has an result '$value': "
RES=`echo "$query" | psql --no-align -t 2>&1`

if [ $? = 0 ]; then
  if [ "$RES" = "$value" ]; then
    echo 'ok'
  else
    echo "FAIL! No result $RES <> $2"
    exit 1
  fi
else
  echo "Error executing $query"
  exit $?
fi
