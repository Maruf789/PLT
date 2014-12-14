#! /bin/bash

# this script run all the test samples
# ./test.sh <path to compiler>

# command shorthand
PWD=`pwd`
TRANS=$PWD/$1
NU=/dev/null
DIF="diff -b -B"
CPPC=g++

# path setting
GOOD_DIR=$PWD/test_samples_good
BAD_DIR=$PWD/test_samples_bad
IDEAL_DIR=$PWD/test_ideal_outputs
OUTPUT_DIR=$PWD/outputs
CFILE_DIR=$PWD/cfiles
BINFILE=$PWD/binfiles

# object files
CLIBOBJ="$CFILE_DIR/buckcal_mat.o $CFILE_DIR/buckcal_core.o"

# checking argument
if [ "$1" == "" ]; then
	echo "Error: missing path of compiler"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "Error: compiler does not exist"
	exit 1
fi

# mkdir for testing
mkdir $OUTPUT_DIR $CFILE_DIR $BINFILE 2> $NU

# copy C++ library here
cp $PWD/../lib/buckcal_mat.cpp $CFILE_DIR
cp $PWD/../lib/buckcal_mat.hpp $CFILE_DIR
cp $PWD/../lib/buckcal_core.cpp $CFILE_DIR
cp $PWD/../lib/buckcal_lib.bc $GOOD_DIR
cp $PWD/../lib/buckcal_lib.bc $BAD_DIR

# compile C++ library
$CPPC -c $CFILE_DIR/buckcal_core.cpp -o $CFILE_DIR/buckcal_core.o
$CPPC -c $CFILE_DIR/buckcal_mat.cpp -o $CFILE_DIR/buckcal_mat.o

# run good cases
for (( i =  0; i <= 55; i++ )) do
	cd $GOOD_DIR
	$TRANS sample${i}.bc $CFILE_DIR/goodsample${i}.cpp 2> $OUTPUT_DIR/goodsample${i}out.txt
	cd $PWD
	if [ -s $OUTPUT_DIR/goodsample${i}out.txt ]; then
		echo "Good sample${i}.bc error: compiler should not output any message"
	fi
	if [ -s $CFILE_DIR/goodsample${i}.cpp ]; then
		$CPPC -w $CLIBOBJ $CFILE_DIR/goodsample${i}.cpp -o $BINFILE/goodsample${i}.bin \
		2>> $OUTPUT_DIR/goodsample${i}out.txt
		$BINFILE/goodsample${i}.bin 1>> $OUTPUT_DIR/goodsample${i}out.txt
	fi
	$DIF $IDEAL_DIR/goodsample${i}ideal.txt $OUTPUT_DIR/goodsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "Good sample${i}.bc error: program output does not match ideal one"
	fi
done
echo "Good sample test done"

# run bad cases
for (( i =  0; i <= 72; i++ )) do
	cd $BAD_DIR
	$TRANS sample${i}.bc $CFILE_DIR/badsample${i}.cpp 2> $OUTPUT_DIR/badsample${i}out.txt
	cd $PWD
	if [ -s $CFILE_DIR/badsample${i}.cpp ]; then
		$CPPC -w $CFILE_DIR/badsample${i}.cpp $CLIBOBJ -o $BINFILE/badsample${i}.bin \
		2>>	$OUTPUT_DIR/badsample${i}out.txt
		$BINFILE/badsample${i}.bin 2>> $OUTPUT_DIR/badsample${i}out.txt
	fi
	$DIF $IDEAL_DIR/badsample${i}ideal.txt $OUTPUT_DIR/badsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "Bad sample${i}.bc error: compiler output message does not match ideal one"
	fi
done
echo "Bad sample test done"

