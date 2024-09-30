library(susieR)
library(h2geneR)
library(matrixStats)
library(data.table)

args = commandArgs(trailingOnly=TRUE)

trait <- args[1]
c <- as.integer(args[2])
s <- as.integer(args[3])
e <- as.integer(args[4])

gwas_path <- paste0("saige_output.", trait, ".tsv")
output_path <- paste0("h2gene_output/", trait, "/", trait, ".chr", c, ".", s, "_", e, ".h2gene.tsv")
ld_path <- paste0("LD/chr", c, "/chr", c, ".", s, "_", e, ".phased.vcor1")

X <- fread(gwas_path, data.table = F)
X <- X[which(X$CHR == c & X$POS >= s & X$POS <= e),]
N <- X$N_case[1] + X$N_ctrl[1]
X <- X[,c(3, 1, 2, 4, 5, 7, 9, 10, 13)]
colnames(X) <- c("rsid", "chromosome", "position", "allele1", "allele2", "maf", "beta", "se", "p")

if (dim(X[which(X$p < 1e-5),])[1] > 0){
  gene_region <- fread("gencode.v26.GRCh38.genes.body.tsv", data.table = F)
  region <- gene_region[which(gene_region$chr == paste0("chr", c) & gene_region$start >= s & gene_region$end <= e),]
  inregion <- function(x, gene){
    pos <- as.integer(strsplit(x, split = "_")[[1]][2])
    if( (pos >= region[which(region$geneID == gene), 3]) & (pos <= region[which(region$geneID == gene), 4]) ){
      T
    }else{
      F
    }
  }
  if(dim(region)[1] == 1){
    anno <- matrix(sapply(X$rsid, function(x) sapply(region$geneID, function(r) inregion(x, r))))
  }else{
    anno <- t(sapply(X$rsid, function(x) sapply(region$geneID, function(r) inregion(x, r))))
  }
  
  ld <- fread( paste0(ld_path, ".ld.gz"), data.table = F)
  colnames(ld) <- fread( paste0(ld_path, ".vars"), data.table = F, header = F)$V1
  rownames(ld) <- fread( paste0(ld_path, ".vars"), data.table = F, header = F)$V1
  ld <- as.matrix(ld[X$rsid, X$rsid])
  susie_fitted <- susie_rss(bhat = X$beta, shat = X$se, R=ld, n = N)
  res <- h2gene(susie_fitted, ld=ld, annot=anno)
  
  # summarize h2gene results
  print("Mean of heritability estimates across posterior samples:")
  print(colMeans(res$hsq))
  
  print("Standard deviations:")
  print(colSds(res$hsq))
  
  hsq_df <- data.frame(H2GENE_ALL_MEAN = colMeans(res$hsq), H2GENE_ALL_SD = colSds(res$hsq), H2GENE_Ncausal_MEAN = colMeans(res$ncausal))
  write.table(hsq_df, output_path, sep = "\t", quote = F)
  
}else{
  print("This region has no p-value < 1e-5")
}
