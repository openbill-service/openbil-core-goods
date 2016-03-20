. ./tests/config.sh

echo "Run all tests"

fails=0
for test in ./tests/test*.sh 
do
  echo -e "\nRun test: $test"
  $test

  if [ $? != 0 ]; then
    fails=`echo 1 + $fails | bc`
  fi

  ./tests/assert_balance.sh
done

if [ $fails != 0 ]; then
  echo -e "\nFAIL: $fails tests are failed"
  exit 1
else
  echo "ALL DONE!"
fi
