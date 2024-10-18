## Genotyping QC 
    
### Initial QC by batch
* QC by batch (`01_qc_by_batch/01_exe.sh`)
  * Remove SNPs with missing rate > 10%
  * Remove individuals with missing rate > 10%
  * Remove SNPs with missing rate > 5%
* Identify SNPs with the largest difference in missing rate > 0.02 between any two batches. (`02_snp_missing_diff/02_exe.sh`)
* Identify SNPs with difference in allele frequency > 0.1 between any two batches. (`03_snp_freq/03_exe_freq.sh`)

### Merge batches and basic QC
* Merge batches from `01_qc_by_batch`, then remove SNPs identified in `02_snp_missing_diff` and `03_snp_freq`. (`04_merge/04_exe_uniq.sh`)
* QC after merge (`05_merge_qc/05_exe.sh`)
  * Remove TPMI special SNPs
  * Remove duplicated SNPs
  * Remove individuals with missing rate > 5%
  * Remove SNPs with missing rate > 2%

### Population assignment

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

### QC within Han
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
###  Batch GWAS
Script `10_batch_gwas/table.py` and `10_batch_gwas/runPCAir_afterHanQC.sh` and `10_batch_gwas/runPCAir_PCRelate_afterSAIGE.sh`.
* Perform GWAS using [SAIGE](https://saigegit.github.io/SAIGE-doc/) on pairs of batches
    * Remove significant SNPs (p-value < 5e-8) to shrink the batch effects
 
### Pedigree Reconstruction and Maximum Unrelated Set

**Max unrelated set and Pedigree reconstruction**   

[PC-AiR](https://rdrr.io/bioc/GENESIS/man/pcair.html) and [PC-Relate](https://rdrr.io/bioc/GENESIS/man/pcrelate.html) ([GENESIS](https://bioconductor.org/packages/release/bioc/html/GENESIS.html) package) 
were used for PCA and relatedness estimation and [PRIMUS](https://primus.gs.washington.edu/primusweb/) was used for identifying the maximum unrelated set. 
(Script `10_batch_gwas/runPCAir_afterHanQC.sh`, `10_batch_gwas/runPCAir_PCRelate_afterSAIGE.sh` and `11_PRIMUS/11_exe.sh`)

**Remove Duplicates**

Find duplicate pairs (PI_HAT > 0.9) and check with following rule:
1. Different birthday or gender: Remove both (possibly sample misplacement).
2. Same gender and birth:
   * Different hospitals: Keep one (preferably the one with more medical records).
   * Same hospitals: Keep both if the number of medical records is different (considered as twins). If the number of medical records is the same, manually confirm whether they are twins or the same individual.
3. Prioritize retaining samples with medical record data.
4. Pairs that cannot be confirmed are both retained.
5. For known duplicates, prioritize keeping the genotype from the TPM2 array.
