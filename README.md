# openbill core

[![Build Status](https://travis-ci.org/openbill-service/openbill-core.svg)](https://travis-ci.org/openbill-service/openbill-core)

Open Source Billing core.

Биллинг создан по принципу меньше фунционала, но больше надежности. 

# Установка

> PGDATABASE=openbill_development ./scripts/create.sh

# Надежность

Чем обсуловлена неджность данного решения?

1. Отсутвие прокладов в виде API для обработки данных. Нет лишних сервисов,
   которые могут упать или иметь потенциальные баги.
2. Система ролей и безопасности на базе Postgresql. Ниже и надежнее не
   придумаешь.
3. С помощью триггеров в базе запрещены все опасные операции с базой. Postgresql
   сам следит за тем, чтобы баланс сходился.


# Тесты

> ./run_all_tests.sh

## Негативные

Транзакции:

* Невозможно провести транзакцию с валютой не совпадающей с любым из счетов -
  done
* Невозможно удалить или изменить транзакцию - done
* При создании `transaction` не возможно переопределить `created_at`

Аккаунты:

* Невозможно изменить `amount`, `amount_currency` или данные последней транзакции у счета напрямую.
* `updated_at` изменяется при любом апдейте `accounts`
* [ ] невозможнос создать аккаунт с не нулевым балансом

Безопасность:

* Типовой пользователь не может только делать select, insert для transactions, insert and update для accounts
* Администратор не может удалить запись из accounts или transactions
* Баланс всегда сходится - done

## Позитивные

* Создается аккаунт - done
* Проводится транзакция - done

## Другие решения

* http://balancedbilly.readthedocs.org/en/latest/getting_started.html#create-a-customer
* http://demo.opensourcebilling.org/invoices
