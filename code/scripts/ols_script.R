# reading in the training and test data sets
train <- read.csv(file = 'data/train_credit.csv')
train <- train[-1]
test <- read.csv(file = 'data/test_credit.csv')
test <- test[-1]

# fitting an ols regression onto the training data set
ols <- lm(Balance ~ ., data = train)

# finding the coefficients of the fitted model
ols_coef <- unname(ols$coefficients)
ols_coef_df <- data.frame('Coefficients' = names(ols$coefficients),
                       'Values' = unname(ols$coefficients))

# predictions of the test using the model fitted onto training
# test MSE is calculated
ols_pred <- predict(ols, test[,-12])
ols_mse <- mean((ols_pred - test[,12])^2)

# creating a textfile outputting the MSE & Coefficients for the fitted model
sink('data/ols_output.txt')
cat('Test MSE for OLS model\n')
print(ols_mse)
cat('\nCoefficients of OLS Model(Training Set)\n')
print(ols_coef)
sink()


# saving the model to RData output
save(ols, ols_mse, ols_coef, file = 'data/ols_model.RData')



