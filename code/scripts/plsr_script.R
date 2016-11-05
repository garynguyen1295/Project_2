# loading required packages
library(pls)

# importing train and test data
scaled_credit <- read.csv("data/scaled_credit.csv", stringsAsFactors = FALSE)
scaled_credit <- scaled_credit[-1]
train <- read.csv("data/train_credit.csv")
train <- train[-1]
test <- read.csv(file = 'data/test_credit.csv')
test <- test[-1]

# 10-fold cross validation (using training data)
set.seed(10)
plsr_cv_out <- plsr(Balance ~ ., data = train[,-c(2:3)], validation = "CV")

# Best model
plsr_PRESS <- min(plsr_cv_out$validation$PRESS)
plsr_ncomp_all <- plsr_cv_out$validation$PRESS
plsr_ncomp_use <- which(plsr_ncomp_all[1,]==plsr_PRESS)
plsr_ncomp <- plsr_ncomp_use[[1]]

#plot cross-validation errors
png("images/plsr_cv_errors_plot.png")
validationplot(plsr_cv_out, val.type = "MSEP")
dev.off()

# compute test mse using test data
x_test = as.matrix(test[,-c(2:3,12)])
y_test = test[,12]
plsr_pred = predict(plsr_cv_out, newx = x_test, ncomp = plsr_ncomp)
plsr_test_mse = mean((plsr_pred - y_test)^2)

# full model
plsr_full <- plsr(Balance ~., data = test[,-c(2:3)], ncomp = plsr_ncomp)

# coefficients of plsr model
plsr_coef <- coef(plsr_full)

#Save output
sink(file = "data/pls_output.txt")
writeLines("Partial Least Squares")
writeLines("Best number of components")
plsr_ncomp
writeLines("Summary of pls model")
summary(plsr_full)
writeLines("Test MSE")
plsr_test_mse
sink()

# save objects to file
save(plsr_cv_out, plsr_test_mse, plsr_ncomp, plsr_coef,file = "data/plsr_models.RData")

