. ./tests/config.sh

echo "Run all tests"

fails=0

for test in ./tests/test*.sh 
do
  echo -e "\nRun test: $test"
  if $test && echo "TEST PASSED" && ./tests/assert_balance.sh && echo "BALANCE PASSED"; then
    echo 'CONTROL PASSED.'
  else
    fails=`echo 1 + $fails | bc`
    echo "FAIL! ($fails)"
  fi
done

if [ $fails == 0 ]; then
  echo "ALL DONE!"
else
  echo -e "\nFAIL: $fails tests are failed"
  exit 1
fi
