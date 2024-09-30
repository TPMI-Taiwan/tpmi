#!/bin/Rscript

library(data.table)
library(coloc)

args <- commandArgs(trailingOnly=TRUE)

gene <- args[1]
phecode <- args[2]
tissue <- args[3]

chr_gene <- read.table("gene_pos.list", sep = "\t", header = F)
chr <- gsub("chr", "", chr_gene[which(chr_gene$V3 == gene), 1])

## read GWAS phecode-gene pair results
data1 <- fread(paste0("coloc_input/GWAS/chr", chr, "/", phecode, "_", gene, ".txt"), data.table = F, header = T)
ld <- fread(paste0("coloc_input/LD/chr", chr, "/", gene, ".phased.vcor1.ld.gz"), data.table = F, header = F)
ld_var <- fread(paste0("coloc_input/LD/chr", chr, "/", gene, ".phased.vcor1.vars"), data.table = F, header = F)$V1
colnames(ld) <- ld_var
rownames(ld) <- ld_var
data1$N <- data1$N_case + data1$N_ctrl
data1$varbeta <- data1$SE * data1$SE
d1 <- list(data1$BETA, data1$varbeta, data1$MarkerID, as.matrix(ld[data1$MarkerID, data1$MarkerID]), data1$N[1], "cc")
names(d1) <- c("beta", "varbeta", "snp", "LD", "N", "type")
s1 <- runsusie(d1)

## read GTEx tissue-gene pair results
gtexn <- read.table("GTEx_samplesN.list", header = T)
data3 <- fread(paste0("coloc_input/GTEx/chr", chr, "/", tissue, "_", gene, ".txt.gz"), data.table = F, header = T)
data3$MarkerID <- gsub("_b38", "", data3$variant_id)
data3$N <- gtexn[which(gtexn$Tissue == tissue), "Samples"]    ## extract N from paper table S2
data3$varbeta <- data3$slope_se * data3$slope_se
data3 <- data3[!is.na(data3$slope_se),]
ld_1kg <- fread(paste0("coloc_input/1kG_ld/chr", chr, "/", gene, ".phased.vcor1.ld.gz"), data.table = F, header = F)
ld_1kg_var <- fread(paste0("coloc_input/1kG_ld/chr", chr, "/", gene, ".phased.vcor1.vars"), data.table = F, header = F)$V1
colnames(ld_1kg) <- ld_1kg_var
rownames(ld_1kg) <- ld_1kg_var

overlap_ID <- intersect(colnames(ld_1kg), data3$MarkerID)
data3 <- data3[which(data3$MarkerID %in% overlap_ID),]
d3 <- list(data3$slope, data3$varbeta, data3$MarkerID, as.matrix(ld_1kg[overlap_ID, overlap_ID]), data3$N[1], "quant", 1)
names(d3) <- c("beta", "varbeta", "snp", "LD", "N", "type", "sdY")
s3 <- runsusie(d3)

if(requireNamespace("susieR",quietly=TRUE)) {
  susie.res <- coloc.susie(s1,s3)
}
susie.res$summary
susie.res$summary
write.csv(susie.res$summary, paste0("coloc_output/chr", chr, "/", gene, "_", phecode, "_", tissue, ".txt"), row.names = F, quote = F)
