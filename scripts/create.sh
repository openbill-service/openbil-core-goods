#!/usr/bin/env bash

test -z "$PGDATABASE" && PGDATABASE='openbill'

LOGS_DIR='./logs/'; test -d $LOGS_DIR || mkdir $LOGS_DIR

LOGFILE="$LOGS_DIR/create.log"

message="Recreate database ${PGDATABASE}"

echo $message
echo $message > $LOGFILE

dropdb --if-exists $PGDATABASE >> $LOGFILE && \
  createdb $PGDATABASE >> $LOGFILE && \
  psql $PGDATABASE < ./sql/db.sql >> $LOGFILE && \
  cat ./sql/trigger*.sql | psql $PGDATABASE >> $LOGFILE
