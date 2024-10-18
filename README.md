## 1. Phenotyping
Disease was defined by [phecodes](https://phewascatalog.org/). Quantitative traits were extracted from the EMR, including anthropometric, vital signs and laboratory measurements. The flow charts of quality control for quantitative traits can see [here](1-Phenotyping).

## 2. Genotyping QC and imputation 
    
### 2.1 Genotyping QC
The quality control for genotyping can see [here](2.1-Genotyping_QC).

### 2.2 Imputation
Phasing was conducted with [SHAPEIT5](https://odelaneau.github.io/shapeit5/). Genome imputation was carried out with [IMPUTE5](https://jmarchini.org/software/#impute-5). (`phasing.sh` and `imputation.sh`)

## 3. Genome-wide association study
### 3.1 PC-AiR, PC-Relate, and PRIMUS 
[PC-AiR](https://rdrr.io/bioc/GENESIS/man/pcair.html) and [PC-Relate](https://rdrr.io/bioc/GENESIS/man/pcrelate.html) ([GENESIS](https://bioconductor.org/packages/release/bioc/html/GENESIS.html) package) were used for PCA and relatedness estimation and [PRIMUS](https://primus.gs.washington.edu/primusweb/) was used for identifying the maximum unrelated set. (Script `10_batch_gwas/runPCAir_afterHanQC.sh`, `10_batch_gwas/runPCAir_PCRelate_afterSAIGE.sh` and `11_PRIMUS/11_exe.sh` in `2.1-Genotyping_QC` directory.)

### 3.2 Generalized linear mixed model
[SAIGE](https://saigegit.github.io/SAIGE-doc/) was applied for the mixed effect model GWAS (`SAIGE.sh` and `SAIGE_qtrait.sh`).

### 3.3 Generalized linear model
[PLINK2](https://www.cog-genomics.org/plink/2.0/) was applied for the generalized linear model GWAS (`plink_for_ldsc.sh`).

## 4. Post GWAS analysis
### 4.1 Known loci replication 
To evaluate the performance of our GWAS, [PGRM](https://github.com/PheWAS/pgrm) was used to calculate the overall and power-adjusted replication rates and actual over expected ratio.
(`PGRM.R`)
### 4.2 Fine-mapping
[SuSiE](https://stephenslab.github.io/susieR/index.html) was conducted for summary statistics-based fine-mapping.
(`fine-mapping.sh`)
### 4.3 Heritability estimation
[LDSC](https://github.com/bulik/ldsc) and [LSH](https://github.com/svenojavee/LSH) was used to estimate the SNP-based heritability.
(`LDSC.sh` and `LSH.R`)
### 4.4 Gene-level heritability estimation 
[h2gene](https://github.com/bogdanlab/h2gene) analysis was conducted to partition SNP-based heritability to the gene level.
(`H2Gene.sh`)
### 4.5 Colocalization
To examine whether there are shared common genetic causal variants between tissue-specific gene expression and traits of interest. 
[coloc](https://chr1swallace.github.io/coloc/index.html) was used to evaluate colocalization between gene expression and the trait of interest, and expression quantitative traits locus (eQTL) resources from 49 tissues in [GTEx v8](https://gtexportal.org/) were used for testing.
(`Coloc.R`)
### 4.6 Genetic correlation and Clustering (LDSC: phenome-wide; popcorn: across populations )
[LDSC](https://github.com/bulik/ldsc) was performed to obtain pairwise genetic correlations. [Popcorn](https://github.com/brielin/Popcorn) was performed for the cross-population genetic correlation.
( `genetic_correlation.sh` and `popcorn.sh`)

## 5. PRS
### 5.1 Individual phenotype
Five popular PRS tools were used for the single traits PRS model building
* [LDpred2](https://privefl.github.io/bigsnpr/articles/LDpred2.html)  (`LDpred2_lassosum2_phecode.R` and `LDpred2_lassosum2_qtrait.R`)
* [Lassosum2](https://privefl.github.io/bigsnpr/articles/LDpred2.html)
* [PRS-CS](https://github.com/getian107/PRScs) (`PRScs.sh`)
* [MegaPRS](https://dougspeed.com/megaprs/) (`MegaPRS.sh`)
* [SBayesR](https://cnsgenomics.com/software/gctb/#SBayesRTutorial) (`SBayesR.sh`)

### 5.2 Mult-phenotype
[PRSmix+](https://github.com/buutrg/PRSmix) was performed for the multiple traits PRS model building
(`run_PRSmix_by_phecode.R`)

### 5.3 Performance evaluation
The explained variance (r2) was used to evaluate the performance of PRS for quantitative traits. Two indices, area under the receiver operating characteristic curve (AUC) and liability-scaled r2, were used for PRS of disease. (`calc_auc.py` and `calc_r2.R`)




