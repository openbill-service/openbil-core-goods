CREATE OR REPLACE FUNCTION constraint_transaction_ownership() RETURNS TRIGGER AS $process_transaction$
BEGIN
  PERFORM * FROM OPENBILL_ACCOUNTS WHERE id = NEW.from_account_id and owner_id = NEW.owner_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such source account in this owner (to #%)', NEW.owner_id;
  END IF;

  PEFFORM * FROM OPENBILL_ACCOUNTS WHERE id = NEW.to_account_id and owner_id = NEW.owner_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such destination account in this owner (to #%)', NEW.owner_id;
  END IF;


  return NEW;
END

$process_transaction$ LANGUAGE plpgsql;

CREATE TRIGGER constraint_transaction_ownership
  AFTER INSERT ON OPENBILL_TRANSACTIONS FOR EACH ROW EXECUTE PROCEDURE constraint_transaction_ownership();
