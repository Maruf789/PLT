#! /bin/bash

SAMPLES_DIR=../samples

for (( i=0; i<3; i++ ))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.cpp
done
