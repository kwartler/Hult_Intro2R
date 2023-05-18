#' Author: Ted Kwartler
#' Data: May 17, 2023
#' Purpose: Ethics of DS example
#' 
#' 

# wd
setwd("~/Desktop/Hult_Intro2R/personalFiles")

# libs 
library(rpart)
library(rpart.plot)
library(MLmetrics)
library(fairness)

# data
df <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/G_TrustedAI_Ethics/data/university_admission.csv')
head(df)

# Sample
idx <- sample(1:nrow(df), .8*nrow(df))
training   <- df[idx,]
validation <- df[-idx,]

# Explore
table(training$accepted)
table(training$gender)
cor(training$gpa, training$aptitude_test)
hist(training$admissions_interview_1)
hist(training$admissions_interview_2)
plot(density(training$sat))
cor(training$sat, training$gpa)
aggregate(accepted~gender, training, mean)

# Modify
training$avgQuestionScore <- apply(training[,5:6],1,mean)

# Sensitive Feature
drop <- 'gender'

# Fit
tree <- rpart(as.factor(accepted)~., training[,!(names(training) %in% drop)], cp = 0.01)
prp(tree)

# Predict - training
trainingPreds <- predict(tree, training)
trainingPreds <- as.data.frame(trainingPreds)
trainingPreds$class <- ifelse(trainingPreds[,1]>0.5,0,1)
trainingPreds$actual <- training$accepted

# Predict - validation
validation$avgQuestionScore <- apply(validation[,5:6],1,mean)
validPreds <- predict(tree, validation)
validPreds <- as.data.frame(validPreds)
validPreds$class <- ifelse(validPreds[,1]>0.5,0,1)
validPreds$actual <- validation$accepted

# Evals
table(trainingPreds$class, trainingPreds$actual)
table(validPreds$class, validPreds$actual)

Accuracy(trainingPreds$class, trainingPreds$actual)
Accuracy(validPreds$class, validPreds$actual)

# What about accuracy by gender
trainingPreds$gender <- training$gender
acc_parity(data = trainingPreds, outcome = 'actual', group = 'gender',
           probs = '0', cutoff = 0.5, base = 'Male')
# Let's raise the bar for parity among gender.  
acc_parity(data = trainingPreds, outcome = 'actual', group = 'gender',
           probs = '0', cutoff = 0.8, base = 'Male')


# What about equal odds of both outcomes: same true positive rate **and** true negative rate for all groups. Perform equally well in predicting the outcomes (accept & reject) for both genders
equal_odds(data = trainingPreds, outcome = 'actual', group = 'gender',
           probs = '0', cutoff = 0.5, base = 'Male')

# What about proportional parity: We want the proportion of people **selected** for the school to be equal for both groups. 
# Its wrong at the same proportion/rate as was observed in the data 
prop_parity(data = trainingPreds, outcome = 'actual', group = 'gender',
           probs = '0', cutoff = 0.5, base = 'Male')

# So we have proxy information.  Let's now find it and then mitigate it.  One method is predicting on the sensitive feature.
# Another is correlation to see which is correlated to the sensitive variable
genderFlag <- ifelse(training$gender=='Male',1,0)
corMat <- cor(data.frame(training[,2:9],genderFlag))
corMat[,ncol(corMat)]

# Refit without it
proxyVars <- c(drop,'admissions_interview_2','gpa',
               'extracurricular_score','avgQuestionScore')
treeRefit <- rpart(as.factor(accepted)~., training[,!(names(training) %in% proxyVars)], cp = 0.01)
prp(treeRefit)

# Refit preds
trainingReFitPreds <- predict(treeRefit, training)

refitResults <- data.frame(actual = trainingPreds$actual, 
                           class  = ifelse(trainingReFitPreds[,1]>0.5,0,1),
                           preds  = trainingReFitPreds[,1],
                           gender = training$gender)

# Quick Eval
Accuracy(refitResults$class, refitResults$actual)
acc_parity(data = refitResults, outcome = 'actual', group = 'gender',
           probs = 'preds', cutoff = 0.5, base = 'Male')

# It's an improvement but still not ideal!  More xvars, and penalizing is another way to improve results. 

# End