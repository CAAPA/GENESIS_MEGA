#!/bin/bash

#plink --vcf AA_chr2.dose.vcf --freq --out AA_chr2_freq

grep 1$ AA_pheno.txt | cut -f1 -d' ' > tmp_ids.txt
vcftools --vcf  AA_chr2.dose.vcf \
         --keep tmp_ids.txt \
         --recode --stdout >  controls.dose.vcf
vcftools --vcf controls.dose.vcf \
         --freq --chr 2 \
         --out AA_chr2_controls_freq
rm controls.dose.vcf
rm tmp_ids.txt
cat AA_chr2_controls_freq.frq | sed 's/{ALLELE:FREQ}/A1:F1 A2:F2/' > new_AA_chr2_controls_freq.frq
mv new_AA_chr2_controls_freq.frq AA_chr2_controls_freq.frq

grep 2$ AA_pheno.txt | cut -f1 -d' ' > tmp_ids.txt
vcftools --vcf AA_chr2.dose.vcf \
         --keep tmp_ids.txt \
         --recode --stdout >  cases.dose.vcf
vcftools --vcf cases.dose.vcf \
         --freq --chr 2 \
         --out AA_chr2_cases_freq
rm cases.dose.vcf
rm tmp_ids.txt
cat AA_chr2_cases_freq.frq | sed 's/{ALLELE:FREQ}/A1:F1 A2:F2/' > new_AA_chr2_cases_freq.frq
mv new_AA_chr2_cases_freq.frq AA_chr2_cases_freq.frq
