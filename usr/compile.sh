#! /bin/bash

# this script compile a file for user
# ./compile.sh <main buckcal source file> <output executable name>

# command shorthand
PWD=`pwd`
NU=/dev/null
CPPC=g++

# path setting
COMPILER=$PWD/../src/main.bin
WORK_DIR=$PWD/work

# checking and file

if [ ! -f $COMPILER ]; then
	echo "Error: compiler not found, please make first"
	exit 1
fi

if [ "$1" == "" ]; then
	echo "Error: missing path of input file"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "Error: input file does not exist"
	exit 1
fi

if [ "$2" == "" ]; then
	echo "Error: missing path of output executable"
	exit 1
fi

# mkdir for testing
mkdir $WORK_DIR 2> $NU

# copy files to work folder
cp $PWD/../lib/buckcal_mat.cpp $WORK_DIR
cp $PWD/../lib/buckcal_mat.hpp $WORK_DIR
cp $PWD/../lib/buckcal_core.cpp $WORK_DIR
cp $PWD/../lib/buckcal_lib.bc $PWD

# compile
$COMPILER $1 $WORK_DIR/$1.cpp

cd $WORK_DIR

if [ ! -s $1.cpp ]; then
	echo "Error: cannot compile $1"
	exit 1
fi

$CPPC -w buckcal_core.cpp buckcal_mat.cpp $1.cpp -o ../$2

if [ ! -f ../$2 ]; then
	echo "Error: cannot generate executable"
	exit 1
fi

echo "Compile complete, $2 is ready"

