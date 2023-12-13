#!/bin/bash

# run bedtobw

# set directories
export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/encode_v2"
export MACS_INPUT_LIST="$PROJECT_DIR/exp_macs_id"
export CHROM_SIZE="$PROJECT_DIR/hg38.chrom.sizes"

# loop each sample
cd $PROJECT_DIR
while read EXP; do
	BDG_IN="$PROJECT_DIR/macs2_out/$EXP/"$EXP"_sorted_treat_pileup.bdg"
	BW_OUT="$PROJECT_DIR/macs2_out/$EXP/"$EXP".bw"

	bedGraphToBigWig $BDG_IN $CHROM_SIZE $BW_OUT

done < $MACS_INPUT_LIST
