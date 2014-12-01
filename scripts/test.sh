#! /bin/bash

SAMPLES_DIR=./test_samples
OUTPUT_DIR=./test_outputs
IDEAL_DIR=./test_ideaoutputs
NU=/dev/null
#DIF="git diff -b"
DIF="diff -b -B"

for (( i =  0; i <= 37; i++))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.c > $NU \
	 2> 		$OUTPUT_DIR/sample${i}out.txt 
	$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/sample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "sample${i}.bc error"
	fi
done
