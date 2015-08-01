# openbill

[![Build Status](https://travis-ci.org/BrandyMint/openbill-core.svg)](https://travis-ci.org/BrandyMint/openbill-core)

Open Source Billing core

# Тесты

* Невозможно провести транзакцию с валютой не совпадающей с любым из счетов
* Невозможно провести операция с не активным счетом
* Невозможно удалить или изменить транзакцию
* Невозможно изменить amount и данные последней транзакции у счета напрямую.
* При создании transaction не возможно переопределить created_at

Another solutions:

* http://balancedbilly.readthedocs.org/en/latest/getting_started.html#create-a-customer
* http://demo.opensourcebilling.org/invoices
