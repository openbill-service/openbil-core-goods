#!/usr/bin/env sh

. ./tests/init.sh
. ./tests/2accounts.sh

echo "Можно обновлять детали"

# TODO: Пока эти тесты еще не проходят

# Это можно
echo "PENDING ""update OPENBILL_ACCOUNTS  set details='some' where id=1" 'UPDATE 1'

# Нельзя этому случиться
echo "PENDING " ./tests/assert_result.sh "update OPENBILL_ACCOUNTS set amount_cents=123 where id=1" 'ERROR:  Cannot directly update amount_cents and timestamps of account' && \
echo "PENDING " ./tests/assert_result.sh "update OPENBILL_ACCOUNTS set created_at=current_date where id=1" 'ERROR:  Cannot directly update amount_cents and timestamps of account' && \
./tests/assert_result.sh "delete from OPENBILL_ACCOUNTS  where id=1" 'ERROR:  Cannot delete account'
