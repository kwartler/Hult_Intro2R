#' Author: Ted Kwartler
#' May 7, 2023
#' Purpose: start the case

# Libraries
library(ggplot2)

# Supporting functions
source("~/Desktop/Hult_Intro2R/personalFiles/openAIKey.R")
source("~/Desktop/Hult_Intro2R/lessons/B_GPT_Robjects/scripts/B_anyPromptOpenAI.R")
source("~/Documents/HultClass/lessons/B_GPT_Robjects/scripts/C_codeHelperOpenAI.R")

# Read in some case data
df <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/A1_CerealEDA/cereals.csv')

##### I would do some basic EDA and plotting of individual vars then move to more complex interactions
barplot(table(df$brand))
ggplot(data = df) + geom_histogram(aes(x=calories))
ggplot(data = df) + geom_density(aes(x=calories))

##### Example 2 way EDA
plotDF <- data.frame(table(df$brand,
                           df$dietLabels))
head(plotDF)
plotDF <- subset(plotDF, plotDF$Freq>0)

# Stacked
ggplot(data = plotDF, aes(fill=Var2, y=Freq, x=Var1)) + 
  geom_bar(position="stack", stat="identity")

# Filled
ggplot(data = plotDF, aes(fill=Var2, y=Freq, x=Var1)) + 
  geom_bar(position="fill", stat="identity")

#### Missing in some variables, maybe "mean imputation"
head(df$Vitamin.K..phylloquinone._µg)
sum(is.na(df$Vitamin.K..phylloquinone._µg))
df$Vitamin.K..phylloquinone._µg[is.na(df$Vitamin.K..phylloquinone._µg)] <- mean(df$Vitamin.K..phylloquinone._µg, na.rm=TRUE)
head(df$Vitamin.K..phylloquinone._µg)

##### Feature Engineer one of the diet types
# Multiple ways to do it but this is easiest for newbies
head(df$dietLabels)
df$HIGH_FIBER <- grepl('HIGH_FIBER', df$dietLabels)
head(cbind(df$dietLabels, df$HIGH_FIBER))
table(df$brand, df$HIGH_FIBER)

# Example use of support GPT
cat(codeHelp('create a barplot of a data frame in R.  The dataframe is called `df`.  the barplot needs to use the `brand` column which is a factor'))
barplot(table(df$brand))
cat(codeHelp('Using ggplot2, create a barplot of a data frame in R.  The dataframe is called `df`.  the barplot needs to use the `brand` column which is a factor'))
# Make a barplot of the manufacturers
ggplot(df, aes(x = brand)) + geom_bar()

# End