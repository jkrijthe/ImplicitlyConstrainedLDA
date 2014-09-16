all: experiments visuals preparation report

experiments: experiment1 experiment2 experiment3

experiment_learningcurvesgaussian:
	R CMD BATCH Code/ExperimentLearningCurveGaussian.R

experiment_learningcurves:
	R CMD BATCH Code/ExperimentLearningCurvesICLDA.R

experiment_crossvalidation:
	R CMD BATCH Code/ExperimentCVSSLLDA.R

visuals:
	R CMD BATCH Code/VisualizeCVSSLLDA.R
	R CMD BATCH Code/VisualizeLearningCurveGaussian.R
	R CMD BATCH Code/VisualizeLearningCurvesICLDA.R
	R CMD BATCH Code/FigureToyplots.R

preparation:
	cd Figures/ && \
	pdfcrop learningcurvegaussian.pdf && \
	pdfcrop toyplots.pdf && \
	pdfcrop errorcurves.pdf && \
	cd .. && \
	R -e 'library(grDevices); embedFonts("Figures/errorcurves-crop.pdf");embedFonts("Figures/toyplots-crop.pdf"); embedFonts("Figures/learningcurvegaussian-crop.pdf")'

report:
	cd Paper/ && \
	pdflatex paper && \
	bibtex paper && \
	pdflatex paper && \
	pdflatex paper





