#!/bin/bash
p=$1
genderCount=$(cut -f2 covar/${p}_covar.txt | grep -v gender_code | sort -u | wc -l)
echo "genderCount: $genderCount"

if [ -f "matching/${p}_matched.psam" ]; then
	if [[ $genderCount -eq 2 ]]; then
		$plink2 \
			--glm no-firth hide-covar \
			--covar-variance-standardize \
			--pfile pfile \
			--covar iid-only covar/${p}_covar.txt \
			--keep matching/${p}_matched.psam \
			--covar-name gender_code,age_standardize,age_square_standardize,site,array,log10_records,age_gender,age_square_gender,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
			--pheno iid-only pheno/${p}_pheno.txt \
			--pheno-name pheno \
			--vif 50000 \
			--out summary/${p}_gwas --1 --threads 25 --memory 102400
	else
		$plink2 \
                        --glm no-firth hide-covar \
                        --covar-variance-standardize \
                        --pfile pfile \
                        --covar iid-only covar/${p}_covar.txt \
                        --keep matching/${p}_matched.psam \
                        --covar-name age_standardize,age_square_standardize,site,array,log10_records,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
                        --pheno iid-only pheno/${p}_pheno.txt \
                        --pheno-name pheno \
                        --out summary/${p}_gwas --1 --threads 25 --memory 102400
	fi

else
	if [[ $genderCount -eq 2 ]]; then
		$plink2 \
			--glm no-firth hide-covar \
			--covar-variance-standardize \
			--pfile pfile \
			--covar iid-only covar/${p}_covar.txt \
			--keep gwas_sample.list \
			--covar-name gender_code,age_standardize,age_square_standardize,site,array,log10_records,age_gender,age_square_gender,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
			--pheno iid-only pheno/${p}_pheno.txt \
			--pheno-name pheno \
			--vif 50000 \
			--out summary/${p}_gwas --1 --threads 25 --memory 102400
	else
		$plink2 \
                        --glm no-firth hide-covar \
                        --covar-variance-standardize \
                        --pfile pfile \
                        --covar iid-only covar/${p}_covar.txt \
                        --keep gwas_sample.list \
                        --covar-name age_standardize,age_square_standardize,site,array,log10_records,PCAiR1,PCAiR2,PCAiR3,PCAiR4,PCAiR5,PCAiR6,PCAiR7,PCAiR8,PCAiR9,PCAiR10 \
                        --pheno iid-only pheno/${p}_pheno.txt \
                        --pheno-name pheno \
                        --out summary/${p}_gwas --1 --threads 25 --memory 102400
	fi
fi
