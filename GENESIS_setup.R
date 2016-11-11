#source("https://bioconductor.org/biocLite.R")
#biocLite("GWASTools")
library(GWASTools, lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3/")

###Read in Barbados genotype data for PCAs
#biocLite("SNPRelate")
library("SNPRelate", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3/")
snpgdsBED2GDS(bed.fn = "AA_king.bed", bim.fn = "AA_king.bim", fam.fn = "AA_king.fam",
              out.gdsfn = "AA_king.gds")

#biocLite("GENESIS")
library("GENESIS", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.3/")
file.kin0 <- "king.kin0"
file.kin <- "king.kin"
geno <- GdsGenotypeReader(filename = "AA_king.gds")
genoData <- GenotypeData(geno)
iids <- getScanID(genoData)

###Run PC analysis
Kingmat <- king2mat(file.kin0=file.kin0,file.kin=NULL,type="kinship",iids = iids)
mypcair <- pcair(genoData = genoData, kinMat = Kingmat,divMat = Kingmat)
mypcrel <- pcrelate(genoData = genoData, pcMat = mypcair$vectors[,1:8],training.set = mypcair$unrels,
                    write.to.gds = T, gds.prefix = "AA")
save.image("genesis_setup.RData")

#Get phenotypes
pheno <- as.vector(as.matrix(read.table("AA_pheno2.txt",header=F,na.string="NA")['V2']))
pheno <- pheno - 1
study <- read.table("AA_pheno2.txt",header=F,na.string="NA", stringsAsFactors = F)[,c(3)]

# #Check which PCs are associated with phenotype
# p.vals <- c()
# for (i in 1:10) {
#   pc <- mypcair$vectors[,i]
#   model <- glm(pheno ~ study + pc, family = binomial(link = "logit"))
#   p.val <- anova(model, test="Chisq")[3,5]
#   p.vals <- c(p.vals, p.val)
# }
# (data.frame(PC1=p.vals[1], PC2=p.vals[2], PC3=p.vals[3], PC4=p.vals[4],
#             PC5=p.vals[5], PC6=p.vals[6], PC7=p.vals[7], PC8=p.vals[8],
#             PC9=p.vals[9], PC10=p.vals[10]))
# PC1       PC2       PC3       PC4       PC5         PC6       PC7
# 1 0.2082938 0.8340229 0.6301353 0.1051046 0.5864958 0.008105056 0.3120142
# PC8       PC9       PC10
# 1 0.9040466 0.1777808 0.01558355

mypcrel <- openfn.gds("AA_pcrelate.gds")
scanAnnot <- ScanAnnotationDataFrame(data.frame(scanID = iids,pc6 = mypcair$vectors[,6],pc10 = mypcair$vectors[,10], pheno = pheno, study=study))
covMatList <- list("Kin" = pcrelateMakeGRM(mypcrel))

save(scanAnnot, covMatList, mypcair, file = "AA_GENESIS")
