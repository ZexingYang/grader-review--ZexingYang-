CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'
cp student-submission/ListExamples.java .


if [ ! -f student-submission/ListExamples.java ]; then
  echo "Error: ListExamples.java not found in student submission"
  rm -f *.class
  exit 1
fi

javac -cp $CPATH *.java
if [ $? -ne 0 ]; then
  echo "Error: failed to compile student submission"
  rm -f *.class
  exit 1
fi

output=$(java -cp $CPATH org.junit.runner.JUnitCore TestListExamples)


if [ $(echo "$output" | grep -q "OK") ]; then
  # Calculate the proportion of tests passed by counting the number of test cases and failures
  num_test_cases=$(echo "$output" | grep -oE "[0-9]+ test(s)?")
  num_failures=$(echo "$output" | grep -oE "[0-9]+ failure(s)?")
  num_passes=$((num_test_cases - num_failures))
 pass_rate=$(bc <<< "scale=2; $num_passes / $num_test_cases")

  # Print the grade message
  echo "Tests passed: $num_passes/$num_test_cases ($pass_rate)"
 else
  # Print a feedback message if the tests couldn't be run
  echo "Error: failed to run tests. Details:"
  echo "$output"
  rm -f *.class
  exit 1
 fi
