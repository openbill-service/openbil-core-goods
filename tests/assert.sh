#!/usr/bin/env sh

query="$1"
value="$2"

echo -n "Execute '$query' has error '$value': "
RES=`echo "$query" | ./tests/sql.sh`

if [ $? = 0 ]; then
  if [ "$RES" = "$value" ]; then
    echo 'ok'
  else
    echo "FAIL! No error $RES <> $2"
    exit 1
  fi
else
  echo "Error executing $query"
  exit $?
fi
