## Read data Credit.csv 
##
Credit_data <- read.csv('../../data/Credit.csv', header = TRUE )

Credit_data = Credit_data[,-1]

## Summaries of Variables
### Min, Max, Range
min
max
range(
  
### Median, First, 3rd quantiles, IQR
median()
quantile(,0) #1st quantile
quantile()   #3rd quantile
IQR()

### 
