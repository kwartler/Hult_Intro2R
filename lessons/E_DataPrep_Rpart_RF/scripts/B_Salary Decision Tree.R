#' Author: Ted Kwartler
#' Data: May 12, 2023
#' Purpose: Load data build a decision tree
#' https://archive.ics.uci.edu/ml/datasets/bank+marketing


## Set the working directory
setwd("~/Desktop/Hult_Intro2R/personalFiles")
options(scipen=999)

## Load the libraries
library(caret)
library(rpart.plot) #visualizing
library(vtreat)
library(MLmetrics)
library(datawizard)

## Bring in some data
dat <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/D_Loops_Logicals_Functions/data/ds_salaries.csv') 

# We can adjust what variables are in the model easily here:
keeps <- c('experience_level','employment_type','company_size',
           'employee_residence','company_location','remote_ratio')
target <- 'salary_in_usd'
dat <- dat[,c(keeps,target)]


# Prep and non prep
set.seed(2023)
idxPrep        <- sample(1:nrow(dat),.1*nrow(dat))
prepData    <- dat[idxPrep,]
nonPrepData <- dat[-idxPrep,]

# Create the plan.  Some factor levels occur infrequently which will cause model errors so this makes it fault tolerant.
plan <- designTreatmentsN(prepData, varlist = keeps, outcomename = target)

# Now partition to avoid overfitting for model training and validation
set.seed(1234)
idx        <- sample(1:nrow(nonPrepData),.8*nrow(nonPrepData))
train      <- nonPrepData[idx,]
test       <- nonPrepData[-idx,]

# Now apply the variable treatment plan
treatedTrain <- prepare(plan, train)
treatedTest  <- prepare(plan, test)

## EDA and you can compare to the treated data
summary(train)
summary(treatedTrain)
head(train)
head(treatedTrain)

# Build a decision tree with a continuous outcome
regTree <- rpart(salary_in_usd~., treatedTrain, method = 'anova')
regTree

# Build the tree with caret
set.seed(1234)
fit <- train(salary_in_usd ~., 
             data = treatedTrain, 
             method = "rpart", 
             tuneGrid = data.frame(cp = c(0.0001, 0.001,0.005, 0.01, 0.05, 0.07, 0.1, .25)), 
             control = rpart.control(minsplit = 1, minbucket = 2, method = 'anova')) 
plot(fit)
## WARNING: There were missing values in resampled performance measures.
# The most likely case is that the tree did not find a good split and used the average of the outcome as the predictor.  This is usually ok.

# Organize for Assessment
trainPreds <- predict(fit, treatedTrain)
resultsDF <- data.frame(preds = round(trainPreds), actual = treatedTrain$salary_in_usd)
head(resultsDF)

# KPI
MLmetrics::RMSE(resultsDF$preds,resultsDF$actual)
MLmetrics::MAPE(resultsDF$preds,resultsDF$actual)

# Assess the test set
testPreds <- predict(fit, treatedTest)
resultsDF <- data.frame(preds = round(testPreds), actual = treatedTest$salary_in_usd)
head(resultsDF)

# KPI
MLmetrics::RMSE(resultsDF$preds,resultsDF$actual)
MLmetrics::MAPE(resultsDF$preds,resultsDF$actual)

# This dataset has some outliers which is impacting the model.  Similar to the classification being unbalanced
# One can make adjustments to the data ie. remove outliers, or use log() on the y variable
plot(density(treatedTrain$salary_in_usd))
plot(sort(log(treatedTrain$salary_in_usd))) # the model should ID the middle range, with the most records more easily

# Try with log
set.seed(1234)
fit <- train(log(salary_in_usd) ~., 
             data = treatedTrain, 
             method = "rpart", 
             tuneGrid = data.frame(cp = c(0.0001, 0.001,0.005, 0.01, 0.05, 0.07, 0.1, .25)), 
             control = rpart.control(minsplit = 1, minbucket = 2, method = 'anova')) 
plot(fit)

# Organize for Assessment
trainPreds <- predict(fit, treatedTrain)

# Now we use exponentiation to reverse the log
resultsDF <- data.frame(preds = round(exp(trainPreds)), actual = treatedTrain$salary_in_usd)
head(resultsDF)
## You can see how the log version gets closer to outlier values now:
# LOG            row1:  21606  18053
# VS
# ORIGINAL model row1:  50476  18053

# KPI - similar results overall so not deteriorization of the model!
MLmetrics::RMSE(resultsDF$preds,resultsDF$actual)
MLmetrics::MAPE(resultsDF$preds,resultsDF$actual)

# Now to apply to the test set for assessment
# Organize for Assessment
testPreds <- predict(fit, treatedTest)

# Now we use exponentiation to reverse the log
resultsDF <- data.frame(preds = round(exp(testPreds)), actual = treatedTest$salary_in_usd)
head(resultsDF)

# KPI - 
MLmetrics::RMSE(resultsDF$preds,resultsDF$actual)
MLmetrics::MAPE(resultsDF$preds,resultsDF$actual)

# Another method is called Winsorization: caps outlier values to a range and replaces them with the upper or lower of the capped range. Library: datawizard::threshold becomes a tuning parameter.  Here anything in the bottom or top decile is changed to the decile cutoff.  Think of it like grouping low values and high values to some min/max bin
# Compare
hist(treatedTrain$salary_in_usd)
hist(newSalary)

# Cap the outcomes
newSalary <- winsorize(treatedTrain$salary_in_usd, threshold = 0.1)

# Now let's refit 
set.seed(1234)

# Keeping the original in case you want to make comparisons we duplicate the training data.
winsorTraining <- treatedTrain
winsorTraining$salary_in_usd <- newSalary

# Winsor model
fitW <- train(salary_in_usd ~., 
             data = winsorTraining, 
             method = "rpart", 
             tuneGrid = data.frame(cp = c(0.0001, 0.001,0.005, 0.01, 0.05, 0.07, 0.1, .25)), 
             control = rpart.control(minsplit = 1, minbucket = 2, method = 'anova')) 
plot(fitW)

# Organize for Assessment
trainPreds <- predict(fitW, winsorTraining)

# Now we use exponentiation to reverse the log
resultsDF <- data.frame(preds = round(trainPreds), actual = winsorTraining$salary_in_usd)
head(resultsDF)

# KPI - improved results! Keep in mind we are capturing the majority/mean outcomes and lumping in everyone else on the tails.
MLmetrics::RMSE(resultsDF$preds,resultsDF$actual)
MLmetrics::MAPE(resultsDF$preds,resultsDF$actual)

# Test set check requires an adjustment to the test set too.
winsorTest <- treatedTest

# Define the new min and max values
summary(newSalary)
newMin <- min(newSalary)
newMax <- max(newSalary)

# Replace the outliers in `salary_in_usd`, probably could have used switch() but this is short too
winsorTest$salary_in_usd <- ifelse(winsorTest$salary_in_usd < newMin,newMin,winsorTest$salary_in_usd)
winsorTest$salary_in_usd <- ifelse(winsorTest$salary_in_usd > newMax,newMax,winsorTest$salary_in_usd)

# Get predictions
testPreds <- predict(fitW, winsorTest)

# Now we use exponentiation to reverse the log
resultsDF <- data.frame(preds = round(testPreds), actual = winsorTest$salary_in_usd)
head(resultsDF)

# KPI - consistent results!
MLmetrics::RMSE(resultsDF$preds,resultsDF$actual)
MLmetrics::MAPE(resultsDF$preds,resultsDF$actual)

# End
