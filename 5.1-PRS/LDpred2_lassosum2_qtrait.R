library(bigsnpr)
library(ggplot2)
library(dplyr)
library(data.table)

options(bigstatsr.check.parallel.blas = FALSE)

args = commandArgs(trailingOnly=TRUE)
phecode <- args[1]
pheno.file <- args[2]
sumstats.file <- args[3]
cores <- 60

(NCORES <- cores)

print(paste0("[LOG] phecode = ", phecode))
print(paste0("[LOG] pheno file = ", pheno.file))
print(paste0("[LOG] gwas file = ", sumstats.file))

wd <- paste0(getwd(),'/',phecode,'/')
dir.create(wd)

obj.bigSNP <- snp_attach("training.rds")
str(obj.bigSNP, max.level = 2, strict.width = "cut")

pheno <- fread(pheno.file, data.table=FALSE)
sample <- fread('training.sample', data.table=FALSE)
sample <- sample[-1,]
sample_pheno <- merge(x=sample, y=pheno, by.x="ID_2", by.y="IID", all.x=TRUE)
sample_pheno_order <- sample_pheno[match(sample$ID_2,sample_pheno$ID_2),]
write.table(sample_pheno[,c('ID_1','pheno')], paste0(wd, phecode, '_train_pheno.txt'), sep="\t", col.names = F, row.names = F, quote = F)

obj.bigSNP$map <- as.data.frame(obj.bigSNP$map)
obj.bigSNP$map$chromosome <- as.integer(obj.bigSNP$map$chromosome)

G   <- obj.bigSNP$genotypes
CHR <- obj.bigSNP$map$chromosome
POS <- obj.bigSNP$map$physical.pos
y <- sample_pheno_order$pheno

#### GWAS data ####
sumstats.raw <- bigreadr::fread2(sumstats.file)
print("[LOG] keep hm3 snps...")
hm3 <- readRDS('map_hm3_plus.rds')
colnames(hm3)[colnames(hm3) == "chr"] ="CHR"
colnames(hm3)[colnames(hm3) == "pos_hg38"] ="POS"
sumstats <- merge(sumstats.raw, hm3[,c('CHR','POS')], by=c('CHR','POS'))
print("[LOG] sumstats after intersect with hm3...")
dim(sumstats)

sumstats <- sumstats[!grepl('Aff', sumstats$MarkerID),]
colnames(sumstats) <- c("chr", "pos", "id", "a0", "a1", "ac", "freq", "info", "beta", "beta_se", "tstat", "var", "p", "N", "rs")
sumstats <- sumstats[which(!is.na(sumstats$p)),]
print("[LOG] sumstats after remove row which p value is NA...")
str(sumstats)

### effect N
### meta: in the case of a meta-analysis, you should sum the effective sample sizes of each study instead of using the total numbers of cases and controls
sumstats$n_eff <- sumstats$N

### match snp between gwas & array
map <- setNames(obj.bigSNP$map[-2], c("chr", "markerID", "pos", "a0", "a1", "freqency", "Info"))
info_snp <- snp_match(sumstats, map)
df_beta <- info_snp[order(info_snp$"_NUM_ID_"),]

### To convert physical positions (in bp) to genetic positions (in cM)
POS2 <- snp_asGeneticPos(CHR, POS, dir = "OMNI_genemap/.", ncores = NCORES)
### Correlation Matrix
print("[LOG] Correlation matrix by chr...")
tmp <- tempfile(tmpdir = paste0(wd, 'tmp'))
for (chr in 1:22) {
  print(chr)
  ## indices in 'df_beta'
  ind.chr <- which(df_beta$chr == chr)
  ## indices in 'G'
  ind.chr2 <- df_beta$`_NUM_ID_`[ind.chr]
  corr0 <- snp_cor(G, ind.col = ind.chr2, size = 3 / 1000, infos.pos = POS2[ind.chr2], ncores = NCORES)
  if (chr == 1) {
     ld <- Matrix::colSums(corr0^2)
     corr <- as_SFBM(corr0, tmp, compact = TRUE)
   } else {
     ld <- c(ld, Matrix::colSums(corr0^2))
     corr$add_columns(corr0, nrow(corr))
   }
}

fs <- file.size(corr$sbk) / 1024^3
print(paste0("[LOG] memory needed by corr. matrix (G): ", fs))

### LDpred2 Algorithm
## LD Score regression
print("[LOG] LD Score regression... ")
ldsc <- with(df_beta, snp_ldsc(ld, length(ld), chi2 = (beta / beta_se)^2, sample_size = n_eff, blocks = NULL, ncores = NCORES))
ldsc_h2_est <- ldsc[["h2"]]

