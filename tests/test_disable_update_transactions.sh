#!/usr/bin/env sh

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (owner_id, amount_cents, amount_currency, from_account_id, to_account_id, key, details) values ($OWNER_UUID, 100, 'USD', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order1', 'test')" 'INSERT 0 1' && \

./tests/assert_result.sh "update OPENBILL_TRANSACTIONS set amount_cents=1" 'ERROR:  Cannot update or delete transaction' && \
./tests/assert_result.sh "delete from OPENBILL_TRANSACTIONS" 'ERROR:  Cannot update or delete transaction'
