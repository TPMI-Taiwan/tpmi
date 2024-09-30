library(pgrm)
library(data.table)
#setwd("/path/to/saige_tpmi037/")
phe_list <- read.table("SAIGE/phecode.list", colClasses = c("character"))

read_saige <- function(phe){
  d <- fread(paste0("SAIGE/saige_ouptut.", phe, ".tsv"), data.table = F)
  d <- d[which(d$rsID %in% PGRM$rsID[which(PGRM$phecode == phe)]),]
  if(dim(d)[1] != 0){
    d$Phecode <- phe
    d
  }
}

summary_list <- lapply(phe_list$V1, read_saige)
all_summary <- do.call(rbind, lapply(phe111_list$V1, read_saige))
nglmm <- read.table("SAIGE/All_N.tsv", colClasses = c("Phecode"="character"), header = T)
all_data <- merge(all_summary, nglmm, by = "Phecode")
PGRM_snp <- unique(data.frame(PGRM[,c(2,4)]))
all_data <- merge(all_data, PGRM_snp, by = "rsID")

sapply(all_data$SNP[1:5], function(x) strsplit(x, ":"), '[', 4)
all_data$EffectAllele <- sapply(strsplit(all_data$SNP, ':'), '[', 4)
all_data$odds_ratio <- exp(all_data$Beta)
all_data$L95 <- exp( (all_data$Beta - 1.96*all_data$SE ) )
all_data$U95 <- exp( (all_data$Beta + 1.96*all_data$SE ) )
all_data <- all_data[,c("SNP", "Phecode", "N_case", "N_ctrl", "odds_ratio", "p.value", "L95", "U95", "Nglmm")]
colnames(all_data) <- c('SNP','phecode','cases','controls','odds_ratio','P', "L95", "U95", "N")
all_data$P <- as.numeric(all_data$P)

anno_EAS <- annotate_results(all_data, ancestry = 'EAS', build = 'hg38', calculate_power = TRUE, LOUD = FALSE)
get_RR(anno_EAS) ## filter power>80%
get_RR(anno_EAS,include='all') ## 
get_AER(anno_EAS, LOUD = TRUE)
anno_EAS$rep_powered <- ifelse( (anno_EAS$rep == 1 & anno_EAS$powered == 1), 1, 0)
EAS_by_pheno_cat <- anno_EAS[,.(total_tested = .N, replicated = sum(rep), AER = sum(rep) / sum(Power), RR = sum(rep_powered) / sum(powered)  ), 
                             by=c('category_string')]
EAS_by_phecode <- anno_EAS[,.(total_tested = .N, replicated = sum(rep), AER = sum(rep) / sum(Power), RR = sum(rep_powered) / sum(powered)  ), 
                             by=c('phecode')]
