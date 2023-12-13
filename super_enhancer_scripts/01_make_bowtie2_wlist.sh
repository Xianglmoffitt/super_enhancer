#!/bin/bash

# make bowtie2 work list (wlist) for parallel.sh

# set directories

export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/se_dataportal/NCI_60"
export PAIR_FASTQ_DIR="$PROJECT_DIR/fastq"
export SINGLE_FASTQ_DIR="$PROJECT_DIR/fastq"
export PAIR_FILE_LIST="$PROJECT_DIR/sra_id_paired"
export SINGLE_FILE_LIST="$PROJECT_DIR/sra_id_single"
export BOWTIE_INDEX="/share/lab_teng/xiangliu/hg38_bowtie2_index/HG38_chr"

export OUT_DIR="$PROJECT_DIR/bowtie_out"
export LOG_DIR="$PROJECT_DIR/bowtie_log"
export WLIST_DIR="$PROJECT_DIR/"
export WLIST_FILE="$WLIST_DIR/01_bowtie2_wlist"

# creat bowtie2 paired-end parallel wlist (bowtie2 default setting)
while read P_FILE; do

	echo "(bowtie2 -p 2 -x $BOWTIE_INDEX -1 $PAIR_FASTQ_DIR/"$P_FILE"_1.fastq.gz -2 $PAIR_FASTQ_DIR/"$P_FILE"_2.fastq.gz -S $OUT_DIR/"$P_FILE".sam) 2>>$LOG_DIR/"$P_FILE".log" >> $WLIST_FILE

done < $PAIR_FILE_LIST

# creat bowtie2 single-end parallel wlist (bowtie2 default setting)
while read S_FILE; do 

	echo "(bowtie2 -p 2 -x $BOWTIE_INDEX -U $SINGLE_FASTQ_DIR/"$S_FILE".fastq.gz -S $OUT_DIR/"$S_FILE".sam) 2>>$LOG_DIR/"$S_FILE".log" >> $WLIST_FILE

done < $SINGLE_FILE_LIST

