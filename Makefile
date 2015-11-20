all: experiments visuals preparation report

experiments: experiment_learningcurvesgaussian experiment_learningcurves experiment_crossvalidation

experiment_learningcurvesgaussian:
	Rscript Code/ExperimentLearningCurveGaussian.R

experiment_learningcurves:
	Rscript Code/ExperimentLearningCurvesICLDA.R

experiment_crossvalidation:
	Rscript Code/ExperimentCVSSLLDA.R

visuals:
	Rscript Code/VisualizeCVSSLLDA.R
	Rscript Code/VisualizeLearningCurveGaussian.R
	Rscript Code/VisualizeLearningCurvesICLDA.R
	Rscript Code/FigureToyplots.R

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





