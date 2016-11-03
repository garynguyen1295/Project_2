# setting argument for Makefile
args = commandArgs(trailingOnly = TRUE)

# reading scaled credit data set
scaled_credit <- read.csv(file = args[1])

# taking out index column
scaled_credit <- scaled_credit[-1]

# setting randomized training and test sets
set.seed(400)
random_300 <- sample(nrow(scaled_credit), 300)
train <- scaled_credit[random_300,]
test <- scaled_credit[-random_300,]

# writing csv files to the data directory to be used for regression onto the training and tests data sets
write.csv(train, file = 'data/train_credit.csv')
write.csv(test, file = "data/test_credit.csv")