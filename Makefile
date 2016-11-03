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
	Rscript code/scripts/preprocessing.R $(<)

# splitting the data set to training and test sets
splitset: data/scaled_credit.csv
	Rscript code/scripts/train_test_sets.R $(<)

eda:

ols:

ridge:
	Rscript code/scripts/ridge.R

lasso:

pcr:

plsr:

slides:

session:

clean:



