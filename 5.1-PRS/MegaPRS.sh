#!/bin/bash

phe=$1
awk '(NR>1){snp=$1":"$2;a1=$5;a2=$4;dir=$9;p=$13;n=$18+$19}(NR==1) {print "Predictor A1 A2 Direction P n"}(NR>1 && (a1=="A"||a1=="C"||a1=="G"||a1=="T") && (a2=="A"||a2=="C"||a2=="G"||a2=="T")){print snp, a1, a2, dir, p, n}' saige_output.$phe.tsv > InformatSummary/${phe}_summ_SNV.txt
awk '(NR==FNR){arr[$2]=$5$6;next}(FNR==1 || ($1 in arr && ($2$3==arr[$1] || $3$2==arr[$1])))' CalcTagging/RefPanel_filterhm3.bim InformatSummary/${phe}_summ_SNV.txt > InformatSummary/${phe}_summ_overlap.txt
cut -f1 InformatSummary/${phe}_summ_overlap.txt > InformatSummary/${phe}_summ_overlap_ID.list

ldak5.2.linux --sum-hers HeribyPhecode/${phe}_heri --tagfile CalcTagging/ldak_calctag.tagging --summary InformatSummary/${phe}_summ_overlap.txt --matrix CalcTagging/ldak_calctag.matrix --max-threads 10 --check-sums NO

ldak5.2.linux --mega-prs PredictionModel/${phe}_mega.val --model mega --ind-hers HeribyPhecode/${phe}_heri.ind.hers --summary InformatSummary/${phe}_summ_overlap.txt --cors PredictorPredictor_corr/cors.ref --skip-cv YES --window-kb 1000 --allow-ambiguous YES --max-threads 10 --extract InformatSummary/${phe}_summ_overlap_ID.list

ldak5.2.linux --sp-gz Training80k --scorefile PredictionModel/${phe}_mega.val.effects --pheno Pheno/${phe}_pheno.txt --validate ValidateModel/${phe}_mega.val --max-threads 10 --SNP-data NO
