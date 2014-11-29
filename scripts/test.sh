#! /bin/bash

SAMPLES_DIR=./test_samples
OUTPUT_DIR=./test_outputs
IDEAOUTPUT_DIR=./test_ideaoutputs

for (( i =  0; i <= 24; i++))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.c > /dev/null\
	 2> 		$OUTPUT_DIR/sample${i}out.txt 
	cmp -s $IDEAOUTPUT_DIR/sample${i}idea.txt $OUTPUT_DIR/sample${i}out.txt
	if [ $? -eq 1 ]; then
		echo "sample${i}.bc error"
	fi
done

