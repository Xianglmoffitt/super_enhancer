setwd("~/Projects/super_enhancer/derek_chip_seq/")


library(tidyr)
library(plyr)
library(dplyr)
library(tibble)
library(ggplot2)
library(data.table)
library(GenomicRanges)

# rose SE output table
rna_deseq <- read.table("rna-seq/CICPT_1979_RNAseq_July2019-srnrg3.txt",sep = "\t",header=T)
bt474_mut_gene <- read.table("BT474_mutations_genes.txt",sep='\t', header =F)

se_compare <- read.table("SR_BUP_output/se_compare_result.txt",header=T)
se_meta <- read.table("SR_BUP_output/se_meta.txt",sep = "\t",header=T)
#------------------------------------------------------------------------------
# extract gene range
#------------------------------------------------------------------------------
# extract significant SE
se_significant <- se_compare[which(se_compare$category != "Similar"),]

extract_se <- se_meta[se_meta$se_merge_name %in% se_significant$se_merge_name,]
extract_se$mid <- extract_se$start+extract_se$width/2

# extract gene
rna_deseq_target <- rna_deseq[,c(1:10,23:26)]
extracted_mut_gene <- rna_deseq_target[rna_deseq_target$gene_name %in% bt474_mut_gene$V1, ]
extracted_mut_gene$mid <- extracted_mut_gene$start+
                          (extracted_mut_gene$end-extracted_mut_gene$start+1)/2


# full gene
extracted_mut_gene <- rna_deseq_target
extracted_mut_gene$mid <- extracted_mut_gene$start+
  (extracted_mut_gene$end-extracted_mut_gene$start+1)/2

# create dataframe of SE contain genes within in 2M distance
sig_w_mut_gene <- data.frame()
se_name <- extract_se$se_merge_name
for (i in c(1:length(se_name))) {
  temp_df <- extracted_mut_gene[which(abs(extract_se$mid[i]-extracted_mut_gene$mid)<=1000000 &
                                        extract_se$chr[i] == extracted_mut_gene$chrom),]
  temp_df$se_merge_name <- rep(extract_se$se_merge_name[i],nrow(temp_df))
  sig_w_mut_gene <- rbind(sig_w_mut_gene,temp_df)
}

final_out <- merge(sig_w_mut_gene,se_compare,by="se_merge_name")
write.table(final_out,file = "summary/sig_w_all_gene.txt",sep='\t',
            row.names = FALSE,quote = FALSE)

# check gene_fc
#rna_deseq_target[which(rna_deseq_target$gene_name == "KCNB1"),]$SR4835.DMSO.lfc
