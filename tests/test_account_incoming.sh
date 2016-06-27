#!/usr/bin/env sh

. ./tests/init.sh && \

echo "insert into OPENBILL_ACCOUNTS  (id, category_id, key) values ($ACCOUNT1_UUID, $CATEGORY_UUID, 'gid://owner1')" | ./tests/sql.sh && \
echo "insert into OPENBILL_ACCOUNTS  (id, category_id, key) values ($ACCOUNT2_UUID, $CATEGORY_UUID, 'gid://owner2')" | ./tests/sql.sh && \
echo "insert into OPENBILL_ACCOUNTS  (id, category_id, key) values ($ACCOUNT3_UUID, $CATEGORY_UUID, 'gid://owner3')" | ./tests/sql.sh && \

./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', $ACCOUNT2_UUID, $ACCOUNT1_UUID, 'gid://order3', 'test')" 'INSERT 0 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', $ACCOUNT2_UUID, $ACCOUNT3_UUID, 'gid://order4', 'test')" 'INSERT 0 1' && \
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', $ACCOUNT3_UUID, $ACCOUNT1_UUID, 'gid://order5', 'test')" 'INSERT 0 1'

# ./tests/assert_result.sh "update OPENBILL_TRANSACTIONS set amount_cents=1 where id=1" 'ERROR:  Cannot update or delete transaction' && \
# ./tests/assert_result.sh "delete from OPENBILL_TRANSACTIONS where id=1" 'ERROR:  Cannot update or delete transaction'
