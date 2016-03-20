CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;

-- CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;

CREATE                TABLE accounts (
  id                  BIGSERIAL PRIMARY KEY,
  owner_uri           character varying(2048) not null,
  amount              numeric not null default 0,
  amount_currency     char(3) not null default 'USD',
  details             text,
  transactions_count  integer not null default 0,
  last_transaction_id integer,
  last_transaction_at timestamp without time zone,
  meta                hstore not null default ''::hstore,
  created_at          timestamp without time zone default current_timestamp,
  updated_at          timestamp without time zone default current_timestamp
);

CREATE UNIQUE INDEX index_accounts_on_id ON accounts USING btree (id);
CREATE UNIQUE INDEX index_accounts_on_owner_uri ON accounts USING btree (owner_uri);
CREATE INDEX index_accounts_on_meta ON accounts USING gin (meta);
CREATE INDEX index_accounts_on_created_at ON accounts USING btree (created_at);

CREATE TABLE transactions (
  id              BIGSERIAL PRIMARY KEY,
  username        character varying(255) not null,
  created_at      timestamp without time zone default current_timestamp,
  from_account_id integer not null,
  to_account_id   integer not null,
  amount          numeric not null CONSTRAINT positive CHECK (amount>0),
  amount_currency char(3) not null,
  order_uri       character varying(2048) not null,
  details         text not null,
  meta            hstore not null default ''::hstore,
  foreign key (from_account_id) REFERENCES accounts (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  foreign key (to_account_id) REFERENCES accounts (id)
);

CREATE UNIQUE INDEX index_transactions_on_order_uri ON transactions USING btree (order_uri);
CREATE INDEX index_transactions_on_meta ON transactions USING gin (meta);
CREATE INDEX index_transactions_on_created_at ON transactions USING btree (created_at);

ALTER TABLE accounts ADD FOREIGN KEY(last_transaction_id) REFERENCES transactions(id) ON DELETE RESTRICT ON UPDATE RESTRICT;
