#!/usr/bin/env sh

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "delete from OPENBILL_POLICIES" 'DELETE 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', 1, 2, 'gid://order1', 'test')" 'ERROR:  No policy for this transaction'
./tests/assert_result.sh "insert into OPENBILL_POLICIES (name, from_account_id, to_account_id) VALUES ('test', 1, 2)" 'INSERT 0 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', 1, 2, 'gid://order1', 'test')" 'INSERT 0 1' && \
./tests/assert_result.sh "delete from OPENBILL_POLICIES" 'DELETE 1' && \
./tests/assert_result.sh "insert into OPENBILL_POLICIES (name, from_category_id) VALUES ('test', 1)" 'INSERT 0 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', 1, 2, 'gid://order2', 'test')" 'INSERT 0 1'
