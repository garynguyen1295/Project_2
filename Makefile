url = http://www-bcf.usc.edu/~gareth/ISL/Credit.csv

all: eda regressions report

.PHONY: all data tests eda ols ridge lasso pcr plsr regressions report slides session clean preprocessing

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

eda:

ols:

ridge:

lasso:

pcr:

plsr:

slides:

session:

clean:



