#!/bin/bash

p=$1
python3 remove_MHC.py $p

conda activate ldsc

python munge_sumstats.py --sumstats formatted/${p}_qc.summary --out formatted/${p}_formatted --N-col OBS_CT --snp ID --a1 A1 --a2 OMITTED

samp_prev=$(grep $p, gwas_prev.csv | cut -f2 -d,)
pop_prev=$(grep $p, pop_prev.csv | cut -f2 -d,)
python ldsc.py --h2 formatted/${p}_formatted.sumstats.gz \
        --ref-ld-chr ld_scores/hm3_EAS_impID/@ \
        --w-ld-chr ld_scores/hm3_EAS_impID/@ \
        --out obs_heri/${p}_h2 --not-M-5-50

