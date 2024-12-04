#!/bin/bash


trait=$1
vcf=$2
chr=$3

Rscrip step1_fitNULLGLMM.R \
	--plinkFile=../binary_fileset/tpmi037 \
	--traitType=quantitative \
	--phenoFile=pheno_cov.txt \
	--phenoCol=residual_int \
	--covarColList=array,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
	--qCovarColList=array \
	--sampleIDColinphenoFile=IID \
	--IsOverwriteVarianceRatioFile=TRUE \
	--outputPrefix=${trait}_step1 \
	--LOCO=FALSE \
	--nThreads=128 

Rscrip step2_SPAtests.R \
	--vcfFile=$vcf \
	--vcfFileIndex=$vcf.csi \
	--vcfField DS \
	--AlleleOrder=ref-first \
	--is_imputed_data=TRUE \
	--chrom=$chr \
	--minMAF=0.01 \
	--LOCO=FALSE \
	--GMMATmodelFile=${trait}_step1.rda \
	--varianceRatioFile=${trait}_step1.varianceRatio.txt \
	--SAIGEOutputFile=${trait}_${chr}_output.txt 

