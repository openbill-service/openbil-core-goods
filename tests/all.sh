

echo "Run all tests"
for test in ./tests/test*.sh 
do
  echo "Run test: $test"
  PGDATABASE='openbill_test' exec $test
done
