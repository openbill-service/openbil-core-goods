#!/usr/bin/env sh

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "delete from OPENBILL_POLICIES" 'DELETE 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (owner_id, amount_cents, amount_currency, from_account_id, to_account_id, key, details) values ($OWNER_UUID, 100, 'USD', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order1', 'test')" 'ERROR:  No policy for this transaction'
./tests/assert_result.sh "insert into OPENBILL_POLICIES (owner_id, name, from_account_id, to_account_id) VALUES ($OWNER_UUID, 'test', $ACCOUNT1_UUID, $ACCOUNT2_UUID)" 'INSERT 0 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (owner_id, amount_cents, amount_currency, from_account_id, to_account_id, key, details) values ($OWNER_UUID, 100, 'USD', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order1', 'test')" 'INSERT 0 1' && \
./tests/assert_result.sh "delete from OPENBILL_POLICIES" 'DELETE 1' && \
./tests/assert_result.sh "insert into OPENBILL_POLICIES (owner_id, name, from_category_id) VALUES ($OWNER_UUID, 'test', $CATEGORY_UUID)" 'INSERT 0 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (owner_id, amount_cents, amount_currency, from_account_id, to_account_id, key, details) values ($OWNER_UUID, 100, 'USD', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order2', 'test')" 'INSERT 0 1'
