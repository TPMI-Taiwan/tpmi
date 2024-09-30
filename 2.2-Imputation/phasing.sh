#!/bin/bash

i=$1 ## chromosome

SHAPEIT5_phase_common_static \
    --input TPM1_TPM2_Han_chr$i.vcf.gz \
    --map Phasing_gmap/gmap/chr$i.b38.gmap.gz \
    --region chr$i \
    --output phase_result/TPM1_TPM2_Han_phased_chr$i.vcf.gz \
    --thread 50 \
    --mcmc-iterations 10b,1p,1b,1p,1b,1p,1b,1p,10m --pbwt-depth 8 \
    --log phase_result/log/phased_chr$i.log
tabix phase_result/TPM1_TPM2_Han_phased_chr$i.vcf.gz
