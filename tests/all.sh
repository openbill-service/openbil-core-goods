

echo "Run all tests"

res=0
for test in ./tests/test*.sh 
do
  echo "\nRun test: $test"
  $test

  if [ $? != 0 ]; then
    res=1
  fi
done

if [ $res != 0 ]; then
  echo "Some tests failed"
  exit 1
fi
