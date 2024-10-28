# Imputation

## Data preparation

-   WGS data for building reference panel
-   Genotype QC data
-   Download [genetic map](https://github.com/odelaneau/shapeit4/tree/master/maps/genetic_maps.b38.tar.gz)

## Building Reference Panel

Total of 1,498 Taiwan Biobank WGS data aligned by BWA-MEM and variant called by DeepVariant.

1.  The WGS data were filtering refer to [1000 Genome Project high-coverage Illumina integrated phased panel](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20220422_3202_phased_SNV_INDEL_SV/README_1kGP_phased_panel_110722.pdf)
    -   Remove SNPs with missing rate \> 5%
    -   Remove SNPs with minor allele count \< 2
    -   Remove SNPs with HWE p-value \< 1e-10
    -   Remove multiallelic variants
2.  Two different based phasing tools, [WhatsHap](https://whatshap.readthedocs.io/en/latest/) and [SHAPEIT4](https://odelaneau.github.io/shapeit4/), were used for estimating phase set by sequence read and whole genome haplotype phasing with the phase set. (`Build_reference.sh`)

## Genotype Imputation

1.  Array data that passed QC was converted to VCF using [PLINK2](https://www.cog-genomics.org/plink/2.0/) and phased using [SHAPEIT5](https://odelaneau.github.io/shapeit5/). (`Phasing.sh`)
2.  We divided the samples into batches of 3,000 to balance memory consumption and processing time for whole genome imputation using [bcftools](https://samtools.github.io/bcftools/bcftools.html) and [IMPUTE5](https://jmarchini.org/software/#impute-5) with pre-built reference panel. (`Imputation.sh`)
3.  Post imputation QC by batch
    -   Remove SNPs with Info score \< 0.6 by each batch
    -   Remove SNPs with MAF \< 0.1% by each batch
4.  Post imputation QC after merging all QC batches with overlapping SNPs
    -   Remove SNPs with Info score \< 0.7 in average
    -   Remove SNPs with MAF \< 1% in average
