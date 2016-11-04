# Lasso linear regression

# Call the library 
library(ggplot2)
library(glmnet)

# Read the dataset
scaled_credit <- read.csv("data/scaled_credit.csv", stringsAsFactors=FALSE)
scaled_credit <- scaled_credit[-1]

# import train and test data
train <- read.csv("data/train_credit.csv", header = TRUE )
credit = read.csv("data/Credit.csv", header = TRUE)
train <- read.csv("data/train_credit.csv", header = TRUE)
train <- train[-1]
test <- read.csv(file = 'data/test_credit.csv')
test <- test[-1]

# setting the grid of lambdas manually
grid <- 10^seq(10, -2, length = 100)

# Perform 10-fold cross validation (using training data)
# performing a lasso regression onto training set with 10 fold CV
set.seed(10)
train_lasso <- cv.glmnet(x = as.matrix(train[,-12]), y = train[,12], 
                         intercept = FALSE, standardize = FALSE, alpha = 1, 
                         lambda = grid, nfolds = 10)

# save outputs from 10-fold cv
save(train_lasso, file = "data/lasso_models.RData")

# finding the best lambda from the models
best_lambda <- train_lasso$lambda.min

# plotting the cv erros of the lasso regression and saving the plot as a png image
png("images/lasso_cv_errors_plot.png")
plot(train_lasso)
abline(v = best_lambda)
dev.off()

# predicting the response Balance with the model with best lambda
lasso_pred <- predict(train_lasso, as.matrix(test[,-12]), s = best_lambda)

# finding the test mse of the optimal model
lasso_mse <- mean((lasso_pred - test[,12])^2)

# fitting the best lasso model with the optimal lambda
best_lasso <- glmnet(x = as.matrix(scaled_credit[,-12]), y = scaled_credit[,12], 
                     intercept = FALSE, standardize = FALSE, alpha = 1, 
                     lambda = best_lambda)

# Intercept is 0 after standardizing/centering
best_lasso_coef <- coef(best_lasso)
coef_names <- best_lasso_coef@Dimnames[[1]]
coef_values <- seq(0, length.out = length(coef_names))
coef_values <- coef_values + best_lasso_coef@x
best_lasso_coef <- data.frame('Coefficients' = coef_names, 'Values' = coef_values)



# outputting the best lambda, mse, and coefficients to a textfile
sink('data/lasso-output.txt')
cat('Best lambda for Lasso regression\n')
print(best_lambda)
cat('\nTest mean squared error using the best lambda\n')
print(lasso_mse)
cat('\nOfficial coefficients for the optimal model\n')
print(best_lasso_coef)
sink()     
     
