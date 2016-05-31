#!/usr/bin/env sh

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result_include.sh "listen OPENBILL_TRANSACTIONS; insert into OPENBILL_TRANSACTIONS (amount_cents, amount_currency, from_account_id, to_account_id, key, details) values (100, 'USD', 1, 2, 'gid://order1', 'test')" 'Asynchronous notification "openbill_transactions" with payload "1" received from server'
