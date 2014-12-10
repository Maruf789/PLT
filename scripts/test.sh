#! /bin/bash

SAMPLES_DIR=./test_samples
OUTPUT_DIR=./test_outputs
IDEAL_DIR=./test_ideaoutputs
NU=/dev/null
CFILE_DIR=./cfiles
BINFILE=./binfiles

#DIF="git diff -b"
DIF="diff -b -B"

## copy C++ header here
cp ../src/buckcal_types.h $CFILE_DIR

# compare <outputfile> <idealoutputfile>
for (( i =  27; i <= 27; i++))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.c > $NU \
	 2> 		$OUTPUT_DIR/sample${i}out.txt 
	$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/sample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "sample${i}.bc error"
	fi
# run <args>
	$1 $SAMPLES_DIR/sample${i}.bc > $CFILE_DIR/sample${i}.cpp && g++ $CFILE_DIR/sample${i}.cpp -o $BINFILE/sample${i}.bin \
	2>>		$OUTPUT_DIR/sample${i}out.txt
done
