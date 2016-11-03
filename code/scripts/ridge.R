credit <- read.csv('scaled-credit.csv')
credit <- credit[-1]
str(credit)

set.seed(400)
random_300 <- sample(nrow(credit), 300)
train <- credit[random_300,]
test <- credit[-random_300,]

lm_ols <- lm(Balance ~ ., data = train)

set.seed(10)
grid <- 10^seq(10, -2, length = 100)
ridge <- cv.glmnet(x = as.matrix(train[,-12]), y = as.double(train[,12]), intercept = FALSE, standardize = FALSE, alpha = 0, lambda = grid)
plot(ridge)

save(ridge, file = 'ridgeregressionmodels.RData')
lambda_opt <- ridge$lambda.min

png('mse-lamda-ridge.png')
plot(ridge)
abline(v = lambda_opt)
dev.off()