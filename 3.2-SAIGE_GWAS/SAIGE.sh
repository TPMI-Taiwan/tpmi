#!/bin/bash

trait=$1
vcf=$2
chr=$3


genderCount=$(cut -f2 pheno_cov.txt | grep -v gender_code | sort -u | wc -l)
echo "genderCount: $genderCount"

if [[ $genderCount -eq 2 ]]; then
	Rscrip step1_fitNULLGLMM.R \
		--plinkFile=../binary_fileset/tpmi037 \
		--traitType=binary \
		--phenoFile=pheno_cov.txt \
		--phenoCol=pheno \
		--covarColList=gender_code,age_standardize,age_square_standardize,age_gender,age_square_gender,site,array,log10_records,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
		--qCovarColList=gender_code,site,array \
		--sampleIDColinphenoFile=IID \
		--IsOverwriteVarianceRatioFile=TRUE \
		--outputPrefix=${trait}_step1 \
		--LOCO=FALSE \
		--nThreads=128 
else
	Rscrip step1_fitNULLGLMM.R \
		--plinkFile=../binary_fileset/tpmi037 \
		--traitType=binary \
		--phenoFile=pheno_cov.txt \
		--phenoCol=pheno \
		--covarColList=age_standardize,age_square_standardize,age_gender,age_square_gender,site,array,log10_records,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
		--qCovarColList=site,array \
		--sampleIDColinphenoFile=IID \
		--IsOverwriteVarianceRatioFile=TRUE \
		--outputPrefix=${trait}_step1 \
		--LOCO=FALSE \
		--nThreads=128 
fi

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

