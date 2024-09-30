library(data.table)
info <- fread("Phecode_pop_prevalence.csv", data.table =F, colClasses = c("Phecode"="character"))
phe_list <- info$Phecode

LSH_ascertain <- function(h2Obs,P,K){
  tP <- qnorm(P)
  tK <- qnorm(K)
  z <- dnorm(tK)
  xx <- h2Obs
  a1 <- 0
  a2 <- 1
  it <- 1
  while(abs(a2-a1) > 0.00000001){
    it <- it+1
    res <- h2Obs * (xx * z**2 + K - pbivnorm::pbivnorm(tK,tK,xx))**2 / z**2 * (1/(P*(1-P))) - xx

    if(res > 0){ #Find the solution from between xx and a2
      a1 <- xx
      xx <- 0.5*(a2 + xx)
    }
    if(res < 0){
      a2 <- xx
      xx <- 0.5*(a1 + xx)
    }
    if(it > 100){
      print("Has not converged in 100 steps")
      return(xx)
    }
  }

  return(xx)
}

calR2 <- function(path, phe_list, phi_df=NULL){
  all_res <- NULL
  for(i in phe_list){
    df <- fread(paste0(path, "/Pheno_PRS/", i, "_pheno_cov_score.csv"))
    df$std_y <- scale(df$pheno)
    pop <- info[which(info$Phecode == i), 4]
    gwas <- info[which(info$Phecode == i), 5]

    lmnull <- glm(formula = pheno~1, data = df, family = binomial())
    lmprs <- glm(formula = pheno~Total, data = df, family = binomial())
    lmPC <- glm(formula = pheno~PCAiR1+PCAiR2+PCAiR3+PCAiR4+PCAiR5+PCAiR6+PCAiR7+PCAiR8+PCAiR9+PCAiR10,
               data = df, family = binomial())
    lmprs_PC <- glm(formula = pheno~Total+PCAiR1+PCAiR2+PCAiR3+PCAiR4+PCAiR5+PCAiR6+PCAiR7+PCAiR8+PCAiR9+PCAiR10,
                   data = df, family = binomial())
    lmprs_full <- glm(formula = pheno~Total+gender_code+site+array+PCAiR1+PCAiR2+PCAiR3+PCAiR4+PCAiR5+PCAiR6+PCAiR7+PCAiR8+PCAiR9+PCAiR10+
                     age_standardize+age_square_standardize+age_gender+age_square_gender+log10_records,
                     data = df, family = binomial())
    R2prs_null <- 1-exp((2/ dim(df)[1] )*(logLik(lmnull)-logLik(lmprs)))
    R2prsPC_PC <- 1-exp((2/ dim(df)[1] )*(logLik(lmPC)-logLik(lmprs_PC)))
    R2prsPC_null <- 1-exp((2/ dim(df)[1] )*(logLik(lmnull)-logLik(lmprs_PC)))
    R2prsfull_null <- 1-exp((2/ dim(df)[1] )*(logLik(lmnull)-logLik(lmprs_full)))

    LSH_R2prs_null <- LSH_ascertain(R2prs_null, gwas, pop)
    LSH_R2prsPC_PC <- LSH_ascertain(R2prsPC_PC, gwas, pop)
    LSH_R2prsPC_null <- LSH_ascertain(R2prsPC_null, gwas, pop)
    LSH_R2prsfull_null <- LSH_ascertain(R2prsfull_null, gwas, pop)
    res <- data.frame(matrix(nrow = 1, data = c(i, LSH_R2prs_null, LSH_R2prsPC_PC, LSH_R2prsPC_null, LSH_R2prsfull_null) ) )
    colnames(res) <- c("Phecode", "R2_raw", "R2_adjPC", "R2_addPC", "R2_Full")
    if(is.null(all_res)){
      all_res <- res
    }else{
      all_res <- rbind(all_res, res)
    }
  }
  return(all_res)
}

ldpred2_res <- calR2(ldpred2_path, phe_list)
