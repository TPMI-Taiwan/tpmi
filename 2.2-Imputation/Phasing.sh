#!/bin/bash

i=$1

plink2 --bfile TPMI_afterQC_chr$i \
       --ref-allele /true/ref/alt/allele/file ref_allele_col_num variantID_col_num \
       --real-ref-alleles \
       --out TPMI_Han_chr$i \
       --recode vcf id-paste=iid 'bgz'
tabix TPMI_Han_chr$i.vcf.gz

SHAPEIT5_phase_common_static \
    --input TPMI_Han_chr$i.vcf.gz \
    --map Phasing_gmap/gmap/chr$i.b38.gmap.gz \
    --region chr$i \
    --output phase_result/TPMI_Han_phased_chr$i.vcf.gz \
    --thread 50 \
    --mcmc-iterations 10b,1p,1b,1p,1b,1p,1b,1p,10m --pbwt-depth 8 \
    --log phase_result/log/phased_chr$i.log
tabix phase_result/TPMI_Han_phased_chr$i.vcf.gz
