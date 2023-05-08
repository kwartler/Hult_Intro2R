#' Author: Ted Kwartler
#' May 7, 2023
#' Purpose: start the case

# Libraries
library(ggplot2)

# Supporting functions
source("~/Desktop/Hult_Intro2R/personalFiles/openAIKey.R")
source("~/Desktop/Hult_Intro2R/lessons/B_GPT_Robjects/scripts/B_anyPromptOpenAI.R")
source("~/Desktop/Hult_Intro2R/lessons/B_GPT_Robjects/scripts/C_codeHelperOpenAI.R")

# Read in some case data
df <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/A1_CerealEDA/cereals.csv')

# Example use of support GPT
#codeHelp('create a barplot of a data frame in R.  The dataframe is called `df`.  the barplot needs to use the `brand` column which is a factor')
#barplot(table(df$brand))
#codeHelp('Using ggplot2, create a barplot of a data frame in R.  The dataframe is called `df`.  the barplot needs to use the `brand` column which is a factor')
# Make a barplot of the manufacturers
#ggplot(df, aes(x = brand)) + geom_bar()

# End