#!/bin/bash

# make bowtie2 work list (wlist) for parallel.sh

# set directories

export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/se_dataportal/NCI_60"
export MACS_INPUT_LIST="$PROJECT_DIR/rep2_sra_id"
export WLIST_DIR="$PROJECT_DIR"
export WLIST_FILE="$WLIST_DIR/macs_rep2_wlist"

# creat bowtie2 paired-end parallel wlist (bowtie2 default setting)
while read EXP CONTROL OUT_DIR_NAME; do
	OUT_DIR="$PROJECT_DIR/macs_out"
	EXP_IN="$PROJECT_DIR/bowtie_out"
	CONTROL_IN="$PROJECT_DIR/bowtie_out"

	echo "macs2 callpeak -g hs -t $EXP_IN/"$EXP"_rmdup_sort.bam -c $CONTROL_IN/"$CONTROL"_rmdup_sort.bam -f BAM -n $OUT_DIR_NAME --bdg --outdir $OUT_DIR 2> "$OUT_DIR/"$OUT_DIR_NAME".log"" >> $WLIST_FILE

done < $MACS_INPUT_LIST
