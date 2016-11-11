#!/bin/sh


cut -f1,2 -d' ' /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/kinshipmatrix/allcohort_AA_DETROIT_emmaxkin_input.tfam > detroit_ids.txt

plink --tfile /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/kinshipmatrix/afr_am_typed_overlap_transposed \
    --extract /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/kinshipmatrix/allcohort_kinship_markers.txt \
    --remove detroit_ids.txt \
    --make-bed -out AA_king
