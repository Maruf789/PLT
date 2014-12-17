#! /bin/bash

# this script run all the test samples
# ./test.sh <path to compiler>

# command shorthand
TRANS=$1
NU=/dev/null
DIF="diff -b -B"
CPPC=g++

# path setting
GOOD_DIR=test_samples_good
BAD_DIR=test_samples_bad
IDEAL_DIR=test_ideal_outputs
OUTPUT_DIR=outputs
CFILE_DIR=cfiles
BINFILE=binfiles

# object files
CLIBOBJ="buckcal_mat.o buckcal_core.o"

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
cp ../lib/buckcal_mat.cpp $CFILE_DIR
cp ../lib/buckcal_mat.hpp $CFILE_DIR
cp ../lib/buckcal_core.cpp $CFILE_DIR

# compile C++ library
$CPPC -c $CFILE_DIR/buckcal_core.cpp -o $CFILE_DIR/buckcal_core.o
$CPPC -c $CFILE_DIR/buckcal_mat.cpp -o $CFILE_DIR/buckcal_mat.o

# run good cases
for (( i =  0; i <= 55; i++ )) do
	rm -rf $CFILE_DIR/goodsample${i} 
	mkdir $CFILE_DIR/goodsample${i} 2> $NU
	cd $CFILE_DIR/goodsample${i}
	cp ../../$GOOD_DIR/sample${i}.bc ./
	cp ../buckcal_core.o ./
	cp ../buckcal_mat.o ./
	cp ../buckcal_mat.hpp ./
	cp ../../../lib/buckcal_lib.bc ./
	$TRANS sample${i}.bc goodsample${i}.cpp 2> ../../$OUTPUT_DIR/goodsample${i}out.txt
	if [ -s ../../$OUTPUT_DIR/goodsample${i}out.txt ]; then
		echo "Good sample${i}.bc error: compiler should not output any message"
	fi
	if [ -s goodsample${i}.cpp ]; then
		$CPPC -w $CLIBOBJ *.cpp -o ../../$BINFILE/goodsample${i}.bin \
		2>> ../../$OUTPUT_DIR/goodsample${i}out.txt
		../../$BINFILE/goodsample${i}.bin 1>> ../../$OUTPUT_DIR/goodsample${i}out.txt
	fi
	$DIF ../../$IDEAL_DIR/goodsample${i}ideal.txt ../../$OUTPUT_DIR/goodsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "Good sample${i}.bc error: program output does not match ideal one"
	fi
	cd ../../
done

# import test case
rm -rf $CFILE_DIR/goodsample56
cp -r $GOOD_DIR/sample56 $CFILE_DIR
mv $CFILE_DIR/sample56 $CFILE_DIR/goodsample56
cd $CFILE_DIR/goodsample56
cp ../buckcal_core.o ./
cp ../buckcal_mat.o ./
cp ../buckcal_mat.hpp ./
cp ../../../lib/buckcal_lib.bc ./
$TRANS sample56.bc goodsample56.cpp 2> ../../$OUTPUT_DIR/goodsample56out.txt
if [ -s ../../$OUTPUT_DIR/goodsample56out.txt ]; then
	echo "Good sample56.bc error: compiler should not output any message"
fi
if [ -s goodsample56.cpp ]; then
	$CPPC -w $CLIBOBJ *.cpp -o ../../$BINFILE/goodsample56.bin \
	2>> ../../$OUTPUT_DIR/goodsample56out.txt
	../../$BINFILE/goodsample56.bin 1>> ../../$OUTPUT_DIR/goodsample56out.txt
fi
$DIF ../../$IDEAL_DIR/goodsample56ideal.txt ../../$OUTPUT_DIR/goodsample56out.txt > $NU
if [ $? -eq 1 ]; then
	echo "Good sample56.bc error: program output does not match ideal one"
fi
cd ../../

echo "Good sample test done"

# run bad cases
for (( i =  0; i <= 72; i++ )) do
	rm -rf $CFILE_DIR/badsample${i} 
	mkdir $CFILE_DIR/badsample${i} 2> $NU
	cd $CFILE_DIR/badsample${i}
	cp ../../$BAD_DIR/sample${i}.bc ./
	cp ../buckcal_core.o ./
	cp ../buckcal_mat.o ./
	cp ../buckcal_mat.hpp ./
	cp ../../../lib/buckcal_lib.bc ./
	$TRANS sample${i}.bc badsample${i}.cpp 2> ../../$OUTPUT_DIR/badsample${i}out.txt
	if [ -s badsample${i}.cpp ]; then
		$CPPC -w $CLIBOBJ *.cpp -o ../../$BINFILE/badsample${i}.bin \
		2>> ../../$OUTPUT_DIR/badsample${i}out.txt
		../../$BINFILE/badsample${i}.bin 2>> ../../$OUTPUT_DIR/badsample${i}out.txt
	fi
	$DIF ../../$IDEAL_DIR/badsample${i}ideal.txt ../../$OUTPUT_DIR/badsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "Bad sample${i}.bc error: compiler output message does not match ideal one"
	fi
	cd ../../
done
echo "Bad sample test done"

