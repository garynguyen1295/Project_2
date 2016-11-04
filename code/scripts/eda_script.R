# libraries
library(ggplot2)

# setting argument for Makefile
args = commandArgs(trailingOnly = TRUE)

# Reading credit data
credit <- read.csv('http://www-bcf.usc.edu/~gareth/ISL/Credit.csv')
credit <- credit[-1]

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

# creating a textfile to show all the descriptive statistics of the data set
sink("data/eda_output.txt")
cat('Mean of Quantitative Variables\n')
print(mean_c)
cat('\nMinimum of Quantitative Variables\n')
print(min_c)
cat('\nMaximum of Quantitative Variables\n')
print(max_c)
cat('\nIQR of Quantitative Variable\n')
print(iqr_c)
cat('\nStandard deviation of Quantitative Variables\n')
print(sd_c)
cat('\nRange of Quantitative Variable\n')
print(range_c)
cat('\nQuantiles of Quantitative Variable\n')
print(quantile_c)
sink()

# plotting histograms and box plots for the quantitative variables 
path = 'images/'

for (index in 1:length(quants)) {
  png(paste0(path, tolower(quants[index]), '_histogram.png'))
  quant <- quants[index]
  hist(credit[,quant], main = paste('Histogram of', quant), xlab = paste(quant))
  dev.off()
}
for (index in 1:length(quants)) {
  png(paste0(path, tolower(quants[index]), '_boxplot.png'))
  quant <- quants[index]
  boxplot(credit[,quant], main = paste('Boxplot of', quant))
  dev.off()
}


# making tables of frequencies for qualitative variables
qualitatives <- c("Gender","Student", "Married", "Ethnicity")
gender_freq <- table(credit$Gender)
student_freq <- table(credit$Student)
married_freq <- table(credit$Married)
ethnicity_freq <- table(credit$Ethnicity)

# outputting frequency tables (count) into a textfile
sink("data/eda_output.txt", append = TRUE)
cat('\nGender Frequency Table\n')
print(gender_freq)
cat('\nStudent Frequency Table\n')
print(student_freq)
cat('\nMarried Frequency Table\n')
print(married_freq)
cat('\nEthnicity Frequency Table\n')
print(ethnicity_freq)
sink()

# making tables of relative frequencies for qualitative variables
gender_rel_freq <- prop.table(gender_freq)
student_rel_freq  <- prop.table(student_freq)
married_rel_freq <- prop.table(married_freq)
ethnicity_rel_freq <- prop.table(ethnicity_freq)


# outputting relative frequency tables (count) into a textfile
sink("data/eda_output.txt", append = TRUE)
cat('\nGender Relative Frequency Table\n')
print(gender_rel_freq)
cat('\nStudent Relative Frequency Table\n')
print(student_rel_freq)
cat('\nMarried Relative Frequency Table\n')
print(married_rel_freq)
cat('\nEthnicity Relative Frequency Table\n')
print(ethnicity_rel_freq)
sink()

# plotting barplots measuring the variables' proportions
png(paste0(path,'gender_barplot.png'))
barplot(gender_rel_freq, ylab = "Proportion", main = "Relative Frequencies for the Gender Variable") 
dev.off()

png(paste0(path,'student_barplot.png'))
barplot(student_rel_freq, ylab = "Proportion", main = "Relative Frequencies for the Student Variable" )
dev.off()

png(paste0(path,'married_barplot.png'))
barplot(married_rel_freq, ylab = "Proportion", main = "Relative Frequencies for the Married Variable")
dev.off()

png(paste0(path,'ethnicity_barplot.png'))
barplot(ethnicity_rel_freq, ylab = "Proportion", main = "Relative Frequencies for the Ethnicity Variable")
dev.off()

# matrix of correlations among all quantitative variables.
mat_corr <- cor(credit[,quants])
sink('data/eda_output.txt', append = TRUE)
cat('\nMatrix of Correlations of the Quantitative Variables\n')
print(mat_corr)
sink()

## scatterplot matrix of the quantiative variables
png('images/scatterplot_matrix.png')
pairs(credit[,quants], main = "Scatterplot Matrix among Quantitative Variables")
dev.off()

# Anova between Balance and all the qualitative variables (see function aov()).
credit_qualitatives <- credit[,c(7:10)]
fit <- aov(Balance ~ Gender + Student + Married + Ethnicity, 
           data = credit)
sink("data/eda_output.txt", append = TRUE)
cat('\nAnova between Balance and the Qualitative Variables\n')
print(summary(fit))
sink()

# creating boxplots conditioned on each qualitative variable
for (index in 1:length(qualitatives)) {
  png(paste0(path,tolower(qualitatives[index]),'_condboxplot.png'))
  qualitative <- credit_qualitatives[,index]
  qualitative_colname <- qualitatives[index]
  boxplot(credit$Balance~qualitative, 
          main = paste('Boxplot of Balance Conditional on', qualitative_colname))
  dev.off()
  }
    
