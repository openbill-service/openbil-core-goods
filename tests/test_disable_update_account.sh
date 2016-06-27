#!/usr/bin/env sh

echo "Можно обновлять детали"

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "delete from OPENBILL_ACCOUNTS" 'ERROR:  Cannot delete account' && \

# TODO: Пока эти тесты еще не проходят

# Это можно
echo "PENDING ""update OPENBILL_ACCOUNTS set details='some' where id=$ACCOUNT1_UUID" 'UPDATE 1' && \

# Нельзя этому случиться
echo "PENDING " ./tests/assert_result.sh "update OPENBILL_ACCOUNTS set amount_cents=123 where id=$ACCOUNT1_UUID" 'ERROR:  Cannot directly update amount_cents and timestamps of account' && \
echo "PENDING " ./tests/assert_result.sh "update OPENBILL_ACCOUNTS set created_at=current_date where id=$ACCOUNT1_UUID" 'ERROR:  Cannot directly update amount_cents and timestamps of account'
