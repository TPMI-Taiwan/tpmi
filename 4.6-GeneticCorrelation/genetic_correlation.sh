#!/bin/bash

phecode1=$1
samp1=$2
pop1=$3
phecode2=$4
samp2=$5
pop2=$6

conda activate ldsc

python ldsc.py --rg formatted/${phecode1}_formatted.sumstats.gz,formatted/${phecode2}_formatted.sumstats.gz \
        --ref-ld-chr ld_scores/hm3_EAS_impID/@ \
        --w-ld-chr ld_scores/hm3_EAS_impID/@ \
	--out genetic_corr/${phecode1}_${phecode2}_rg --samp-prev ${samp1},${samp2} --pop-prev ${pop1},${pop2} --not-M-5-50



