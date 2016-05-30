echo "insert into OPENBILL_ACCOUNTS  (category_id, key) values (1, 'gid://owner1')" | ./tests/sql.sh && \
echo "insert into OPENBILL_ACCOUNTS  (category_id, key) values (1, 'gid://owner2')" | ./tests/sql.sh
