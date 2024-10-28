#!/bin/bash

i=$1  ## chromosome
b=$2  ## imputation batch

bcftools view -S impute_result/batch_list/sample.IMP$b.list phase_result/TPMI_Han_phased_chr$i.vcf.gz -Oz -o phase_result/byBatch/IMP$b/TPMI_Han_phased_chr$i.$b.vcf.gz --threads 5
tabix phase_result/byBatch/IMP$b/TPMI_Han_phased_chr$i.$b.vcf.gz

impute5_v1.1.5/impute5_1.1.5_static \
        --h SHphased_vcf/TWB1498_SHphased_chr$i.vcf.gz \
        --m Phasing_gmap/gmap/chr$i.b38.gmap.gz \
        --g phase_result/byBatch/IMP$b/TPMI_Han_phased_chr$i.$b.vcf.gz \
        --r chr$i \
        --o impute_result/chr$i/TPMI_Han_imputed_chr$i.IMP$b.vcf.gz \
        --threads 25 \
        --out-gp-field \
        --l impute_result/log/imputedchr$i.$b.log
tabix impute_result/chr$i/TPMI_Han_imputed_chr$i.IMP$b.vcf.gz

