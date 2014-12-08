#! /bin/bash

SAMPLES_DIR=../samples
NU=/dev/null

#DIF="git diff -b"
DIF="diff -b -B"

## copy C++ header here
cp ../src/buckcal_types.h .

for (( i =  0; i <= 42; i++))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.c > $NU \
	 2> 		$OUTPUT_DIR/sample${i}out.txt 
	$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/sample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "sample${i}.bc error"
	fi
	#$1 $SAMPLES_DIR/sample${i}.bc > sample${i}.cpp && g++ sample${i}.cpp -o sample${i}.bin
done
