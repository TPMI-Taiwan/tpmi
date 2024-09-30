#!/bin/bash
phecode=$1 
gwas=${phecode}_all.156.txt

Rscript PRSice-2/PRSice.R \
	--dir . \
	--prsice PRSice-2/PRSice_linux \
	--base ${gwas} \
	--snp MarkerID --pvalue p.value \
	--target training.chr# \
	--type bgen \
	--thread 30 \
	--stat BETA \
	--A1 Allele2 \
	--A2 Allele1 \
	--chr CHR \
	--snp MarkerID \
	--binary-target T \ ## --binary-target F for QT
	--pheno ${phecode}.train.pheno \
	--pheno-col ${phecode} \
	--out training \
	--score sum \
	--allow-inter \
	--print-snp

th=`tail -n1 training.summary | cut -f 3`
cat training.snp | awk -v t="$th" '{if($4 <= t) print $2}' | grep -v SNP > val_selected_snp.list
header=`head -n1 ${gwas}`
echo $header | cat - <(grep -w -f val_selected_snp.list ${gwas}) | tr ' ' '\t'> base.selected
sed 's/ \+ / /g' base.selected  | sed 's/^ //g' | sed 's/ /\t/g' | awk '{print $3"\t"$5"\t"$9}' > weight.txt
