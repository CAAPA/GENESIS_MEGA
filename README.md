# GENESIS_MEGA
Scripts used to run a sensitivity analysis on chr2, comparing African American meta-analysis with a mega analysis

These scripts were cloned from the repository at https://gitlab.com/nrafaels/GENESIS

# Software requirements #
* [PLINK 1.9](https://www.cog-genomics.org/plink2)
* [KING: Kinship-based INference for Gwas](http://people.virginia.edu/~wc9c/KING/manual.html)
* [DosageConvertor](http://genome.sph.umich.edu/wiki/DosageConvertor)
* [R-3.3.1](https://cran.r-project.org/)
* [bcftools 1.3.1](https://samtools.github.io/bcftools/bcftools.html)

# R packages required #
* [GWASTools](https://www.bioconductor.org/packages/release/bioc/html/GWASTools.html)
* [SNPRelate](http://bioconductor.org/packages/release/bioc/html/SNPRelate.html)
* [GENESIS](https://bioconductor.org/packages/release/bioc/html/GENESIS.html)

# Step 1 #
## Create dosage VCF files with merged African American cohorts ##
* run_bcf_merge.sh

# Step 2 #
## Convert input files used for EMMAX from tped and tfam format into plink binary format. ##
* tped_binary.sh

# Step 3 #
## Change patient IDs to row numbers for GENESIS. ##
* king_pheno_setup.sh

# Step 4 #
## Run king relationship inference software (needed for GENESIS). ##
* king.sh

# Step 5 #
## Run GENESIS to get null model including PCA's for SNP analysis. ##
* GENESIS_setup_R.sh

# Step 6 #
## Run batch script to split file, run DosageConvertor, create input files for GENESIS, and run GENESIS analysis. ##
* batch_script.sh

# Step 7 #
## Link results to chromosomal location and concatenate results. ##
* concatenate_results_by_chr.sh
