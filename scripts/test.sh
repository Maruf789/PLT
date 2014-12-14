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

#g++ -c $CFILE_DIR/buckcal_mat.cpp -o $CFILE_DIR/buckcal_mat.o
cp $PWD/../src/c++/buckcal_mat.cpp $CFILE_DIR
cp $PWD/../src/c++/buckcal_mat.hpp $CFILE_DIR
cp $PWD/../src/c++/buckcal_core.cpp $CFILE_DIR
cp $PWD/../src/libraryFiles/buckcal_lib.bc $GOOD_DIR
cp $PWD/../src/libraryFiles/buckcal_lib.bc $BAD_DIR


## run good cases
for (( i =  0; i <= 55; i++))
do
	cd $GOOD_DIR
	#echo $TRANS
	#echo $CFILE_DIR/sample${i}.cpp
	$TRANS sample${i}.bc $CFILE_DIR/goodsample${i}.cpp \
	2>		$OUTPUT_DIR/goodsample${i}out.txt
	cd $PWD
	if [ -s $OUTPUT_DIR/goodsample${i}out.txt ]; then
		echo "good sample${i}.bc error"
	fi
	if [ -s $CFILE_DIR/goodsample${i}.cpp ]; then 
		g++ $CFILE_DIR/goodsample${i}.cpp $CFILE_DIR/buckcal_mat.cpp $CFILE_DIR/buckcal_core.cpp -o $BINFILE/goodsample${i}.bin \
		2>>		$OUTPUT_DIR/goodsample${i}out.txt
		$BINFILE/goodsample${i}.bin 1 >> $OUTPUT_DIR/goodsample${i}out.txt
	fi
	$DIF $IDEAL_DIR/goodsample${i}idea.txt $OUTPUT_DIR/goodsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "good sample${i}.bc error"
	fi

done

## run bad cases
for (( i =  0; i <= 72; i++))
do
	cd $BAD_DIR
	$TRANS sample${i}.bc $CFILE_DIR/badsample${i}.cpp \
	 2> 		$OUTPUT_DIR/badsample${i}out.txt 
	cd $PWD

	if [ -s $CFILE_DIR/badsample${i}.cpp ]; then 
		g++ $CFILE_DIR/badsample${i}.cpp $CFILE_DIR/buckcal_mat.cpp $CFILE_DIR/buckcal_core.cpp -o $BINFILE/badsample${i}.bin \
		2>>		$OUTPUT_DIR/badsample${i}out.txt
		$BINFILE/badsample${i}.bin 1 >> $OUTPUT_DIR/badsample${i}out.txt
	fi
	$DIF $IDEAL_DIR/badsample${i}idea.txt $OUTPUT_DIR/badsample${i}out.txt > $NU
	if [ $? -eq 1 ]; then
		echo "bad sample${i}.bc error"
	fi
done

