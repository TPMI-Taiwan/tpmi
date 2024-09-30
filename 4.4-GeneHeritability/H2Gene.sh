#!/bin/bash

trait=$1
mkdir -p h2gene_output/$trait

cat pyrho_EAS_LD_blocks.bed | while IFS=" " read -r c s e; 
do 
	Rscript ./H2Gene.R $trait $c $s $e
done
