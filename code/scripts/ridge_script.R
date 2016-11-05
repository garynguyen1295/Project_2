# libraries
library(glmnet)

# reading in the train and test sets in addition to the full scaled credit data set
scaled_credit <- read.csv('data/scaled_credit.csv')
scaled_credit <- scaled_credit[-1]
train <- read.csv(file = 'data/train_credit.csv')
train <- train[-1]
test <- read.csv(file = 'data/test_credit.csv')
test <- test[-1]

# setting the grid of lambdas manually
grid <- 10^seq(10, -2, length = 100)

# performing a ridge regression onto training set with 10 fold CV
set.seed(10)
train_ridge <- cv.glmnet(x = as.matrix(train[,-12]), y = train[,12], 
                   intercept = FALSE, standardize = FALSE, alpha = 0, 
                   lambda = grid, nfolds = 10)

# finding the best lambda from the models
ridge_lambda <- train_ridge$lambda.min
best_lambda <- ridge_lambda

# plotting the cv erros of the ridge regression and saving the plot as a png image
png('images/ridge_cv_errors_plot.png')
plot(train_ridge)
abline(v = best_lambda)
dev.off()

# predicting the response Balance with the model with best lambda
ridge_pred <- predict(train_ridge, as.matrix(test[,-12]), s = best_lambda)

# finding the test mse of the optimal model
ridge_mse <- mean((ridge_pred - test[,12])^2)

# fitting the best ridge model with the optimal lambda
best_ridge <- glmnet(x = as.matrix(scaled_credit[,-12]), y = scaled_credit[,12], 
                   intercept = FALSE, standardize = FALSE, alpha = 0, 
                   lambda = best_lambda)

# outputting the regression coefficients after reformatting the dfC matrix 
# Intercept is 0 after standardizing/centering
best_ridge_coef <- coef(best_ridge)
coef_names <- best_ridge_coef@Dimnames[[1]]
coef_values <- best_ridge_coef@x
coef_values <- c(0,coef_values)
best_ridge_coef <- data.frame('Coefficients' = coef_names, 'Values' = coef_values)

# outputting the best lambda, mse, and coefficients to a textfile
sink('data/ridge_output.txt')
cat('Best lambda for ridge regression\n')
print(ridge_lambda)
cat('\nTest mean squared error using the best lambda\n')
print(ridge_mse)
cat('\nOfficial coefficients for the optimal model\n')
print(best_ridge_coef)
sink()

# saving the models to a RData file in the data directory
save(train_ridge, best_ridge_coef, ridge_lambda, ridge_mse, file = 'data/ridge_models.RData')

