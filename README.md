These are the resources used to generate Jesse H. Krijthe & Marco Loog's "Implicitly Constrained Linear Discriminant Analysis". See below for instructions on how to rerun the experiments, generate the figures used in the paper and/or generate the paper. The methods used have been extracted as a separate library, called RSSL. For these experiments, version 0.2 was used.

#Main Requirements (used to generate the original paper)
R (3.0.2)
RSSL (0.2)
pdflatex

Suggested:
pdfcrop
Helvetica.ttf and HelveticaBold.ttf files to include fonts in the PDF figures.

#How to reproduce this paper
You can run the individual experiments using:

```
make experiment_learningcurvesgaussian
make experiment_crossvalidation
make experiment_learningcurves
```

Or run them all using (not recommended)
```
make experiments
```

To generate the figures and tables:

```
make figures
```

To prepare figures and tables for the manuscript
```
make preparation
```

To generate the manuscript:
```
make paper
```

Or, all at once (not recommended)
```
make all
```