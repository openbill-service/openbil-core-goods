#!/usr/bin/env sh

. ./tests/init.sh
. ./tests/2accounts.sh

echo "insert into transactions (amount, amount_currency, from_account_id, to_account_id, order_uri, details) values (100, 'USD', 1, 2, 'gid://order1', 'test');" | ./tests/sql.sh

./tests/assert.sh 'select amount from accounts where id=1' '-100' && \
./tests/assert.sh 'select amount from accounts where id=2' '100' && \
./tests/assert.sh 'select count(*) from transactions' '1'
