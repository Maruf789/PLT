#! /bin/bash

SAMPLES_DIR=../samples
NU=/dev/null

cp ../src/buckcal_types.h .

for (( i=0; i<3; i++ ))
do
	$1 $SAMPLES_DIR/sample${i}.bc > sample${i}.cpp && g++ sample${i}.cpp -o sample${i}.bin
done

