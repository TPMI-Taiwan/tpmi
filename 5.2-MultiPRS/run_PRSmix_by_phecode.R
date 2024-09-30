#!/bin/R

library(PRSmix)
args <- commandArgs(trailingOnly=TRUE)
group <- args[1]
i <- args[2] ## phecode
print(paste0("Start running", i))

check_sex <- fread( paste0(group, "/Covariates/", i, "_cov.tsv"), data.table = F )
if( length( unique(check_sex$gender_code) ) == 2 ){
	phe_file = paste0(group, "/Pheno/", i, "_pheno.tsv")
        cov_file = paste0(group, "/Covariates/", i, "_cov.tsv")
        spe_file = paste0(group, "/CombinationList/", i, "_all.list")
        out_prefix = paste0(group, "/Output_all/", i)
        combine_PRS(pheno_file = phe_file, 
		    covariate_file = cov_file, 
		    score_files_list = c(paste0(group, "/Score/Allpgs.sscore")),
		    pheno_name = "Pheno",
		    trait_specific_score_file = spe_file,
		    isbinary = TRUE,
		    out = out_prefix,
		    liabilityR2 = TRUE,
		    IID_pheno = "IID",
		    covar_list = c("age_standardize", "age_square_standardize", "age_gender", "age_square_gender", "gender_code", "array", "log10_records", "PCAiR1", "PCAiR2", "PCAiR3", "PCAiR4", "PCAiR5", "PCAiR6", "PCAiR7", "PCAiR8", "PCAiR9", "PCAiR10"),
		    cat_covar_list = c("gender_code", "array"),
		    ncores = 40,
		    is_extract_adjSNPeff = TRUE,
		    original_beta_files_list = paste0(group, "/all.weights"),
		    train_size_list = NULL,
		    read_pred_training = FALSE,
		    read_pred_testing = FALSE )
}else{
	phe_file = paste0(group, "/Pheno/", i, "_pheno.tsv")
        cov_file = paste0(group, "/Covariates/", i, "_cov.tsv")
        spe_file = paste0(group, "/CombinationList/", i, "_all.list")
        out_prefix = paste0(group, "/Output_all/", i)
        combine_PRS(pheno_file = phe_file,
                    covariate_file = cov_file,
                    score_files_list = c(paste0(group, "/Score/Allpgs.sscore")),
                    pheno_name = "Pheno",
                    trait_specific_score_file = spe_file,
                    isbinary = TRUE,
                    out = out_prefix,
                    liabilityR2 = TRUE,
                    IID_pheno = "IID",
                    covar_list = c("age_standardize", "age_square_standardize", "array", "log10_records", "PCAiR1", "PCAiR2", "PCAiR3", "PCAiR4", "PCAiR5", "PCAiR6", "PCAiR7", "PCAiR8", "PCAiR9", "PCAiR10"),
                    cat_covar_list = c("array"),
                    ncores = 40,
                    is_extract_adjSNPeff = TRUE,
                    original_beta_files_list = paste0(group, "/all.weights"),
                    train_size_list = NULL,
                    read_pred_training = FALSE,
                    read_pred_testing = FALSE )
}
