#! Rscript --vanilla --default-packages=utils
load("AA_GENESIS")
library("GENESIS", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3/")
library(GWASTools, lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3/")
args <- commandArgs()
file_name=args[7]
chr_num=args[9]
dosefile=args[11]
markfile=args[13]
posfile=args[15]
subset_val=args[17]
gdsfile <- tempfile()
scanfile <- tempfile()
snpfile <- tempfile()
###association testing
test <- list.files(pattern=glob2rx("chr*.cut*.mach.dose"))
filenames1=test[grep(pattern=file_name,test,fixed=TRUE)]
#setwd("/gpfs/barnes_share/dcl01_data_aniket/data/CAAPA_jhuGRAAD_BDOS_032416/WASHINGTON/imputed/GENESIS/")
imputedDosageFile(input.files=c(dosefile,markfile,posfile),filename=gdsfile,chromosome=chr_num,input.type="MaCH",input.dosage=T,file.type="gds")
gds <- GdsGenotypeReader(gdsfile)
genoData <- GenotypeData(gds)
geno <- getGenotype(genoData)
nullmod.bin <- fitNullMM(scanData = scanAnnot, outcome = "pheno", covars = c("study", "pc6","pc10"), covMatList = covMatList, family=binomial(link = "logit"))
myassoc <- assocTestMM(genoData = genoData, nullMMobj = nullmod.bin, test="Score")
write.table(myassoc,file=paste(file_name,"cut",subset_val,".results.txt",sep=''),sep="\t",row.names=F,col.names=T,quote=F)
