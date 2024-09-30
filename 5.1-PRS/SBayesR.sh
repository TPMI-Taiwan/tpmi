#!/bin/bash

# https://cnsgenomics.com/software/gctb/#SBayesRTutorial

tools/gctb_2.05beta_Linux/gctb \
        --sbayes R \
        --mldm gctb/ldm/hm3/ldm.list \
        --pi 0.95,0.02,0.02,0.01 \
        --gamma 0.0,0.01,0.1,1 \
        --gwas-summary ${phecode}.ma \
        --chain-length 10000 \
        --burn-in 2000 \
        --out-freq 10 \
        --out output/${phecode} \
        --seed 17"

