#!/bin/bash

### Computing cross-population scores for EUR and EAS using sample from 1000 genomes project.
popcorn compute -v 1 --bfile1 1kg.hm3.eur --bfile2 /1kg.hm3.eas scores.imp.txt
popcorn compute -v 1 --gen_effect --bfile1 1kg.hm3.eur --bfile2 1kg.hm3.eas scores.eff.txt

### Estimaing the genetic correlation.
popcorn fit -v 1 --cfile cscore.imp.txt --sfile1 ukb.glm.logistic --sfile2 tpmi.glm.logistic --maf 0.01 fit.imp
popcorn fit -v 1 --cfile cscore.eff.txt --sfile1 ukb.glm.logistic --sfile2 tpmi.glm.logistic --use_mle --gen_effect --maf 0.01 fit.eff
