load("Results/BenchmarkLDA-20rep-justenoughplus5or20.RData")

## Print results
table.CrossValidation<-function(object,caption="",classifier_names=NULL,measurement=1,label="cvresults") {
  # overfolds<-apply(object$results,c(1,3:4),mean,na.rm=T)
  if (is.list(object)) {
    if ("results" %in% names(object)) {
      object<-list(object)
    }
  } else {
    stop("Supplied object is not a cross-validation results object")
  }

  if (is.null(classifier_names)) {
    classifier_names<-dimnames(object[[1]]$results)[[2]]
  }

  cat("\\begin{table*}\n")
  cat("\\caption{",caption,"} \\label{table:",label,"}\n",sep="")
  cat("\\centering\n")
  cat("\\begin{tabular}{|l|",paste(rep("l",dim(object[[1]]$results)[2]),collapse=""),"|}\n",sep="")
  cat("\\hline\n")
  cat("Dataset &",paste(classifier_names,collapse=" & "),"\\\\ \n")
  cat("\\hline\n")
  sapply(1:length(datasets), function(n) { 
    cat(object[[n]]$dataset_name,"")
    overfolds<-object[[n]]$results
    means<-apply(overfolds,c(2:3),mean,na.rm=T)
    sds<-apply(overfolds,2:3,sd)
    options(digits=2)
  for (c in 1:dim(means)[1]) {
     csd<-sprintf("%.2f",sds[c,measurement])
     if (measurement==1) { 
       cm<-sprintf("%.2f",1-means[c,measurement])
      make_bold <- (t.test(overfolds[,1,measurement],overfolds[,c,measurement])$p.value<0.05)&all(means[c,measurement]>=means[1,measurement])&(all(c!=c(1,2)))
       make_underlined <- all(means[c]>=means[3:6])&(t.test(overfolds[,c,measurement],overfolds[,which.max(means[3:6]),measurement])$p.value<0.05)&(all(c!=c(1,2)))
     } else {
       cm<-sprintf("%.2f",means[c,measurement])
       make_bold <- (t.test(overfolds[,1,measurement],overfolds[,c,measurement])$p.value<0.05)&all(means[c,measurement]<=means[1,measurement])&(all(c!=c(1,2)))
       make_underlined <- all(means[c,measurement]<=means[3:6,measurement])&(t.test(overfolds[,c,measurement],overfolds[,which.min(means[3:6,measurement]),measurement])$p.value<0.05)&(all(c!=c(1,2)))
       
     }
     cat("& $",ifelse(make_bold,"\\mathbf{",""),ifelse(make_underlined,"\\underline{",""), cm, " \\pm ",csd,ifelse(make_underlined,"}",""),ifelse(make_bold,"} $","$"),sep="")
  }
  cat("\\\\ \n")
  })
  cat("\\hline\n")
  cat("\\end{tabular}\n")
  cat("\\end{table*}\n")
}
options(digits=2)
capture.output(table.CrossValidation(cvresults,measurement=1,caption=
                                       "Average 10-fold cross-validation error and its standard deviation over 20 repeats. Indicated in $\\mathbf{bold}$ is whether a semi-supervised classifier significantly outperform the supervised LDA classifier, as measured using a $t$-test with a $0.05$ significance level. \\underline{Underlined} indicates whether a semi-supervised classifier is (significantly) best among the four semi-supervised classifiers considered.",
                                     classifier_names=c("LDA","LDAoracle","MCLDA","EMLDA","SLLDA","ICLDA"),label="cvresults-error"),
               file="Figures/cvtable-error.tex")

capture.output(table.CrossValidation(cvresults,measurement=2,caption=
                                       "Average 10-fold cross-validation negative log-likelihood (loss) and its standard deviation over 20 repeats. Indicated in $\\mathbf{bold}$ is whether a semi-supervised classifier significantly outperform the supervised LDA classifier, as measured using a $t$-test with a $0.05$ significance level. \\underline{Underlined} indicates whether a semi-supervised classifier is (significantly) best among the four semi-supervised classifiers considered.",
                                     classifier_names=c("LDA","LDAoracle","MCLDA","EMLDA","SLLDA","ICLDA"),label="cvresults-loss"),
               file="Figures/cvtable-loss.tex")
