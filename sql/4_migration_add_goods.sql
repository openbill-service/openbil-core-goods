CREATE                TABLE OPENBILL_GOODS (
  owner_id            UUID,
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id            uuid,
  title               varchar(255) not null,
  unit                varchar(128) not null default 'count',
  unit_value          decimal not null default 1,
  details             text,
  meta                hstore not null default ''::hstore,
  created_at          timestamp without time zone default current_timestamp,
  updated_at          timestamp without time zone default current_timestamp
);

CREATE UNIQUE INDEX index_goods_on_id ON OPENBILL_GOODS USING btree (id);
CREATE UNIQUE INDEX index_goods_on_group_id ON OPENBILL_GOODS USING btree (group_id);
CREATE INDEX index_goods_on_meta ON OPENBILL_GOODS USING gin (meta);

CREATE                TABLE OPENBILL_GOODS_AVAILABILITIES (
  owner_id            UUID,
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  account_id          uuid not null,
  good_id             uuid not null,
  value               decimal not null default 0,

  -- Количество единиц товара
  units_count         integer not null default 0,

  -- Учетная цена
  unit_price_cents          bigint not null,
  unit_price_currency       char(3) not null,

  created_at          timestamp without time zone default current_timestamp,
  updated_at          timestamp without time zone default current_timestamp,
  foreign key (account_id) REFERENCES OPENBILL_ACCOUNTS (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  foreign key (good_id) REFERENCES OPENBILL_GOODS (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE UNIQUE INDEX index_goods_availabilities
  ON OPENBILL_GOODS_AVAILABILITIES
  USING btree (owner_id, account_id, good_id);

ALTER TABLE OPENBILL_TRANSACTIONS ADD column good_id uuid;
-- Объем товара good_value = (good.unit_value * units_count)
ALTER TABLE OPENBILL_TRANSACTIONS ADD column good_value decimal;
ALTER TABLE OPENBILL_TRANSACTIONS ADD column good_unit varchar(128) not null default 'count';
-- Количество товара
ALTER TABLE OPENBILL_TRANSACTIONS ADD column units_count integer;
-- Стоимость одной единицы товара
ALTER TABLE OPENBILL_TRANSACTIONS ADD column unit_price_cents bigint;
ALTER TABLE OPENBILL_TRANSACTIONS ADD column unit_price_currency char(3);
ALTER TABLE OPENBILL_TRANSACTIONS
  ADD FOREIGN KEY(good_id) REFERENCES OPENBILL_GOODS(id)
  ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE OPENBILL_TRANSACTIONS
  ADD CONSTRAINT good_data_existence CHECK (
    good_id IS NULL OR (good_id IS NOT NULL AND good_value IS NOT NULL AND good_unit IS NOT NULL AND units_count is NOT NULL and unit_price_cents is NOT NULL and unit_price_currency is NOT NULL)
  );

-- Убеждаемся что общая сумма транзакции соответсвует количеству товара и стоимости единицы
ALTER TABLE OPENBILL_TRANSACTIONS
  ADD CONSTRAINT good_unit_price CHECK (
    good_id IS NULL OR (unit_price_cents * units_count = amount_cents)
  );

ALTER TABLE OPENBILL_TRANSACTIONS
  ADD CONSTRAINT good_unit_currency CHECK (
    good_id IS NULL OR (unit_price_currency = amount_currency)
  );

CREATE OR REPLACE FUNCTION process_account_transaction_with_good() RETURNS TRIGGER AS $process_transaction$
DECLARE
  current_unit_price_cents bigint;
  good_unit_value decimal;
BEGIN
  PERFORM id FROM OPENBILL_GOODS where (owner_id = NEW.owner_id OR (NEW.owner_id is NULL and owner_id is NULL));
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No such good in this owner (#%)', NEW.owner_id;
  END IF;

  SELECT unit_value FROM OPENBILL_GOODS where id = NEW.good_id and unit = NEW.good_unit INTO good_unit_value;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Good (#%) has wrong good unit (#%)', NEW.good_id, NEW.good_unit;
  END IF;

  IF NEW.good_value <> good_unit_value * NEW.units_count THEN
    RAISE EXCEPTION 'Transaction has wrong amount goods value (good.unit_value * units_count <> good_value): (% * % <> %)', good_unit_value, NEW.units_count, NEW.good_value;
  END IF;

  -- Calculate current unit price
  SELECT (unit_price_cents * units_count + NEW.unit_price_cents * NEW.units_count) / ( units_count + NEW.units_count ) FROM OPENBILL_GOODS_AVAILABILITIES
    WHERE owner_id = NEW.owner_id AND account_id = NEW.to_account_id AND good_id = NEW.good_id AND units_count > 0 AND NEW.units_count > 0
    INTO current_unit_price_cents;

  IF NOT FOUND THEN
    SELECT NEW.unit_price_cents INTO current_unit_price_cents;
  END IF;

  INSERT INTO OPENBILL_GOODS_AVAILABILITIES AS GA (owner_id, account_id, good_id, value, units_count, unit_price_cents, unit_price_currency)
    VALUES (NEW.owner_id, NEW.from_account_id, NEW.good_id, -NEW.good_value, -NEW.units_count, NEW.unit_price_cents, NEW.unit_price_currency)
    ON CONFLICT (owner_id, account_id, good_id) DO UPDATE SET value = GA.value - NEW.good_value, units_count = GA.units_count - NEW.units_count, unit_price_cents = current_unit_price_cents;

  INSERT INTO OPENBILL_GOODS_AVAILABILITIES AS GA (owner_id, account_id, good_id, value, units_count, unit_price_cents, unit_price_currency)
    VALUES (NEW.owner_id, NEW.to_account_id, NEW.good_id, NEW.good_value, NEW.units_count, NEW.unit_price_cents, NEW.unit_price_currency)
    ON CONFLICT (owner_id, account_id, good_id) DO UPDATE SET value = GA.value + NEW.good_value, units_count = GA.units_count + NEW.units_count, unit_price_cents = current_unit_price_cents;

  return NEW;
END

$process_transaction$ LANGUAGE plpgsql;

CREATE TRIGGER process_account_transaction_with_good
  AFTER INSERT ON OPENBILL_TRANSACTIONS FOR EACH ROW WHEN (NEW.good_id IS NOT NULL) EXECUTE PROCEDURE process_account_transaction_with_good();
