CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

CREATE                TABLE OPENBILL_CATEGORIES (
  owner_id            UUID,
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name                character varying(256) not null,
  parent_id           uuid,
  foreign key (parent_id) REFERENCES OPENBILL_CATEGORIES (id) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX index_openbill_categories_name ON OPENBILL_CATEGORIES USING btree (parent_id, name);

INSERT INTO OPENBILL_CATEGORIES  (name, id) values ('System', '12832d8d-43f5-499b-82a1-3466cadcd809');

CREATE                TABLE OPENBILL_ACCOUNTS (
  owner_id            UUID,
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id         uuid not null,
  key                 character varying(256) not null,
  amount_cents        bigint not null default 0,
  amount_currency     char(3) not null default 'USD',
  details             text,
  transactions_count  integer not null default 0,
  last_transaction_id uuid,
  last_transaction_at timestamp without time zone,
  meta                hstore not null default ''::hstore,
  url                 character varying(2096),
  created_at          timestamp without time zone default current_timestamp,
  updated_at          timestamp without time zone default current_timestamp,
  foreign key (category_id) REFERENCES OPENBILL_CATEGORIES (id) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX index_accounts_on_id ON OPENBILL_ACCOUNTS USING btree (id);
CREATE UNIQUE INDEX index_accounts_on_key ON OPENBILL_ACCOUNTS USING btree (key);
CREATE INDEX index_accounts_on_meta ON OPENBILL_ACCOUNTS USING gin (meta);
CREATE INDEX index_accounts_on_created_at ON OPENBILL_ACCOUNTS USING btree (created_at);

CREATE TABLE OPENBILL_OPERATIONS (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at      timestamp without time zone default current_timestamp,
  from_account_id uuid not null,
  to_account_id   uuid not null,
  owner_id        UUID,
  key             character varying(256) not null,
  details         text not null,
  meta            hstore not null default ''::hstore
);

CREATE TABLE OPENBILL_TRANSACTIONS (
  owner_id              UUID,
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  operation_id          UUID,
  parent_transaction_id UUID,
  username              character varying(255) not null,
  created_at            timestamp without time zone default current_timestamp,
  from_account_id       uuid not null,
  to_account_id         uuid not null CONSTRAINT different_accounts CHECK (to_account_id<>from_account_id),
  amount_cents          bigint not null CONSTRAINT amount_positive CHECK (amount_cents>0),
  amount_currency       char(3) not null,
  key                   character varying(256) not null,
  details               text not null,
  meta                  hstore not null default ''::hstore,
  foreign key (from_account_id) REFERENCES OPENBILL_ACCOUNTS (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  foreign key (operation_id) REFERENCES OPENBILL_OPERATIONS (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  foreign key (to_account_id) REFERENCES OPENBILL_ACCOUNTS (id)
);

CREATE UNIQUE INDEX index_transactions_on_key ON OPENBILL_TRANSACTIONS USING btree (key);
CREATE INDEX index_transactions_on_meta ON OPENBILL_TRANSACTIONS USING gin (meta);
CREATE INDEX index_transactions_on_created_at ON OPENBILL_TRANSACTIONS USING btree (created_at);
ALTER TABLE OPENBILL_ACCOUNTS ADD FOREIGN KEY(last_transaction_id) REFERENCES OPENBILL_TRANSACTIONS(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
