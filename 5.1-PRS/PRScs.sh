#!/bin/bash


trait=$1
sampleCount=$2
phi=$3
chr=$4
sst=$5	## sst_file: ID, A1, A2, BETA, SE


python3.11 PRScs.py \
	--bim_prefix=./gwas/TPMI_GWAS \
	--ref_dir=./ref/ldblk_1kg_eas \
	--sst_file=$sst \
	--chrom=$chr \
	--seed=3 \
	--phi $phi \
	--n_gwas=$sampleCount \
	--out_dir=./output/$trait

