#! /bin/bash

SAMPLES_DIR=./test_samples
OUTPUT_DIR=./test_outputs
IDEAOUTPUT_DIR=./test_ideaoutputs

$1 $SAMPLES_DIR/sample0.bc sample0.c > $OUTPUT_DIR/sample0_out
$1 $SAMPLES_DIR/sample1.bc sample1.c > $OUTPUT_DIR/sample1_out
$1 $SAMPLES_DIR/sample2.bc sample2.c > $OUTPUT_DIR/sample2_out
$1 $SAMPLES_DIR/sample3.bc sample3.c > $OUTPUT_DIR/sample3_out
