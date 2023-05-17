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

# Don't bother plotting, takes a while 
#prp(overFit, extra = 1)

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
#          Reference
# Prediction    no   yes
#        no  31071  2728
#        yes   847  1523
#  Accuracy : 0.9012
# Sensitivity : 0.9735               
# Specificity : 0.3583               
# Pos Pred Value : 0.9193               
# Neg Pred Value : 0.6426               
# Prevalence : 0.8825               
# Detection Rate : 0.8591               
# Detection Prevalence : 0.9345               
# Balanced Accuracy : 0.6659 



# In some data sets, we have "unbalanced" y variable data so we need to make adjustments. 
# There are multiple methods for dealing with class imbalance.  Re-sampling methods could be "ROSE: Random Over-Sampling Examples"
# or mlr::smote "Synthetic Minority Oversampling Technique "

# Here we will use oversampling of the minority and under sampling of the majority. So let's make this a really unbalanced data set as an example
currentPctYes  <- mean(trainDat$y == "yes")
desiredPctYes  <- round(nrow(trainDat) * 0.02)
numYesToRemove <- sum(trainDat$y == "yes") - desiredPctYes
yesRowIndex    <- which(trainDat$y == "yes")
drops          <- sample(yesRowIndex, numYesToRemove)
fakeUnbalance <- trainDat[-drops, ]

# Let's compare
proportions(table(fakeUnbalance$y))
proportions(table(trainDat$y))

# If you're data looks like above, you need to generate the synthetic data to rebalance:
resampledData <- ovun.sample(as.factor(y) ~., data = fakeUnbalance, method="both", 
                             na.action=options("na.action")$na.action, seed=1234)


 
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
trainCaret <- predict(fit, resampledData$data)
head(trainCaret)

# Get the conf Matrix
confusionMatrix(trainCaret, as.factor(resampledData$data$y))


# Now more consistent accuracy and accounts for class imbalance
testCaret <- predict(fit,testDat)
confusionMatrix(testCaret,as.factor(testDat$y))

# Let's compare the original to the rebalanced
fit
fitRebalance

# As an example here is how you get probabilities from predict()
testCaretProbs <- predict(fit,testDat,type = 'prob')
head(testCaretProbs)

# End
