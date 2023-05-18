#' Author: Ted Kwartler
#' Data: May 17, 2023
#' Purpose: Build your own model to scan resumes, and evaluate it with KPI and bias measures
#' 
#' 

# wd
setwd("~/Desktop/Hult_Intro2R/personalFiles")

# libs 
library(ranger)

# data
df <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/G_TrustedAI_Ethics/data/HR%20Hiring%20(Bias%20%26%20Fairness).csv')
head(df)

# Sample
# partition the data into 
# 10% for variable prep
# 70% model fitting
# 20% Evaluation

# Explore
# Make some summary stats & visuals

# Modify
# For this example you can just drop the summary column
# Use vtreat design treatment and prepare the data

# Model with ranger, one with 200 trees and 500 trees
# Get the predictions for training and validation sets

# Assess
# Variable Importance
# Evaluate the Accuracy
# Make a confusion matrix
# Examine Proportional Parity



# End