test -z "$PGDATABASE" && export PGDATABASE='openbill_test'
psql --no-align -q -t -L ./logs/tests.log
