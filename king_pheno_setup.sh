#!/bin/sh
module load R-3.3.1-gcc-6.1.0-tpkh25pakjkfxwqth7kp3gxl4grlf6c2
module load torque

cp AA_king.fam AA_king_orig.fam
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JHU_GRAAD/imputed/GENESIS/graad_pheno.txt > AA_pheno.txt
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JHU_ABR/imputed/GENESIS/jhu_abr_pheno.txt >> AA_pheno.txt
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/CHICAGO/imputed/GENESIS/chicago_pheno.txt  >> AA_pheno.txt
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JACKSON_ARIC/imputed/GENESIS/jack_aric_pheno.txt  >> AA_pheno.txt
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JACKSON_JHS/imputed/GENESIS/jack_jhs_pheno.txt  >> AA_pheno.txt
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/UCSF_SF/imputed/GENESIS/ucsf_sf_pheno.txt  >> AA_pheno.txt
cat NIH.txt >> AA_pheno.txt
cat /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/WINSTON_SALEM/imputed/GENESIS/winston_salem_pheno.txt  >> AA_pheno.txt


R CMD BATCH king_pheno_setup.R
