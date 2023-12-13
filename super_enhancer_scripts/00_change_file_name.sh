#!/bin/bash

# change file names


# set directories
export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/encode_v2"
export IN_DIR="$PROJECT_DIR/control_bam"
#export OUT_DIR="$PROJECT_DIR/download/control_p_fastq"

# rename file with old and new name 
export OLD_NEW_NAME_FILE="$PROJECT_DIR/fq_to_control_acc"

cd $IN_DIR

while read OLD NEW; do

	OLD_NAME="$OLD"_sorted.bam
	NEW_NAME="$NEW"_control_sorted.bam
	mv $OLD_NAME $NEW_NAME

done < $OLD_NEW_NAME_FILE
