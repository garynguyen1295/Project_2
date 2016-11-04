url = http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

all: eda regressions report

.PHONY: all data tests eda ols ridge lasso pcr plsr regressions report slides session clean preprocessing splitset

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

eda:

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

clean:
	# rm report/report.pdf
	rm images/*.png
	rm data/*.RData
	rm data/*.txt
	rm data/*_credit.csv
	rm session_info.txt


