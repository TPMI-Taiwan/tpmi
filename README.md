## 1. Phenotyping
Disease was defined by [phecodes](https://phewascatalog.org/). Quantitative traits were extracted from the EMR, including anthropometric, vital signs and laboratory measurements. The flow charts of quality control for quantitative traits can see [here](1-Phenotyping).

## 2. Genotyping QC and imputation 
    
### 2.1 Genotyping QC
#### Initial QC by batch
* QC by batch (`01_qc_by_batch/01_exe.sh`)
  * Remove SNPs with missing rate > 10%
  * Remove individuals with missing rate > 10%
  * Remove SNPs with missing rate > 5%
* Identify SNPs with the largest difference in missing rate > 0.02 between any two batches. (`02_snp_missing_diff/02_exe.sh`)
* Identify SNPs with difference in allele frequency > 0.1 between any two batches. (`03_snp_freq/03_exe_freq.sh`)

#### Merge batches and basic QC
* Merge batches from `01_qc_by_batch`, then remove SNPs identified in `02_snp_missing_diff` and `03_snp_freq`. (`04_merge/04_exe_uniq.sh`)
* QC after merge (`05_merge_qc/05_exe.sh`)
  * Remove TPMI special SNPs
  * Remove duplicated SNPs
  * Remove individuals with missing rate > 5%
  * Remove SNPs with missing rate > 2%

#### Population assignment

The EAS (East Asian) population was identified using PCA and the proportion of genetic ancestry was determined using [ADMIXTURE](https://dalexander.github.io/admixture/) with 1000 Genomes Project and SGDP as reference panel.
1. PCA  (`06_pca/06_exe.sh`)
2. QC for the EAS group (`07_eas_pcair/07_exe.sh`)
      * Remove SNPs with missing rate > 2%
      * Remove SNPs with MAF (Minor Allele Frequency) < 0.01
3. Admixture
    * **Establishing a reference**: 2,594 samples from the 1000 Genomes Project and a random set of 3,000 TPMI samples to perform Admixture (repeated 5 times). Samples with exceeding threshold scores, TPM1: > 0.7 and TPM2: > 0.65, in any population was identified as reference panel.  (`08_admixture/ref/08_exe.sh` and `08_admixture/refQ/08_exe_refQ.sh`)
    * **Projection**: Project remaining samples onto the reference to obtain their scores in each population group. (`08_admixture/project_eas/08_exe_project.sh`)
    * **Assignment**: The sample was identified as Han Chinese population if the highest score exceeds 0.4 and the highest score is at least 0.1 higher than the second-highest score.

<img src="https://github.com/TPMI-Taiwan/tpmi-qc/blob/readme-edits/06_pca/pca.PC1PC2.1kg.png" alt="Image" width="450" height="450"><img src="https://github.com/TPMI-Taiwan/tpmi-qc/blob/readme-edits/06_pca/pca.PC1PC2.cut_eas.tpm1.png" alt="Image" width="450" height="450">

#### QC within Han
Script `09_qc_within_han/09_exe.sh`.
  * Basic QC:
      * Remove SNPs with missing rate > 2%
      * Remove SNPs with MAF < 0.01
  * Sex check:
      * Remove samples that fail plink --check-sex test.
      * Remove samples with gender data contradictory to the EMR provided gender
  * Heterozygosity check (F Coefficient):
      * Exclude samples with F score > 0.2 or < -0.2
  * Remove SNPs with MAF < 0.01
  * Retain only SNPs on autosome
  * Remove SNPs that fail HWE test (P-value < 1e-6)
####  Batch GWAS
Script `10_batch_gwas/table.py` and `10_batch_gwas/runPCAir_afterHanQC.sh` and `10_batch_gwas/runPCAir_PCRelate_afterSAIGE.sh`.
* Perform GWAS using [SAIGE](https://saigegit.github.io/SAIGE-doc/) on pairs of batches
    * Remove significant SNPs (p-value < 5e-8) to shrink the batch effects

### 2.2 Imputation
Phasing was conducted with [SHAPEIT5](https://odelaneau.github.io/shapeit5/). Genome imputation was carried out with [IMPUTE5](https://jmarchini.org/software/#impute-5). (`phasing.sh` and `imputation.sh`)

## 3. Genome-wide association study
### 3.1 PC-AiR, PC-Relate, and PRIMUS 
[PC-AiR](https://rdrr.io/bioc/GENESIS/man/pcair.html) and [PC-Relate](https://rdrr.io/bioc/GENESIS/man/pcrelate.html) ([GENESIS](https://bioconductor.org/packages/release/bioc/html/GENESIS.html) package) were used for PCA and relatedness estimation and [PRIMUS](https://primus.gs.washington.edu/primusweb/) was used for identifying the maximum unrelated set. (Script `10_batch_gwas/runPCAir_afterHanQC.sh`, `10_batch_gwas/runPCAir_PCRelate_afterSAIGE.sh` and `11_PRIMUS/11_exe.sh` in `2.1-Genotyping_QC` directory.)

Duplicate pairs (PI_HAT > 0.9) and check with following rule:
1. Different birthday or gender: Remove both (possibly sample misplacement).
2. Same gender and birth:
    * Different hospitals: Keep one (preferably the one with more medical records).
    * Same hospitals: Keep both if the number of medical records is different (considered as twins). If the number of medical records is the same, manually confirm whether they are twins or the same individual.
3. Prioritize retaining samples with medical record data.
4. Pairs that cannot be confirmed are both retained.
5. For known duplicates, prioritize keeping the genotype from the TPM2 array.

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
* MegaPRS (`MegaPRS.sh`)
* [SBayesR](https://cnsgenomics.com/software/gctb/#SBayesRTutorial) (`SBayesR.sh`)

### 5.2 Mult-phenotype
[PRSmix+](https://github.com/buutrg/PRSmix) was performed for the multiple traits PRS model building
(`run_PRSmix_by_phecode.R`)

### 5.3 Performance evaluation
The explained variance (r2) was used to evaluate the performance of PRS for quantitative traits. Two indices, area under the receiver operating characteristic curve (AUC) and liability-scaled r2, were used for PRS of disease. (`calc_auc.py` and `calc_r2.R`)




