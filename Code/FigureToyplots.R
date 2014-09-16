library(RSSL)
library(ggplot2)
require(gridExtra)

#options
gaussvar<-0.3
sttheme<-theme(
panel.background = element_rect(fill = "transparent",colour = NA),
panel.grid.minor = element_line(colour="lightgrey",size=0.5,linetype=2),
panel.grid.major = element_line(colour="lightgrey",size=0.5,linetype=2)
)



# Row 1: 2 Gaussian, unexpected boundary
ds<-Generate2ClassGaussian(1000,2,gaussvar,expected=FALSE)
uds<-ds
uds$y[sample(nrow(ds),nrow(ds)-10)]<-NA
ms<-formula(y~X2+X1)
o<-SSLDataFrameToMatrices(ms,uds,intercept=FALSE)

g_sup<-LinearDiscriminantClassifier(o$X,o$y,x_center=FALSE)
g_ic<-ICLinearDiscriminantClassifier(o$X,o$y,o$X_u,x_center=FALSE)
# g_mc<-MCLinearDiscriminantClassifier(o$X,o$y,o$X_u)
g_em<-EMLinearDiscriminantClassifier(o$X,o$y,o$X_u,x_center=FALSE)
# g_sl<-SelfLearning(o$X,o$y,o$X_u,method=LinearDiscriminantClassifier)


# clplot(o$X_u,factor(g_sl@i_labels[,ncol(g_sl@i_labels)]))
# clplot(o$X_u,factor(g_ic@responsibilities))
# clplot(o$X_u,predict(g_sup,o$X_u))
# clplot(o$X_u,predict(g_mc,o$X_u))

p_scatter<-clplot(rbind(o$X,o$X_u),factor(c(o$y,rep("NA",nrow(o$X_u))),labels=c(c(1,2),"NA")))
p_scatter<-p_scatter+ggtitle("Scatter plot")
p_scatter<-boundaryplot(g_sup,p_scatter)
p_scatter
# p_scatter<-boundaryplot(g_ic,p_scatter)
# p_scatter<-boundaryplot(g_em,p_scatter)
#TODO: plot boundaries

p_ic<-ggplot(aes(X2,X1,color=Responsibility),data=data.frame(X2=o$X_u[,1],X1=o$X_u[,2],Responsibility=g_ic@responsibilities))+geom_point(asp=1)+scale_colour_gradient(limits=c(0, 1))+sttheme+coord_fixed()
p_ic<-p_ic+ggtitle("IC responsibilities")

p_em<-ggplot(aes(X2,X1,color=Responsibility),data=data.frame(X2=o$X_u[,1],X1=o$X_u[,2],Responsibility=g_em@responsibilities[,1]))+geom_point(asp=1)+scale_colour_gradient(limits=c(0, 1))+sttheme+coord_fixed()
p_em<-p_em+ggtitle("EM responsibilities")

p_list<-list(p_scatter,p_ic,p_em)

#Expected
ds<-Generate2ClassGaussian(1000,2,gaussvar)
uds<-ds
uds$y[sample(nrow(ds),nrow(ds)-10)]<-NA
ms<-formula(y~X2+X1)
o<-SSLDataFrameToMatrices(ms,uds,intercept=FALSE)

g_sup<-LinearDiscriminantClassifier(o$X,o$y,x_center=FALSE)
g_ic<-ICLinearDiscriminantClassifier(o$X,o$y,o$X_u,x_center=FALSE)
# g_mc<-MCLinearDiscriminantClassifier(o$X,o$y,o$X_u)
g_em<-EMLinearDiscriminantClassifier(o$X,o$y,o$X_u,x_center=FALSE)
# g_sl<-SelfLearning(o$X,o$y,o$X_u,method=LinearDiscriminantClassifier)

p_scatter<-clplot(rbind(o$X,o$X_u),factor(c(o$y,rep("NA",nrow(o$X_u))),labels=c(c(1,2),"NA")))
p_scatter<-p_scatter+ggtitle("Scatter plot")
p_scatter<-boundaryplot(g_sup,p_scatter)
# p_scatter<-boundaryplot(g_ic,p_scatter)
# p_scatter<-boundaryplot(g_em,p_scatter)
p_scatter
#TODO: plot boundaries

p_ic<-clplot(o$X_u,(g_ic@responsibilities))

sttheme<-theme(
  panel.background = element_rect(fill = "transparent",colour = NA), 
  panel.grid.minor = element_line(colour="lightgrey",size=0.5,linetype=2), 
  panel.grid.major = element_line(colour="lightgrey",size=0.5,linetype=2)
)

p_ic<-ggplot(aes(X2,X1,color=Responsibility),data=data.frame(X2=o$X_u[,1],X1=o$X_u[,2],Responsibility=g_ic@responsibilities))+geom_point(asp=1)+scale_colour_gradient(limits=c(0, 1))+sttheme+coord_fixed()
p_ic<-p_ic+ggtitle("IC responsibilities")

p_em<-ggplot(aes(X2,X1,color=Responsibility),data=data.frame(X2=o$X_u[,1],X1=o$X_u[,2],Responsibility=g_em@responsibilities[,1]))+geom_point(asp=1)+scale_colour_gradient(limits=c(0, 1))+sttheme+coord_fixed()
p_em<-p_em+ggtitle("EM responsibilities")

p_list<-c(p_list,list(p_scatter,p_ic,p_em))

p_list[[1]]<-p_list[[1]]+theme(plot.margin=unit(c(0,0,0.3,0), "cm"))
p_list[[2]]<-p_list[[2]]+theme(plot.margin=unit(c(0,0,0.3,0), "cm"))
p_list[[3]]<-p_list[[3]]+theme(plot.margin=unit(c(0,0,0.3,0), "cm"))
p_list[[4]]<-p_list[[4]]+theme(plot.margin=unit(c(0.3,0,0,0), "cm"))
p_list[[5]]<-p_list[[5]]+theme(plot.margin=unit(c(0.3,0,0,0), "cm"))
p_list[[6]]<-p_list[[6]]+theme(plot.margin=unit(c(0.3,0,0,0), "cm"))


pdf("Figures/toyplots.pdf",width=16,height=8)
do.call(grid.arrange, c(p_list,ncol=3,clip=TRUE))
dev.off()
