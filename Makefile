url = http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

all: eda regressions report

.PHONY: all data tests eda ols ridge lasso pcr plsr regressions report slides session clean preprocessing splitset cleanall

report:

regressions:
	make ols
	make ridge
	make lasso
	make pcr
	make plsr

data:
	curl -o data/Credit.csv $(url)

tests:

preprocessing: data/Credit.csv
	Rscript code/scripts/preprocessing_script.R $(<)

# splitting the data set to training and test sets
splitset: data/scaled_credit.csv
	Rscript code/scripts/train_test_script.R $(<)

eda: data/Credit.csv
	Rscript code/scripts/eda_script.R $(<)

ols:
	Rscript code/scripts/ols_script.R

ridge:
	Rscript code/scripts/ridge_script.R

lasso:

pcr:
	Rscript code/scripts/pcr_script.R

plsr:

slides:

session:
	Rscript code/scripts/session_info_script.R

# cleans report output
clean:
	rm report/report.pdf

# cleans all outputs from scripts
cleanall:
	rm report/report.pdf
	rm images/*.png
	rm data/*.RData
	rm data/*.txt
	rm data/*_credit.csv
	rm session_info.txt


