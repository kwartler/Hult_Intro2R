#' Author: Ted Kwartler
#' Data: May 12, 2023
#' Purpose: Load data build a decision tree
#' https://archive.ics.uci.edu/ml/datasets/bank+marketing


## Set the working directory
setwd("~/Desktop/Hult_Visualizing-Analyzing-Data-with-R/personalFiles")
options(scipen=999)

## Load the libraries
library(caret)
library(rpart.plot) #visualizing
library(ROSE) #random oversample

## Bring in some data
dat <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/E_DataPrep_Rpart_RF/data/bank-full_v2.csv') 

# Partitioning
splitPercent <- round(nrow(dat) %*% .9)
totalRecords <- 1:nrow(dat)
set.seed(1234)
idx <- sample(totalRecords, splitPercent)

trainDat <- dat[idx,]
testDat  <- dat[-idx,]

## EDA
summary(trainDat)
head(testDat)

# Force a full tree (override default parameters)
overFit <- rpart(as.factor(y) ~ ., 
                 data = trainDat, 
                 method = "class", 
                 minsplit = 1, 
                 minbucket = 1, 
                 cp=-1)

# Look at all the rules!!
overFit

# Look at training classes
trainProbs <- predict(overFit, trainDat) 
head(trainProbs, 10)

# Get the final class and actuals
trainClass <- data.frame(class = colnames(trainProbs)[max.col(trainProbs)],
                         actual = trainDat$y)
head(trainClass, 10)

# Confusion Matrix
confMat <- table(trainClass$class,trainClass$actual)
confMat

# Accuracy
sum(diag(confMat))/sum(confMat)

# Now predict on the test set
testProbs <- predict(overFit, testDat)

# Get the final class and actuals
testClass<-data.frame(class  = colnames(testProbs)[max.col(testProbs)],
                      actual = testDat$y)

# Confusion Matrix
confMat <- table(testClass$class,testClass$actual)
confMat

# Accuracy
sum(diag(confMat))/sum(confMat)

# Compare that to the natural occurrence; mean response is .88 anyway!
proportions(table(dat$y))

# Start over
rm(list=ls()[-grep('dat', ls())])

# Partition
splitPercent <- round(nrow(dat) %*% .80)
totalRecords <- 1:nrow(dat)
set.seed(1234)
idx <- sample(totalRecords, splitPercent)

trainDat <- dat[idx,]
testDat  <- dat[-idx,]


## EDA
summary(trainDat)
head(trainDat)

# No modification needed in this cleaned up data set.  One could engineer some interactions though.

# Fit a decision tree with caret
set.seed(1234)
fit <- train(as.factor(y) ~., #formula based
             data = trainDat, #data in
             #"recursive partitioning (trees)
             method = "rpart", 
             #Define a range for the CP to test
             tuneGrid = data.frame(cp = c(0.0001, 0.001,0.005, 0.01, 0.05, 0.07, 0.1, .25)), 
             #ie don't split if there are less than 1 record left and only do a split if there are at least 2+ records
             control = rpart.control(minsplit = 1, minbucket = 2)) 

# Examine
fit

# Plot the CP Accuracy Relationship to adjust the tuneGrid inputs
plot(fit)

# Plot a pruned tree
pdf('bestTree.pdf')
prp(fit$finalModel, extra = 1)
dev.off()

# Make some predictions on the training set
trainCaret <- predict(fit, trainDat)
head(trainCaret)

# Get the conf Matrix
confusionMatrix(trainCaret, as.factor(trainDat$y))

# As an example here is how you get probabilities from predict()
testCaretProbs <- predict(fit,testDat,type = 'prob')
head(testCaretProbs)

# In some data sets, we have "unbalanced" y variable data so we need to make adjustments. 
# There are multiple methods for dealing with class imbalance.  Re-sampling methods could be "ROSE: Random Over-Sampling Examples"
# or mlr::smote "Synthetic Minority Oversampling Technique "

# You need to generate the synthetic data to rebalance:
resampledData <- ovun.sample(as.factor(y) ~., data = trainDat, method="both", 
                             na.action=options("na.action")$na.action, seed=1234)

# Let's compare
proportions(table(resampledData$data$y))
proportions(table(trainDat$y))


# Now we can add this rebalanced data to the train function
set.seed(1234)
fitRebalance <- train(as.factor(y) ~., 
                      data = resampledData$data, 
                      method = "rpart", 
                      tuneGrid = data.frame(cp = c(0.0001, 0.001,0.005, 0.01, 0.05, 0.07, 0.1, .25)), 
                      control = rpart.control(minsplit = 1, minbucket = 2)) 

# Slightly different results but still similar
plot(fitRebalance)


# Make some predictions on the training set
trainCaretRebalance <- predict(fitRebalance, resampledData$data)
head(trainCaretRebalance)

# Get the conf Matrix
confusionMatrix(trainCaretRebalance, as.factor(resampledData$data$y))


# Now more consistent accuracy and accounts for class imbalance
testCaretRebalance <- predict(fitRebalance,testDat)
confusionMatrix(testCaretRebalance,as.factor(testDat$y))

# Let's compare the original to the rebalanced
fit
fitRebalance

# End
