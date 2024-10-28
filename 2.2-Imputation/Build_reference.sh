#!/bin/bash

sampleID=$1
whatshap phase -o WHphased_vcf/${sampleID}_WHphased.vcf --reference hs38DH.fa unphased_vcf/${sampleID}_unphased.vcf.gz ${sampleID}.cram
bgzip WHphased_vcf/${sampleID}_WHphased.vcf
tabix WHphased_vcf/${sampleID}_WHphased.vcf.gz

ls WHphased_vcf/${sampleID}_WHphased.vcf.gz > merge.list

bcftools merge -l merge.list -Oz -o WHphased_vcf/TWB1498_WHphased.vcf.gz
tabix WHphased_vcf/TWB1498_WHphased.vcf.gz

for i in {1..22};
do
	Shapeit4.2 \
		--input WHphased_vcf/TWB1498_WHphased.vcf.gz \
		--map gmap/chr$i.b38.gmap.gz \
		--region chr$i \
		--output SHphased_vcf/TWB1498_SHphased_chr$i.vcf.gz \
		--thread 30 \
		--use-PS 0.0001 \
		--mcmc-iterations 10b,1p,1b,1p,1b,1p,1b,1p,10m --pbwt-depth 8 \
		--log log/phased_chr$i.log
done
