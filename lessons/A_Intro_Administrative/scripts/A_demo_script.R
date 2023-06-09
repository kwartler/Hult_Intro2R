#' Title: A_demo_script.R
#' Purpose: Get some R time!
#' Author: TK
#' Date: Feb 16, 2023

# Step 1 Set the working directory: where's the fruit? Where should I save my outputs?
setwd("...")

# Step 2 Load ggplot2, ggthemes
options(scipen = 999)
library(...)
library(...)

# Input to script used later
movieTitle <- '...' #Star Wars #Lego Movie #Mary Poppins

# Step 3 Bring in some data: Go get our banana!
# Choose your movie
moviePoppins <- 'https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/A_Intro_Administrative/data/poppins_definedScenes.csv'
movieStarWars <- 'https://raw.githubusercontent.com/kwartler/Hult_Visualizing-Analyzing-Data-with-R/main/BAN1/A_Mar21/data/forceAwakens_definedScenes.csv'
movieLego <- 'https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/A_Intro_Administrative/data/lego_definedScenes.csv'

# Get the data
scenesDF <- read.csv('...')

# Step 4 Apply functions: Perform the task we want on our data: Cut & Peel our banana!

# Use the names() function to review the names of scenesDF
...(...)

# Review the bottom 6 records of scenesDF
tail(...)

# Clean up the raw data id column with a "global substitution" gsub() function
scenesDF$id <- ...('/xray/scene/', "", scenesDF$id)
tail(scenesDF)

# Change ID class from string to numeric
scenesDF$... <- as.numeric(...$id)

# Remove the fictionalLocation column
scenesDF$... <- NULL

# Make a new column called length & review
scenesDF$length <- ...$end - scenesDF$... 
head(...$...)

# Basic statistics for the entire DF
summary(...) 

# Adjust the start, end, and length time for minutes not milliseconds
scenesDF$start  <- (scenesDF$.../1000) /60
scenesDF$end    <- (scenesDF$.../1000) /60
scenesDF$length <- (scenesDF$.../1000) /60

# Apply a logical operator
plotDF <- switch(movieTitle,
                 'Mary Poppins' = scenesDF,
                 'Star Wars'    = scenesDF[1:38,],
                 'Lego Movie'   = scenesDF[1:15,])

# Review the change (unless Mary Poppins)
dim(...)
dim(...)

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
