# Libraries
library(ggplot2)

# Reading credit data
setwd(file.path(getwd()))
credit = read.csv("../../data/Credit.csv", header = TRUE)


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

#Make histograms and box plots or 
for (index in 1:length(quants)) {
  quant <- quants[index]
  hist(credit[,quant], main = paste('Histogram of', quant), xlab = paste(quant))
  boxplot(credit[,quant], main = paste('Boxplot of', quant))
}


## Make table of frequency and relative frency for qualitative variables
qualitatives <- c("Gender","Student", "Married", "Ethnicity")

freq_c <- apply(credit[,qualitatives],2, with)

table(freq_c)

data.frame(freq_c)
with(freq_c)

## Frequency table (count)
Gender_freq <- with(credit, table(Gender))
Student_freq  <- with(credit, table(Student))
Married_freq <- with(credit, table(Married)) 
Ethnicity_freq <- with(credit, table(Ethnicity))

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
pairs(credit_quants, main = "Scatterplot matrix among quantitative variables")

#. anova's between Balance and all the qualitative variables (see function aov()).

credit_qualitatives <- credit[,7:10]
credit_qualitatives #only qualittative variables

fit <- aov(credit$Balance~credit_qualitatives$Gender+credit_qualitatives$Student
           +credit_qualitatives$Married+credit_qualitatives$Ethnicity)
summary(fit)

#boxplots conditioning on different variables
for (index in 1:length(qualitatives)) {
  qualitative <- credit_qualitatives[,index]
  qualitative_colname <- qualitatives[index]
  boxplot(credit$Balance~qualitative, main = paste('Boxplot of Balance conditional on', qualitative_colname))
  }
    
