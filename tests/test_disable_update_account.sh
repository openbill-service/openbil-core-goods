#!/usr/bin/env sh

. ./tests/init.sh
. ./tests/2accounts.sh

# Можно обновлять детали
./tests/assert_result.sh "update accounts set details='some' where id=1" 'UPDATE 1'
# ./tests/assert_result.sh "update accounts set amount=123 where id=1" 'UPDATE 1'
# ./tests/assert_result.sh "delete from accounts where id=1" 'UPDATE 1'
