# setting argument for Makefile
args = commandArgs(trailingOnly = TRUE)

# reading credit data set
raw_credit <- read.csv(file = args[1])
str(raw_credit)

# taking out index column
raw_credit <- raw_credit[-1]
str(raw_credit)

# transforming categoricala variables into dummy variables
temp_credit <- model.matrix(Balance ~ ., data = raw_credit)

# taking out intercept column and adding Balance columns
new_credit <- cbind(temp_credit[ ,-1], Balance = raw_credit$Balance)

# standardizine and centering the variables
scaled_credit <- scale(new_credit, center = TRUE, scale = TRUE)

# writing the data set to the data directory to be used for regression
write.csv(scaled_credit, file = "data/scaled_credit.csv")