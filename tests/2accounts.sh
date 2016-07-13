export OWNER_UUID="'12832d8d-43f5-499b-82a1-200000000001'"
echo "insert into OPENBILL_ACCOUNTS  (owner_id, id, category_id, key) values ($OWNER_UUID, $ACCOUNT1_UUID, $CATEGORY_UUID, 'gid://owner1')" | ./tests/sql.sh && \
echo "insert into OPENBILL_ACCOUNTS  (owner_id, id, category_id, key) values ($OWNER_UUID, $ACCOUNT2_UUID, $CATEGORY_UUID, 'gid://owner2')" | ./tests/sql.sh
