echo "insert into accounts (owner_uri) values ('gid://owner1')" | psql openbill 
echo "insert into accounts (owner_uri) values ('gid://owner2')" | psql openbill 
echo "insert into transactions (amount, amount_currency, from_account_id, to_account_id, order_uri, details) values (100, 'USA', 1, 2, 'gid://order1', 'test');" | psql openbill
echo 'select * from accounts' | psql openbill
echo 'select * from transactions' | psql openbill
