#!/bin/bash

#SBATCH -p defq # Partition
#SBATCH -n 1              # one CPU
#SBATCH -N 1              # on one node
#SBATCH -t 0-12:00         # Running time of 12 hours
#SBATCH --share
#SBATCH --mail-user=nicholas.rafaels@ucdenver.edu
#SBATCH --mail-type=FAIL
##Read the filenames for each set
cd /gpfs/barnes_share/GENESIS_MEGA/    #######location where the results of each splitted chromosome is stored
#cd /gpfs/barnes_home/shettyan/scripts/
#!/bin/sh
module load gcc/5.1.0
  # unzip the file
#gunzip -c /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/WASHINGTON/imputed/${1}.dose.vcf.gz > ${1}.dose.vcf
#gunzip -c /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/WASHINGTON/imputed/${1}.info.gz  > ${1}.info
header1="header1_"${1}
header2="header2_"${1}
variants1="variants1_"${1}
variants2="variants2_"${1}
cat AA_chr2.dose.vcf |head -n 10000 | grep "^#" | sed -e '2d;11d;12d;13d' > $header1			###grab the headers
cat AA_chr2.dose.vcf |grep -v "^#" > $variants1				###grab the non-headers
gunzip -c /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/UCSF_SF/imputed/chr2.info.gz |head -n 10000 | grep "^SNP" > $header2
gunzip -c /gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/UCSF_SF/imputed/chr2.info.gz |grep -v "^SNP" > $variants2
  #split into chunks with 100000 lines
split -d -l 100000 $variants1 ${1}.dose
split -d -l 100000 $variants2 ${1}.cut
  #reattach the header to each and clean up
for j in ${1}.dose*;
  do
    cat $header1 $j >$j.vcf && rm -f $j
done
  #reattach the header to each and clean up
for j in ${1}.cut*;
  do cat $header2 $j >$j.info && rm -f $j;
done
rm -f $header1 $variants1 $header2 $variants2
numdirs=(${1}.*.info)
numdirs=${#numdirs[@]}
END=$(($numdirs-1))
echo $numdirs
#echo $END
for j in $(seq -w 00 $END);
  do
    DosageConvertor --vcfDose ${1}.dose${j}.vcf --info ${1}.cut${j}.info --prefix ${1}.cut${j} --type mach --format DS
    sbatch --mem 60000 --output=${1}.${j}.out --error=${1}.${j}.err dosage_converter.sh ${1} ${j}
   # rm -f ${1}.cut${j}.info ${1}.dose${j}.vcf
   # gunzip ${1}.cut${j}.mach.dose.gz
   # cut -f 1,2 -d ":" --output-delimiter=$'\t' ${1}.cut${j}.mach.info > ${1}.cut${j}.test.txt
   # awk -F" " '{print $1}' ${1}.cut${j}.mach.info > ${1}.cut${j}.test1.txt
   # awk -F" " '{print $2}' ${1}.cut${j}.test.txt > ${1}.cut${j}.test2.txt
   # paste ${1}.cut${j}.test1.txt ${1}.cut${j}.test2.txt > ${1}.cut${j}.mach.txt
   # sed -i -e '1s/REF(0)/position/' ${1}.cut${j}.mach.txt
    #rm -f ${1}.cut${j}.test.txt ${1}.cut${j}.test2.txt ${1}.cut${j}.test1.txt
  done
#id_name=$1"."
#R CMD BATCH GENESIS_analysis.R --args $id_name --args $1
