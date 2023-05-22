#' Title: A_demo_script.R
#' Purpose: Get some R time!
#' Author: TK
#' Date: Feb 16, 2023

# Step 1 Set the working directory: where's the fruit? Where should I save my outputs?
setwd("~/Desktop/Hult_Intro2R/personalFiles")

# Step 2 Load some libraries: Make R a customized piece of software
options(scipen = 999)
library(ggplot2)
library(ggthemes)

# Input to script used later
movieTitle <- 'Mary Poppins' #Star Wars #Lego Movie

# Step 3 Bring in some data: Go get our banana!
# Choose your movie
moviePoppins <- 'https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/A_Intro_Administrative/data/poppins_definedScenes.csv'
movieStarWars <- 'https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1/A_Mar21/data/forceAwakens_definedScenes.csv'
movieLego <- 'https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/A_Intro_Administrative/data/lego_definedScenes.csv'
scenesDF <- read.csv(moviePoppins)

# Step 4 Apply functions: Perform the task we want on our data: Cut & Peel our banana!

# Use the names function to review the names of scenesDF
names(scenesDF)

# Review the bottom 6 records of scenesDF
tail(scenesDF)

# Clean up the raw data with a "global substitution"
scenesDF$id <- gsub('/xray/scene/', "", scenesDF$id)
tail(scenesDF)

# Change ID class from string to numeric
scenesDF$id <- as.numeric(scenesDF$id)

# Remove a column
scenesDF$fictionalLocation <- NULL

# Make a new column & review
scenesDF$length <- scenesDF$end - scenesDF$start 
head(scenesDF$length)

# Basic statistics
summary(scenesDF) 

# Adjust the duration and time for minutes not milliseconds
scenesDF$start  <- (scenesDF$start/1000) /60
scenesDF$end    <- (scenesDF$end/1000) /60
scenesDF$length <- (scenesDF$length/1000) /60

# Apply a logical operator
plotDF <- switch(movieTitle,
                 'Mary Poppins' = scenesDF,
                 'Star Wars'    = scenesDF[1:38,],
                 'Lego Movie'   = scenesDF[1:15,])

# Review the change (unless Mary Poppins)
dim(scenesDF)
dim(plotDF)

# Step 5: Consume our results: Plot/Eat the banana!
# We removed the bonus features and are only looking at the first 38 scenes
ggplot(plotDF, aes(colour=name)) + 
  geom_segment(aes(x=start, xend=end,
                   y=id, yend=id),linewidth=3) +
  geom_text(data = plotDF, aes(x=end, y=id,  label = name), 
            size = 2.25,color = 'black', alpha = 0.5, check_overlap = TRUE) + 
  theme_gdocs() + theme(legend.position="none") +
  ggtitle(movieTitle)
# End
