echo "insert into OPENBILL_ACCOUNTS  (id, category_id, key) values ($ACCOUNT1_UUID, $CATEGORY_UUID, 'gid://owner1')" | ./tests/sql.sh && \
echo "insert into OPENBILL_ACCOUNTS  (id, category_id, key) values ($ACCOUNT2_UUID, $CATEGORY_UUID, 'gid://owner2')" | ./tests/sql.sh
