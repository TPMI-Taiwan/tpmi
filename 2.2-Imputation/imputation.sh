#!/bin/bash

i=$1 ## chromosome
b=$2

bcftools view -S impute_result/batch_list/sample.IMP$b.list phase_result/TPM1_TPM2_Han_phased_chr$i.vcf.gz -Oz -o phase_result/byBatch/IMP$b/TPM1_TPM2_Han_phased_chr$i.$b.vcf.gz --threads 64
tabix phase_result/byBatch/IMP$b/TPM1_TPM2_Han_phased_chr$i.$b.vcf.gz

impute5_v1.1.5/impute5_1.1.5_static \
        --h Imputation_reference_chr$i.vcf.gz \
        --m Phasing_gmap/gmap/chr$i.b38.gmap.gz \
        --g phase_result/byBatch/IMP$b/TPM1_TPM2_Han_phased_chr$i.$b.vcf.gz \
        --r chr$i \
        --o impute_result/chr$i/TPM1_TPM2_Han_imputed_chr$i.IMP$b.vcf.gz \
        --threads 25 \
        --out-gp-field \
        --l impute_result/log/imputedchr$i.$b.log

tabix impute_result/chr$i/TPM1_TPM2_Han_imputed_chr$i.IMP$b.vcf.gz

bcftools query -f "%ID\t%INFO/INFO\t%INFO/AF\n" impute_result/chr$i/TPM1_TPM2_Han_imputed_chr$i.IMP$b.vcf.gz > impute_result/imputeINFO/chr$i/IMP$b.chr$i.txt
awk '{if($2 >= 0.2 && $3 >= 0.001 && $3 <= 0.999)print}' impute_result/imputeINFO/chr$i/IMP$b.chr$i.txt > impute_result/imputeINFO/INFO02AF0001/chr$i/IMP$b.chr$i.txt
awk '{if($2 >= 0.6 && $3 >= 0.001 && $3 <= 0.999)print}' impute_result/imputeINFO/chr$i/IMP$b.chr$i.txt > impute_result/imputeINFO/INFO06AF0001/chr$i/IMP$b.chr$i.txt
