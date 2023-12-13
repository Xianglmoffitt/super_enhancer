#!/bin/bash

# make bowtie2 work list (wlist) for parallel.sh

# set directories

export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/se_dataportal/NCI_60"
export MACS_INPUT_LIST="$PROJECT_DIR/rep2_sra_id"
export WLIST_DIR="$PROJECT_DIR"
export WLIST_FILE="$WLIST_DIR/fCount_rep2_wlist"
export SAF_DIR="$PROJECT_DIR/feature_count/saf"
export OUT_DIR="$PROJECT_DIR/feature_count/output"
export BAM_DIR="$PROJECT_DIR/bowtie_out"
# creat bowtie2 paired-end parallel wlist (bowtie2 default setting)
while read EXP CONTROL OUT_DIR_NAME; do

	echo "featureCounts -T 2 -a $SAF_DIR/"$OUT_DIR_NAME"_macs_peak.saf -F SAF -o $OUT_DIR/"$OUT_DIR_NAME" $BAM_DIR/"$EXP"_rmdup_sort.bam" >> $WLIST_FILE
	
#	echo "featureCounts -T 2 -a $SAF_DIR/"$OUT_DIR_NAME"_macs_peak.saf -F SAF -o $OUT_DIR/"$OUT_DIR_NAME" $BAM_DIR/"$EXP"_rmdup_sort.bam" >> $WLIST_FILE

done < $MACS_INPUT_LIST
