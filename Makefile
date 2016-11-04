# declaring phony targets
.PHONY: all data tests eda ols ridge lasso pcr plsr regressions report slides session clean preprocessing splitset cleanall


# setting the url for the data set as a variable
url = http://www-bcf.usc.edu/~gareth/ISL/Credit.csv


# wildcard the section md files
MDS = $(wildcard report/sections/*.Rmd)


# target for reproducing the experiment
all: eda regressions report


# target for constructing report.Rmd from the .md files in sections
# report.pdf is also compiled from the Rmd file
report:
	cat $(MDS) > report/report.Rmd
	Rscript -e 'library(rmarkdown); render("report/report.Rmd")'


# target to download the data set in the the data directory
data:
	curl -o data/Credit.csv $(url)


# target to run download the data, process it, and split the data set
dataall:
	make data
	make preprocessing
	make splitset


# target to run tests of the functions
tests:
	Rscript code/test_that.R


# target for pre-processing the Credit data set to be used for regression
preprocessing: data/Credit.csv
	Rscript code/scripts/preprocessing_script.R $(<)


# target for splitting the data set to training and test sets
splitset: data/scaled_credit.csv
	Rscript code/scripts/train_test_script.R $(<)


# target to run all the regressions and produce their outputs
regressions:
	make ols
	make ridge
	make lasso
	make pcr
	make plsr


# target to perform a descriptive analysis
eda: data/Credit.csv
	Rscript code/scripts/eda_script.R $(<)


# target to perform an ordinary least squares regression
ols:
	Rscript code/scripts/ols_script.R


# target to perform a ridge regression
ridge:
	Rscript code/scripts/ridge_script.R


# target to perform a lasso regression
lasso:
	Rscript code/scripts/lasso_script.R


# target to perform a principal components regression
pcr:
	Rscript code/scripts/pcr_script.R


# target to perform a partial least squares regression
plsr:
	Rscript code/scripts/plsr_script.R


# target to produce slides.html from slides.Rmd
slides:
	Rscript -e ‘library(rmarkdown); render(“slides/slides.Rmd”)’


# target to produce the session_info.txt output
session:
	Rscript code/scripts/session_info_script.R


# cleans report.pdf
clean:
	rm report/report.pdf


# cleans all outputs from scripts, reports, and data (all scripts should have been used)
cleanall:
	rm report/report.pdf
	rm images/*.png
	rm data/*.RData
	rm data/*.txt
	rm data/*_credit.csv


