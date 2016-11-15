#!/bin/sh

#Get Detroit IDs to exclude
cut -f1,2 -d' ' /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/kinshipmatrix/allcohort_AA_DETROIT_emmaxkin_input.tfam > detroit_ids.txt

#Ensure that subjects are in the same order as in the VCF file by creating a file with the required order
head -50 AA_chr2.dose.vcf | grep CHROM > tmp_column_names.txt
python create_subject_order.py

#Extract the kinship file
plink --tfile /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/kinshipmatrix/afr_am_typed_overlap_transposed \
    --extract /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/kinshipmatrix/allcohort_kinship_markers.txt \
    --remove detroit_ids.txt \
    --indiv-sort file tmp_subject_order.txt \
    --make-bed -out AA_king

#Cleanup
rm detroit_ids.txt
rm tmp_subject_order.txt
rm tmp_column_names.txt
