#!/bin/python3

import sys
import pandas as pd

phe = sys.argv[1]
df = pd.read_table(f'summary/{phe}_gwas.pheno.glm.logistic')
df['chi square'] = df['Z_STAT'] * df['Z_STAT']
df = df[df['chi square'] <= 80]
#MHC region
df_filtered = df[~((df['#CHROM'] == 6) & (df['POS'] >= 25391792) & (df['POS'] <= 33424245) )]
df_filtered.to_csv(f'formatted/{phe}_qc.summary',index=None, sep='\t')
