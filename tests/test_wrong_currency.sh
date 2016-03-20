#!/usr/bin/env bash

. ./tests/init.sh
. ./tests/2accounts.sh

./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, order_uri, details) values (100, 'USA', 1, 2, 'gid://order1', 'test');" "ERROR:  Account (from #1) has wrong currency" && \

./tests/assert_value.sh 'select count(*) from OPENBILL_TRANSACTIONS ' '0' && \
./tests/assert_value.sh 'select amount_cents from OPENBILL_ACCOUNTS  where id=1' '0' && \
./tests/assert_value.sh 'select amount_cents from OPENBILL_ACCOUNTS  where id=2' '0'
