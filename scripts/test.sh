#! /bin/bash
PWD=`pwd`

## path setting
GOOD_DIR=$PWD/test_samples_good
BAD_DIR=$PWD/test_samples_bad
OUTPUT_DIR=$PWD/test_outputs
IDEAL_DIR=$PWD/test_ideaoutputs
CFILE_DIR=$PWD/cfiles
BINFILE=$PWD/binfiles
TRANS=$PWD/$1

NU=/dev/null
DIF="diff -b -B"

## copy C++ header here
cp $PWD/../src/c++/buckcal_mat.cpp $CFILE_DIR
cp $PWD/../src/c++/buckcal_mat.hpp $CFILE_DIR
cp $PWD/../src/c++/buckcal_core.cpp $CFILE_DIR

ls -l $TRANS
## run good cases
for (( i =  37; i <= 37; i++))
do
	cd $GOOD_DIR
	$TRANS sample${i}.bc $CFILE_DIR/sample${i}.cpp \
	2>		$OUTPUT_DIR/goodsample${i}out.txt
	cd $PWD
	if [ -s $OUTPUT_DIR/goodsample${i}out.txt ]; then
		echo "good sample${i}.bc error"
	fi
	if [ -s $CFILE_DIR/sample${i}.cpp ]; then 
		g++ $CFILE_DIR/sample${i}.cpp $CFILE_DIR/buckcal_mat.cpp $CFILE_DIR/buckcal_core.cpp -o $BINFILE/goodsample${i}.bin \
		2>>		$OUTPUT_DIR/goodsample${i}out.txt
	fi
done

## run bad cases
for (( i =  0; i <= 48; i++))
do
	cd $BAD_DIR
	$TRANS sample${i}.bc $NU \
	 2> 		$OUTPUT_DIR/badsample${i}out.txt 
	cd $PWD
	$DIF $IDEAL_DIR/sample${i}idea.txt $OUTPUT_DIR/badsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "bad sample${i}.bc error"
	fi
done

