# Libraries
library(ggplot2)

# Reading credit data
setwd(file.path(getwd()))
credit = read.csv("../../data/Credit.csv", header = TRUE)


credit <- credit[-1]
head(credit)

# Descriptive statistics
# Quantitative: Income, Limit, Rating, Cards, Age, Education, Balance
sink("../../data/eda-output.txt", append = TRUE)
cat("\n")
quants <- c('Income', 'Limit', 'Rating', 'Cards', 'Age', 'Education', 'Balance')

mean_c <- apply(credit[,quants], 2, mean)
cat('mean of quantitative vars\n')
print(mean_c)
cat("\n")

min_c <- apply(credit[,quants], 2, min)
cat('minimum of quantitative vars\n')
print(min_c)
cat("\n")

max_c <- apply(credit[,quants], 2, max)
cat('maximum of quant vars\n')
print(max_c)
cat("\n")

iqr_c <- apply(credit[,quants], 2, IQR)
cat('IQR of quant vars\n')
print(iqr_c)
cat("\n")

sd_c <- apply(credit[,quants], 2, sd)
cat('Standard dev of quant vars\n')
print(sd_c)
cat("\n")

range_c <- apply(credit[,quants], 2, range)
cat('Range of quant vars\n')
print(range_c)
cat("\n")

quantile_c <- apply(credit[,quants], 2, quantile, probs = c(0.25,0.75))
cat('quantiles of quant vars\n')
print(quantile_c)

cat("\n")
sink()

#Make histograms and box plots or 

path = '../../images/'

for (index in 1:length(quants)) {
  png(paste(path, index, '_histogram.png', sep =''))
  quant <- quants[index]
  hist(credit[,quant], main = paste('Histogram of', quant), xlab = paste(quant))
  dev.off()
  
}

for (index_1 in 1:length(quants)) {
  png(paste(path, index_1, '_boxplot.png', sep =''))
  quant <- quants[index_1]
  boxplot(credit[,quant], main = paste('Boxplot of', quant))
  dev.off()
  
  }


## Make table of frequency and relative frency for qualitative variables
qualitatives <- c("Gender","Student", "Married", "Ethnicity")

## Frequency table (count)
sink("../../data/eda-output.txt", append = TRUE)
cat("\n")
cat('Frequency tables for qualitative variables\n')

Gender_freq <- with(credit, table(Gender))
print(Gender_freq)

Student_freq  <- with(credit, table(Student))
print(Student_freq)

Married_freq <- with(credit, table(Married)) 
print(Married_freq)

Ethnicity_freq <- with(credit, table(Ethnicity))
print(Ethnicity_freq)

cat('\n')
sink()
#Relative frequency tables
Gender_rel_freq <- prop.table(Gender_freq)
Student_rel_freq  <- prop.table(Student_freq)
Married_rel_freq <- prop.table(Married_freq)
Ethnicity_rel_freq <- prop.table(Ethnicity_freq)

# Bar charts for proportions
barplot(Gender_rel_freq, ylab = "proportion", main = "Relative frequency for Gender") 

barplot(Student_rel_freq, ylab = "proportion", main = "Relative frequency for Student" )
barplot(Married_rel_freq, ylab = "proportion", main = "Relative frequency for Married")
barplot(Ethnicity_rel_freq, ylab = "proportion", main = "Relative frequency for Ethnicity")

# 

#. matrix of correlations among all quantitative variables.
  
  # Correlation among numeric variables in 
   
credit_quants <- credit[,-(7:10)]
x <- credit_quants[1:4]
y <- credit_quants[5:7]
cor(x,y)


## . scatterplot matrix. 
png('../../images/scatterplot_matrix.png')
pairs(credit_quants, main = "Scatterplot matrix among quantitative variables")
dev.off()

#. anova's between Balance and all the qualitative variables (see function aov()).
sink("../../data/eda-output.txt", append = TRUE)
cat("\n")
credit_qualitatives <- credit[,7:10]
credit_qualitatives #only qualittative variables

fit <- aov(credit$Balance~credit_qualitatives$Gender+credit_qualitatives$Student
           +credit_qualitatives$Married+credit_qualitatives$Ethnicity)

print(summary(fit))
cat("\n")
sink()

#boxplots conditioning on different variables
for (index in 1:length(qualitatives)) {
  png(paste(path,index,'_conditionalBoxplots.png', sep= ''))
  qualitative <- credit_qualitatives[,index]
  qualitative_colname <- qualitatives[index]
  boxplot(credit$Balance~qualitative, main = paste('Boxplot of Balance conditional on', qualitative_colname))
  dev.off()
  }
    
