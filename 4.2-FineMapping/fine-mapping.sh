#!/bin/bash

phe=$1
mkdir output/$phe
mkdir output/$phe/ld
mkdir output/$phe/z
mkdir output/$phe/susie

python3 ./make_finemap_inputs.py --sumstats saige_output.$phe.tsv --prefix output/$phe/z/leadSNP --rsid-col MarkerID --chromosome-col CHR --position-col POS --allele1-col Allele1 --allele2-col Allele2 --freq-col AF_Allele2 --beta-col BETA --se-col SE --p-col p.value --delimiter 'TAB' --grch38

fileCount=$(ls -A output/$phe/z | wc -l)
if [[ $fileCount -gt 1 ]]; then
	ls output/$phe/z/*.z | cut -f4 -d/ | sed 's/\.z//g' > output/$phe/leadSNP_region.list
	n=$(awk -v phe="$phe" '{if($1 == phe)print $2}' phecode_nsamples.txt)
	while read -r line;
	do
		chr=$(echo $line | cut -f2 -d"r" | cut -f1 -d".")
		region=$(echo $line | cut -f2 -d"r" | cut -f2 -d".")
		cut -f1 output/$phe/z/leadSNP.chr$chr.$region.z > output/$phe/ld/chr$chr.$region.SNP.list
		plink2 --vcf ld_reference_chr$chr.vcf.gz --extract output/$phe/ld/chr$chr.$region.SNP.list --r-phased 'ref-based' square --out output/$phe/ld/chr$chr.$region
		mv output/$phe/ld/chr$chr.$region.phased.vcor1 output/$phe/ld/chr$chr.$region.phased.vcor1.ld
		Rscript SuSiE.R --z output/$phe/z/leadSNP.chr$chr.$region.z --ld output/$phe/ld/chr$chr.$region.phased.vcor1.ld --n-samples $n --out output/$phe/susie/chr$chr.$region
	done < output/$phe/leadSNP_region.list
else
	echo "Note: ${phe} No significant SNP"
fi
