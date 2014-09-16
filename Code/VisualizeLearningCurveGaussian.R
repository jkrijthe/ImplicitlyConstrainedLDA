library(RSSL)
load("Results/LearningcurveGaussian.RData")
library(reshape)
library(ggplot2)
require(gridExtra)

# For the Gaussian plot:
tc<-errorcurves[[1]]
tc$results<-tc$results[,-11,,]
dimnames(tc$results)[[3]]<-c("LDA","LDAoracle","MCLDA","EMLDA","SLLDA","ICLDA")
class(tc)<-"ErrorCurve"
pdf("Figures/learningcurvegaussian.pdf",width=7,height=5)
plot.ErrorCurve(tc,measurement=1,dataset_names="2D Multivariate Normal",legendsetting="right")
dev.off()