## test multiple values for h2 and p
h2_seq <- round(ldsc_h2_est * c(0.3, 0.7, 1, 1.4), 4)
## h2_seq <- signif(seq_log(0.005, 0.1, 4), 3) ### for LDL


p_seq <- signif(seq_log(1e-5, 1, length.out = 21), 2)
params <- expand.grid(p = p_seq, h2 = h2_seq, sparse = c(FALSE, TRUE))

## ldpred2
set.seed(1)  # to get the same result every time
print("[LOG] do snp_ldpred2_grid... ")
beta_grid <- snp_ldpred2_grid(corr, df_beta, params, ncores = NCORES)

print("[LOG] do big_prodMat to get pred_grid ... ")
print('dim of G:')
dim(G)
print('dim of beta_grid:')
dim(beta_grid)
print(paste0('len of ind.col: ',length(df_beta[["_NUM_ID_"]])))
pred_grid <- big_prodMat(G, beta_grid, ind.col = df_beta[["_NUM_ID_"]])

print("[LOG] find best model... ")

y2 <- y[which(!is.na(y))]
pred_grid_y2 <- pred_grid[which(!is.na(y)),]

params$score <- apply(pred_grid_y2, 2, function(x) {
  if (all(is.na(x))) return(NA)
       summary(lm(y2 ~ x))$coef["x", 3]
})

params

print("[LOG] plot... ")
plot1 <- ggplot(params, aes(x = p, y = score, color = as.factor(h2))) +
	theme_bigstatsr() +
	geom_point() +
	geom_line() +
	scale_x_log10(breaks = 10^(-5:0), minor_breaks = params$p) +
	facet_wrap(~ sparse, labeller = label_both) +
	labs(y = "GLM Z-Score", color = "h2") +
	theme(legend.position = "top", panel.spacing = unit(1, "lines"))

png(paste0(wd, phecode, '_ld_model.png'))
print(plot1)
dev.off()


params %>%
	mutate(sparsity = colMeans(beta_grid == 0), id = row_number()) %>%
	arrange(desc(score)) %>%
	mutate_at(c("score", "sparsity"), round, digits = 3) %>%
	slice(1:10)

best_beta_grid <- params %>%
	mutate(id = row_number()) %>%
	arrange(desc(score)) %>%
	slice(1) %>%
	print() %>% 
	pull(id) %>% 
	beta_grid[, .]

info_snp$LDPred2weight <- best_beta_grid

### lassosum2: grid of models
beta_lassosum2 <- snp_lassosum2(corr, df_beta, ncores = NCORES)
(params2 <- attr(beta_lassosum2, "grid_param"))
pred_grid2 <- big_prodMat(G, beta_lassosum2, ind.col = df_beta[["_NUM_ID_"]])

pred_grid2_y2 <- pred_grid2[which(!is.na(y)),]
params2$score <- apply(pred_grid2_y2, 2, function(x) {
       if (all(is.na(x))) return(NA)
       summary(lm(y2 ~ x))$coef["x", 3]
})

plot2 <- ggplot(params2, aes(x = lambda, y = score, color = as.factor(delta))) +
	theme_bigstatsr() +
	geom_point() +
	geom_line() +
	scale_x_log10(breaks = 10^(-5:0)) +
	labs(y = "GLM Z-Score", color = "delta") +
	theme(legend.position = "top") +
	guides(colour = guide_legend(nrow = 1))

png(paste0(wd, phecode, '_lasso_model.png'))
print(plot2)
dev.off()


best_grid_lassosum2 <- params2 %>%
	mutate(id = row_number()) %>%
	arrange(desc(score)) %>%
	print() %>% 
	slice(1) %>%
	pull(id) %>% 
	beta_lassosum2[, .]
  
best_grid_overall <- 
	`if`(max(params2$score, na.rm = TRUE) > max(params$score, na.rm = TRUE),
	     best_grid_lassosum2, best_beta_grid)

info_snp$lassosum2weight <- best_grid_lassosum2
write.table(info_snp, paste0(wd, phecode,'_weight_all.txt'), sep="\t", row.names = F, quote = F)

w=merge(x=obj.bigSNP$map, y=info_snp, by.x='marker.ID', by.y='id', all.x=TRUE)
write.table(w[,c('markerID','a1','LDPred2weight','lassosum2weight')], paste0(wd, phecode,'_weight.txt'), sep="\t", col.names = c('snp','a1', phecode, paste0(phecode,'_lasso')), row.names = F, quote = F )
