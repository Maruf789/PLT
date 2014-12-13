#! /bin/bash

GOOD_DIR=./test_samples_good
BAD_DIR=./test_samples_bad
OUTPUT_DIR=./test_outputs
IDEAL_DIR=./test_ideaoutputs
NU=/dev/null
CFILE_DIR=./cfiles
BINFILE=./binfiles

DIF="diff -b -B"

# Set time limit for all operations
ulimit -t 30

# Copy C++ header here
cp ../src/c++/buckcal_mat.cpp $CFILE_DIR
cp ../src/c++/buckcal_mat.hpp $CFILE_DIR
cp ../src/c++/buckcal_core.cpp $CFILE_DIR


g++ -o $CFILE_DIR/buckcal.o -c $CFILE_DIR/buckcal_mat.cpp $CFILE_DIR/buckcal_core.cpp

# Run good cases
for (( i =  0; i <= 37; i++))
do
	$1 $GOOD_DIR/sample${i}.bc $CFILE_DIR/sample${i}.cpp \
	2>		$OUTPUT_DIR/goodsample${i}out.txt
	if [ -s $OUTPUT_DIR/goodsample${i}out.txt ]; then
		echo "good sample${i}.bc error"
	fi
	if [ -s $CFILE_DIR/sample${i}.cpp ]; then
		g++ -o $BINFILE/goodsample${i}.o -c $CFILE_DIR/sample${i}.cpp \
		2>>		$OUTPUT_DIR/goodsample${i}out.txt
		g++ -o $BINFILE/goodsample${i}.bin $CFILE_DIR/buckcal.o $BINFILE/goodsample${i}.o \
		2>>		$OUTPUT_DIR/goodsample${i}out.txt
	fi
	

done

# run bad cases
for (( i =  0; i <= 48; i++))
do
	$1 $BAD_DIR/sample${i}.bc > $NU \
	 2> 		$OUTPUT_DIR/badsample${i}out.txt 
	$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/badsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "bad sample${i}.bc error"
	fi
done

