credit <- read.csv('http://www-bcf.usc.edu/~gareth/ISL/Credit.csv')
str(credit)
credit <- credit[-1]
str(credit)

temp_credit <- model.matrix(Balance ~ ., data = credit)
new_credit <- cbind(temp_credit[ ,-1], Balance = credit$Balance)
scaled_credit <- scale(new_credit, center = TRUE, scale = TRUE)
write.csv(scaled_credit, file = "scaled-credit.csv")