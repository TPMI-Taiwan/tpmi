# tpmi
## 1. Phenotyping
### 1.1 Diseases and symptoms (phecode: https://phewascatalog.org/)
### 1.2 Anthropometric and laboratory measurements
## 2. Genotyping QC and imputation 
See 2.2-Imputation: `phasing.sh` and `imputation.sh`
## 3. Genome-wide association study
### 3.1 PCAir, PCRelate, and PRIMUS (GENESIS: https://bioconductor.org/packages/release/bioc/html/GENESIS.html; PRIMUS: https://primus.gs.washington.edu/primusweb/)
### 3.2 Generalized linear mixed model (SAIGE: https://saigegit.github.io/SAIGE-doc/)
See 3.2-SAIGE_GWAS: `SAIGE.sh` and `SAIGE_qtrait.sh`
### 3.3 Generalized linear model (PLINK2: https://www.cog-genomics.org/plink/2.0/)
See 3.3-PLINK_GWAS: `plink_for_ldsc.sh`
## 4. Post GWAS analysis
### 4.1 Known loci replication (PGRM: https://github.com/PheWAS/pgrm)
See 4.1-PGRM: `PGRM.R`
### 4.2 Fine-mapping (SuSiE: https://stephenslab.github.io/susieR/index.html) 
See 4.2-FineMapping: `fine-mapping.sh`
### 4.3 Heritability estimation (LDSC: https://github.com/bulik/ldsc, LSH: https://github.com/svenojavee/LSH )
See 4.3-Heritability: `LDSC.sh` and `LSH.R`
### 4.4 Gene-level heritability estimation (h2gene: https://github.com/bogdanlab/h2gene )
See 4.4-GeneHeritability: `H2Gene.sh`
### 4.5 Colocalization (with eQTL and pairwise, coloc: https://chr1swallace.github.io/coloc/index.html, GTEx v.8: https://gtexportal.org/ )
See 4.5-Colocalization: `Coloc.R`
### 4.6 Genetic correlation and Clustering (LDSC: phenome-wide; popcorn: across populations https://github.com/brielin/Popcorn)
See 4.6-GeneticCorrelation: `genetic_correlation.sh` and `popcorn.sh`
## 5. PRS
### 5.1 Individual phenotype (LDPred2, Lassosum2, PRScs, MegaPRS, SBayesR)
See 5.1-PRS: `LDpred2_lassosum2_phecode.R`, `LDpred2_lassosum2_qtrait.R`, `PRScs.sh`, `MegaPRS.sh` and `SBayesR.sh`
### 5.2 Mult-phenotype (PRSmix: https://github.com/buutrg/PRSmix)
See 5.2-MultiPRS: `run_PRSmix_by_phecode.R`
### 5.3 Performance evaluation (R^2 and AUC)
See 5.3-Performance: `calc_auc.py` and `calc_r2.R`
