# Libraries
library(ggplot2)

# Reading credit data
credit <- read.csv(file = 'http://www-bcf.usc.edu/~gareth/ISL/Credit.csv')
credit <- credit[-1]
head(credit)

# Descriptive statistics
# Quantitative: Income, Limit, Rating, Cards, Age, Education, Balance
quants <- c('Income', 'Limit', 'Rating', 'Cards', 'Age', 'Education', 'Balance')
mean_c <- apply(credit[,quants], 2, mean)
min_c <- apply(credit[,quants], 2, min)
max_c <- apply(credit[,quants], 2, max)
iqr_c <- apply(credit[,quants], 2, IQR)
sd_c <- apply(credit[,quants], 2, sd)
range_c <- apply(credit[,quants], 2, range)
quantile_c <- apply(credit[,quants], 2, quantile, probs = c(0.25,0.75))

for (index in 1:length(quants)) {
  quant <- quants[index]
  hist(credit[,quant], main = paste('Histogram of', quant), xlab = paste(quant))
  boxplot(credit[,quant], main = paste('Boxplot of', quant))
}







