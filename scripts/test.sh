#! /bin/bash

GOOD_DIR=./test_samples_good
BAD_DIR=./test_samples_bad
OUTPUT_DIR=./test_outputs
IDEAL_DIR=./test_ideaoutputs
NU=/dev/null
CFILE_DIR=./cfiles
BINFILE=./binfiles

DIF="diff -b -B"

## copy C++ header here
cp ../src/c++/buckcal_mat.cpp $CFILE_DIR
cp ../src/c++/buckcal_mat.hpp $CFILE_DIR
cp ../src/c++/buckcal_lib.cpp $CFILE_DIR


#g++ -c $CFILE_DIR/buckcal_mat.cpp -o $CFILE_DIR/buckcal_mat.o

# run good cases
for (( i =  0; i <= 22; i++))
do
	$1 $GOOD_DIR/sample${i}.bc sample${i}.c > $NU \
	 2> 		$OUTPUT_DIR/goodsample${i}out.txt 
	#$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/sample${i}out.txt > $NU
	if [ -s $OUTPUT_DIR/goodsample${i}out.txt ]; then
		echo "good sample${i}.bc error"
	fi
	$1 $GOOD_DIR/sample${i}.bc > $CFILE_DIR/sample${i}.cpp \
	2>>		$OUTPUT_DIR/goodsample${i}out.txt
	if [ -s $CFILE_DIR/buckcal_mat.cpp ]; then
		g++ $CFILE_DIR/sample${i}.cpp $CFILE_DIR/buckcal_mat.cpp $CFILE_DIR/buckcal_lib.cpp -o $BINFILE/goodsample${i}.bin \
		2>>		$OUTPUT_DIR/goodsample${i}out.txt
	fi
done

# run bad cases
for (( i =  24; i <= 29; i++))
do
	$1 $BAD_DIR/sample${i}.bc sample${i}.c > $NU \
	 2> 		$OUTPUT_DIR/badsample${i}out.txt 
	$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/badsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "bad sample${i}.bc error"
	fi
done

