CREATE OR REPLACE RULE suppress_account_delete AS ON DELETE TO accounts WHERE transactions_count > 0 DO INSTEAD NOTHING;
CREATE OR REPLACE RULE suppress_transactions_delete AS ON DELETE TO transactions DO INSTEAD NOTHING;
CREATE OR REPLACE RULE suppress_transactions_update AS ON UPDATE TO transactions DO INSTEAD NOTHING;

-- Заменить на CREATE CONSTRAINT TRIGGER

CREATE OR REPLACE FUNCTION process_account_transaction() RETURNS TRIGGER AS $process_transaction$
DECLARE
  result text;
BEGIN
  -- проверить что аккаунты is_active


  -- У всех счетов и транзакции должна быть одинаковая валюта

  SELECT id FROM accounts where id = NEW.from_account_id and amount_currency = NEW.amount_currency AND is_active INTO result;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (from #%) has wrong currency or account is disabled', NEW.from_account_id;
  END IF;

  SELECT * FROM accounts where id = NEW.to_account_id and amount_currency = NEW.amount_currency AND is_active INTO result;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (to #%) has wrong currency or account is disabled', NEW.to_account_id;
  END IF;


  -- установить last_transaction_id, counts и _at
  UPDATE accounts SET amount = amount - NEW.amount, last_transaction_id = NEW.id, last_transaction_at = NEW.created_at, transactions_count = transactions_count + 1 WHERE id = NEW.from_account_id;
  UPDATE accounts SET amount = amount + NEW.amount, last_transaction_id = NEW.id, last_transaction_at = NEW.created_at, transactions_count = transactions_count + 1 WHERE id = NEW.to_account_id;

  return NEW;
END

$process_transaction$ LANGUAGE plpgsql;


CREATE TRIGGER process_account_transaction
  AFTER INSERT ON TRANSACTIONS FOR EACH ROW EXECUTE PROCEDURE process_account_transaction();


-- Запрещаем удаление и какое-либо изменение transactions

CREATE OR REPLACE FUNCTION disable_update_transaction() RETURNS TRIGGER AS $disable_update_transaction$
BEGIN
  RAISE EXCEPTION 'Cannot update or delete transaction';
END

$disable_update_transaction$ LANGUAGE plpgsql;

CREATE TRIGGER disable_update_transaction
  BEFORE UPDATE OR DELETE ON TRANSACTIONS FOR EACH ROW EXECUTE PROCEDURE disable_update_transaction();
