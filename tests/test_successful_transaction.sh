#!/usr/bin/env sh

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', 1, 2, 'gid://order1', 'test')" 'INSERT 0 1' && \

./tests/assert_value.sh 'select amount_cents from OPENBILL_ACCOUNTS  where id=1' '-100' && \
./tests/assert_value.sh 'select amount_cents from OPENBILL_ACCOUNTS  where id=2' '100' && \
./tests/assert_value.sh 'select count(*) from OPENBILL_TRANSACTIONS ' '1'
