#!/usr/bin/env bash

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USA', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order1', 'test');" "ERROR:  Account (from #$_ACCOUNT1_UUID) has wrong currency" && \

./tests/assert_value.sh 'select count(*) from OPENBILL_TRANSACTIONS ' '0' && \
./tests/assert_value.sh "select amount_cents from OPENBILL_ACCOUNTS  where id=$ACCOUNT1_UUID" '0' && \
./tests/assert_value.sh "select amount_cents from OPENBILL_ACCOUNTS  where id=$ACCOUNT2_UUID" '0'
