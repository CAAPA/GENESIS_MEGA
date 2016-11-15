###Read in PLINK fam file
geno_king <- read.table("AA_king_orig.fam", stringsAsFactors = F)
names(geno_king) <- c("FAMILY","PATIENT","FATHER","MOTHER","SEX","CASE")
geno_king$ORDER <- 1:dim(geno_king)[1]

###Read in phenotype file
geno_pheno <- read.table("AA_pheno.txt",header=F,na.string="NA",fill=T)
tmp <- matrix(unlist(strsplit(as.character(geno_pheno$V2), '_')), ncol=2,byrow=TRUE)
after <- cbind(as.data.frame(tmp), geno_pheno$V3)
names(after) <- c("PATIENT", "PATID2", "AFFSTAT")
after[after == 0] <- NA
geno_all = merge(geno_king,after,by="PATIENT",all.x=T)
geno_all <- geno_all[order(geno_all$ORDER),]

#Add study info
geno_all$STUDY <- NA
pheno.files <- c("/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JHU_GRAAD/imputed/GENESIS/graad_pheno.txt",
                 "/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JHU_ABR/imputed/GENESIS/jhu_abr_pheno.txt",
                 "/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/CHICAGO/imputed/GENESIS/chicago_pheno.txt",
                 "/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JACKSON_ARIC/imputed/GENESIS/jack_aric_pheno.txt",
                 "/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/JACKSON_JHS/imputed/GENESIS/jack_jhs_pheno.txt",
                 "/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/UCSF_SF/imputed/GENESIS/ucsf_sf_pheno.txt",
                 "NIH.txt",
                 "/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/WINSTON_SALEM/imputed/GENESIS/winston_salem_pheno.txt"
          )
study.names <- c("GRAAD", "BRIDGE", "CAGS", "ARIC", "JHS", "SAGE", "NIH", "SARP")
i <- 0
for (file in pheno.files) {
  i <- i + 1
  study <- study.names[i]
  samples.ids <- read.table(file, stringsAsFactors = F)[1]
  samples.ids <- unlist(strsplit(samples.ids$V1, "_"))[seq(1, length(samples.ids$V1)*2,2)]
  geno_all$STUDY[geno_all$PATIENT %in% samples.ids] <- study
}

#Create IDs for GENESIS format
PATID <- ORDER
geno_order <- cbind(PATID,geno_all)

#Create and write final fam file for GENESIS
final_fam <- geno_order[c("FAMILY","PATID","FATHER","MOTHER","SEX","AFFSTAT")]
write.table(final_fam,"AA_king.fam",sep="\t",row.names=F,col.names=F,quote=F)

#Create and write final pheno file for GENESIS
final_pheno <- geno_order[c("PATID","AFFSTAT", "STUDY")]
write.table(final_pheno,"AA_pheno2.txt",sep="\t",row.names=F,col.names=F,quote=F)
