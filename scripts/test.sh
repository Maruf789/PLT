#! /bin/bash

SAMPLES_DIR=../samples

$1 $SAMPLES_DIR/sample0.bc sample0.c > sample0_out
$1 $SAMPLES_DIR/sample1.bc sample1.c > sample1_out
$1 $SAMPLES_DIR/sample2.bc sample2.c > sample2_out
$1 $SAMPLES_DIR/sample3.bc sample3.c > sample3_out

