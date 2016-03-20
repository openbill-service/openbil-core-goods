CREATE OR REPLACE FUNCTION process_account_transaction() RETURNS TRIGGER AS $process_transaction$
DECLARE
  result text;
BEGIN
  -- У всех счетов и транзакции должна быть одинаковая валюта

  SELECT id FROM accounts where id = NEW.from_account_id and amount_currency = NEW.amount_currency INTO result;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (from #%) has wrong currency', NEW.from_account_id;
  END IF;

  SELECT * FROM accounts where id = NEW.to_account_id and amount_currency = NEW.amount_currency INTO result;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account (to #%) has wrong currency', NEW.to_account_id;
  END IF;


  -- установить last_transaction_id, counts и _at
  UPDATE accounts SET amount = amount - NEW.amount, last_transaction_id = NEW.id, last_transaction_at = NEW.created_at, transactions_count = transactions_count + 1 WHERE id = NEW.from_account_id;
  UPDATE accounts SET amount = amount + NEW.amount, last_transaction_id = NEW.id, last_transaction_at = NEW.created_at, transactions_count = transactions_count + 1 WHERE id = NEW.to_account_id;

  return NEW;
END

$process_transaction$ LANGUAGE plpgsql;

CREATE TRIGGER process_account_transaction
  AFTER INSERT ON TRANSACTIONS FOR EACH ROW EXECUTE PROCEDURE process_account_transaction();

-- current_user

CREATE OR REPLACE FUNCTION add_current_user_to_transaction() RETURNS TRIGGER AS $add_current_user_to_transaction$
BEGIN
  NEW.username := current_user;
  RETURN NEW;
END
$add_current_user_to_transaction$ LANGUAGE plpgsql;

CREATE TRIGGER add_current_user_to_transaction
  BEFORE INSERT ON TRANSACTIONS FOR EACH ROW EXECUTE PROCEDURE add_current_user_to_transaction();
