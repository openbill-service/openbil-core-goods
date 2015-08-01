#!/usr/bin/env bash

. ./tests/init.sh
. ./tests/2accounts.sh

./tests/assert_error.sh "insert into transactions (amount, amount_currency, from_account_id, to_account_id, order_uri, details) values (100, 'USA', 1, 2, 'gid://order1', 'test');" "ERROR:  Account (from #1) has wrong currency or account is disabled"

./tests/assert.sh 'select count(*) from transactions' '0' && \
./tests/assert.sh 'select amount from accounts where id=1' '0' && \
./tests/assert.sh 'select amount from accounts where id=2' '0'
