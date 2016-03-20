#!/usr/bin/env sh

. ./tests/init.sh
. ./tests/2accounts.sh

./tests/assert_result.sh "insert into transactions (amount, amount_currency, from_account_id, to_account_id, order_uri, details) values (100, 'USD', 1, 2, 'gid://order1', 'test')" 'INSERT 0 1' && \

./tests/assert_result.sh "update transactions set amount=1 where id=1" 'ERROR:  Cannot update or delete transaction' && \
./tests/assert_result.sh "delete from transactions where id=1" 'ERROR:  Cannot update or delete transaction'
