# libraries
library(pls)

# reading in the train and test sets in addition to the full scaled credit data set
scaled_credit <- read.csv('data/scaled_credit.csv')
scaled_credit <- scaled_credit[-1]
train <- read.csv(file = 'data/train_credit.csv')
train <- train[-1]
test <- read.csv(file = 'data/test_credit.csv')
test <- test[-1]

# performing pcr onto the training set with 10 fold CV
set.seed(1454)
train_pcr <- pcr(Balance ~ ., data = train, validation = 'CV')

# finding the minimum of the principal components of the coefficients
comp_values <- train_pcr$validation$PRESS
index <- which.min(comp_values)
pcr_ncomp <- index
min_pc <- comp_values[pcr_ncomp]

# plotting the cv errors of pcr and saving the plot as a png image
png('images/pcr_cv_errors_plot.png')
validationplot(train_pcr, val.type = 'MSEP')
dev.off()

# predicting the response Balance for the model with min pc
pcr_pred <- predict(train_pcr, test[,-12], ncomp = index)

# finding the test mse of the optimal model
pcr_mse <- mean((pcr_pred - test[,12])^2)

# fitting the best pcr model with the min pc
best_pcr <- pcr(Balance ~ ., data = scaled_credit, ncomp = index)

# finding the coefficients for the best model
best_pcr_coef <- coef(best_pcr)
best_pcr_coef <- c(0,as.vector(coef(best_pcr)))

# outputting the best # of pc, mse, and coefficients to a textfile
sink('data/pcr_output.txt')
cat('Optimal number of principal components\n')
print(index)
cat('\nTest mean squared error for PCR\n')
print(pcr_mse)
cat('\nOfficial coefficients for the optimal model in PCR\n')
print(best_pcr_coef)
sink()


# saving the models to a RData file in the data directory
save(train_pcr, pcr_mse, best_pcr_coef, pcr_ncomp, file = 'data/pcr_models.RData')


