#!/bin/bash

#PBS -N SR4835_BUP
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=5,mem=10gb
#PBS -m bea
#PBS -M Xiang.Liu@moffitt.org


# run job parallelly on HPC using GNU parallel tool

export PROJECT_DIR="/share/lab_teng/xiangliu/super_enhancer/derek_chip"
export DATA_DIR="/share/lab_teng/data/derek_bc_h3k27ac"
export R1_DATA="$DATA_DIR/07_08I3_0166Moffitt_SR-4835-BUP-1_H3K27Ac_hg38_i52.bam"
export R2_DATA="$DATA_DIR/08_08I4_0166Moffitt_SR-4835-BUP-2_H3K27Ac_hg38_i53.bam"
export INPUT_DATA="$DATA_DIR/12_084W_012IMoffitt_SR-4835-BUPARLISIB_Input_hg38_i88.bam"
export MAC_OUTDIR="$PROJECT_DIR/macs_out"
export ROSE_OUTDIR="$PROJECT_DIR/rose_out"
export ROSE_DIR="/home/4472271/rose"
#export BOWTIE_INDEX="/share/lab_teng/xiangliu/hg19_bowtie2_index/hg19_chr"
export SCRIPT_DIR="/share/lab_teng/xiangliu/super_enhancer/scripts/super_enhancer_scripts"

cd $PROJECT_DIR

module load R/3.6.3
module load macs/2.1.0
module load samtools
module load bowtie2

# step 1: bowtie2
#bowtie2 -p 4 -x $BOWTIE_INDEX -U $PROJECT_DIR/fastq/BC1_chip_1_trimmed.fq -S $PROJECT_DIR/data/BC1_1.sam

#bowtie2 -p 4 -x $BOWTIE_INDEX -U $PROJECT_DIR/fastq/BC1_chip_2_trimmed.fq -S $PROJECT_DIR/data/BC1_2.sam

#bowtie2 -p 4 -x $BOWTIE_INDEX -U $PROJECT_DIR/fastq/BC1_input_trimmed.fq -S $PROJECT_DIR/data/BC1_input.sam

# step 2: sam to sort-bam, rmdup bam and index final bam
#$SCRIPT_DIR/02_sam_to_sort_bam.py -i $PROJECT_DIR/data/BC1_1.sam -od $PROJECT_DIR/data -o BC1_1 

#$SCRIPT_DIR/02_sam_to_sort_bam.py -i $PROJECT_DIR/data/BC1_2.sam -od $PROJECT_DIR/data -o BC1_2

#$SCRIPT_DIR/02_sam_to_sort_bam.py -i $PROJECT_DIR/data/BC1_input.sam -od $PROJECT_DIR/data -o BC1_input

# step 3: macs2

macs2 callpeak -g hs -t $R1_DATA -c $INPUT_DATA -f BAM -n SR4835_BUP_1 --bdg --outdir $MAC_OUTDIR 2> $MAC_OUTDIR/SR4835_BUP_1_log

macs2 callpeak -g hs -t $R2_DATA -c $INPUT_DATA -f BAM -n SR4835_BUP_2 --bdg --outdir $MAC_OUTDIR 2> $MAC_OUTDIR/SR4835_BUP_2_log

# step 4: ROSE
# make rose gff
awk '{print $1"\t"$4"\t""\t"$2"\t"$3"\t""\t"$6"\t""\t"$4}' $MAC_OUTDIR/SR4835_BUP_1_peaks.narrowPeak > $MAC_OUTDIR/SR4835_BUP_1_peaks.gff

awk '{print $1"\t"$4"\t""\t"$2"\t"$3"\t""\t"$6"\t""\t"$4}' $MAC_OUTDIR/SR4835_BUP_2_peaks.narrowPeak > $MAC_OUTDIR/SR4835_BUP_2_peaks.gff

# run rose
cd $ROSE_DIR
python ROSE_main.py -g HG38 -i $MAC_OUTDIR/SR4835_BUP_1_peaks.gff -r $R1_DATA -c $INPUT_DATA -o $ROSE_OUTDIR

python ROSE_main.py -g HG38 -i $MAC_OUTDIR/SR4835_BUP_2_peaks.gff -r $R2_DATA -c $INPUT_DATA -o $ROSE_OUTDIR

# step 5: bdg to bw
# sort bdg
sort -k1,1 -k2,2n $MAC_OUTDIR/SR4835_BUP_1_treat_pileup.bdg > $MAC_OUTDIR/SR4835_BUP_1_sorted_treat_pileup.bdg

sort -k1,1 -k2,2n $MAC_OUTDIR/SR4835_BUP_2_treat_pileup.bdg > $MAC_OUTDIR/SR4835_BUP_2_sorted_treat_pileup.bdg

