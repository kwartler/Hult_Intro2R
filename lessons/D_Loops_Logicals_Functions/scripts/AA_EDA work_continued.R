#' Author: Ted Kwartler
#' Data: Feb 16,2023
#' Purpose: Cereal EDA
#' 

# libs
library(radiant.data)
library(DataExplorer)
library(naniar)
library(ggplot2)

# Set WD
setwd("~/Desktop/Hult_Intro2R/personalFiles")

# Data look up on github
salary <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/C_EDA_VIZ/data/EU_salary_survey.csv')

# What's the overall structure  & dimensions of the data?
str(   )
dim(   )

# Data set class
class(    )

# Classes for each column
sapply(     , class)

# Look at the top 6 rows
head(   )

# Who are the unique cities?
unique(    )

# How many different Position?
tmp <- na.omit(salary$Position)
nlevels( as.factor(    ))
# Or
length(unique( )) 

# Compare that with NA
nlevels( as.factor(salary$Position))
length(unique(salary$Position))

# What are the column names?
names(     )

# Summary stats for each vector
summary(      )
 
# What's the relationship between Age and Current.Salary? 
cor(   ,   , use = 'complete.obs')

# Avg Yearly.bonus?
mean(     , na.rm = T)
median(     , na.rm = T)

# Number missing values?
colSums(is.na(     ))

# Sampling 5 row example (nonsense w/data this size but good to know how):
set.seed(123)
idx <- sample(1:nrow(salary),  5 )
salary[idx, ]

# Sample 10 rows
# What is the first name with seed 1234
set.seed(    )
idx <- sample(1:nrow(_____   ),   )
-------[------, ]

# DataExplorer
plot_str(salary)
plot_missing(salary)
plot_histogram(salary$Gender) 
plot_density(salary$Salary.one.year.ago) 
plot_histogram(salary)#time consuming w/big data
plot_density(salary)#time consuming w/big data

# naniar - lots of ways to perform imputation too!
gg_miss_var(salary) + 
  geom_hline(yintercept = 0.1*nrow(salary), linetype = "dashed", color = "red", linewidth = 1)
gg_miss_case(salary, order_cases = TRUE, show_pct = T)


# radiant.data
# example video: https://radiant-rstats.github.io/radiant.data/
radiant.data::radiant.data()

# End