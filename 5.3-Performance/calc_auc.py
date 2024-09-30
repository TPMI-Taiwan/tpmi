#!/bin/python3

import numpy as np
import pandas as pd
from sklearn import metrics

score_df = pd.read_csv("test.sscore", sep = "\t")
pheno_df = pd.read_csv("Phenotype.tsv", sep = "\t")
merge_df = pd.merge(score_df, pheno_df, on = "IID")

phe_list = pd.read_csv("phecode.list", dtype = str)
auc = []
for phe in phe_list["Phecode"]:
    auc.append(metrics.roc_auc_score(merge_df[phe], merge_df[f"{phe}_AVG"]))
