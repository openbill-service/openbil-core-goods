#!/usr/bin/env bash

test -z "$PGDATABASE" && PGDATABASE='openbill_tests'

LOGS_DIR='./log/'; test -d $LOGS_DIR || mkdir $LOGS_DIR

LOGFILE="$LOGS_DIR/create.log"

message="Recreate database ${PGDATABASE}"

echo $message
echo $message > $LOGFILE

dropdb --if-exists $PGDATABASE >> $LOGFILE && \
  createdb $PGDATABASE >> $LOGFILE && \
  psql $PGDATABASE < ./sql/0_db.sql >> $LOGFILE && \
  cat ./sql/?_trigger*.sql | psql $PGDATABASE >> $LOGFILE
