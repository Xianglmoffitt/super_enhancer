#!/bin/bash

# make bowtie2 work list (wlist) for parallel.sh

# set directories

export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/se_dataportal/NCI_60"
export ROSE_INPUT_LIST="$PROJECT_DIR/rep1_sra_id"
export WLIST_DIR="$PROJECT_DIR"
export WLIST_FILE="$WLIST_DIR/rose_rep1_wlist"
export GFF_DIR="$PROJECT_DIR/macs_out"

# creat bowtie2 paired-end parallel wlist (bowtie2 default setting)
while read IN CONTROL GFF; do
	OUT_DIR="$PROJECT_DIR/rose_out/$GFF"
	IN_GFF="$PROJECT_DIR/macs_out/"$GFF"_peaks.gff"
	IN_BAM="$PROJECT_DIR/bowtie_out/"$IN"_rmdup_sort.bam"
	CONTROL_BAM="$PROJECT_DIR/bowtie_out/"$CONTROL"_rmdup_sort.bam"

	echo "python ROSE_main.py -g HG38 -i $IN_GFF -r $IN_BAM -c $CONTROL_BAM -o $OUT_DIR" >> $WLIST_FILE

done < $ROSE_INPUT_LIST
