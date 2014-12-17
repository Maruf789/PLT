#! /bin/bash

# this script compile a file for user
# ./compile.sh <main buckcal source file> <output executable name>

# command shorthand
NU=/dev/null
CPPC=g++

# path setting
COMPILER=../src/main.bin

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

# copy files to work folder
cp ../lib/buckcal_mat.cpp ./
cp ../lib/buckcal_mat.hpp ./
cp ../lib/buckcal_core.cpp ./
cp ../lib/buckcal_lib.bc ./

# compile
$COMPILER $1 $1.cpp

if [ ! -s $1.cpp ]; then
	echo "Error: cannot compile $1"
	exit 1
fi

$CPPC -w *.cpp -o $2

if [ ! -f $2 ]; then
	echo "Error: cannot generate executable"
	exit 1
fi

echo "Compile complete, $2 is ready"

