#!/usr/bin/env bash

export GOOD1_UUID="'12832d8d-43f5-499b-82a1-100000000006'"

. ./tests/init.sh && \
. ./tests/2accounts.sh && \

./tests/assert_result.sh "insert into OPENBILL_GOODS (owner_id, id, title, unit, unit_value) values ($OWNER_UUID, $GOOD1_UUID, 'Boxes', 'boxes', 1);" "INSERT 0 1" && \
./tests/assert_result.sh "insert into OPENBILL_GOODS (owner_id, title, unit, unit_value) values ($OWNER_UUID, 'Bottles', 'Bottles', 1);" "INSERT 0 1" && \


# Добавили 100 товаров по 2.0 USD
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (owner_id, amount_cents, amount_currency, from_account_id, to_account_id, key, details, good_id, good_unit, good_value, units_count, unit_price_cents, unit_price_currency ) values ($OWNER_UUID, 20000, 'USD', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order1', 'test', $GOOD1_UUID, 'boxes', 100.0, 100, 200, 'USD');" "INSERT 0 1" && \

# Получилась учетная цена - 2.0 USD
./tests/assert_value.sh "select account_id, good_id, value, units_count, unit_price_cents from OPENBILL_GOODS_AVAILABILITIES" "12832d8d-43f5-499b-82a1-000000000001|12832d8d-43f5-499b-82a1-100000000006|-100.0|-100|200
12832d8d-43f5-499b-82a1-000000000002|12832d8d-43f5-499b-82a1-100000000006|100.0|100|200" && \

# Добавили еще 100 товаров по 3.0 USD
./tests/assert_result.sh "insert into OPENBILL_TRANSACTIONS (owner_id, amount_cents, amount_currency, from_account_id, to_account_id, key, details, good_id, good_unit, good_value, units_count, unit_price_cents, unit_price_currency ) values ($OWNER_UUID, 30000, 'USD', $ACCOUNT1_UUID, $ACCOUNT2_UUID, 'gid://order2', 'test', $GOOD1_UUID, 'boxes', 100.0, 100, 300, 'USD');" "INSERT 0 1" && \

# Учетная цена исходящего аккаунта не изменилась
# Учетная цена входящего аккаунта стала 2.5 USD
./tests/assert_value.sh "select account_id, good_id, value, units_count, unit_price_cents from OPENBILL_GOODS_AVAILABILITIES" "12832d8d-43f5-499b-82a1-000000000001|12832d8d-43f5-499b-82a1-100000000006|-200.0|-200|200
12832d8d-43f5-499b-82a1-000000000002|12832d8d-43f5-499b-82a1-100000000006|200.0|200|250"
