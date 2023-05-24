#' Author: Ted Kwartler
#' Data: Feb 16,2023
#' Purpose: Load data, explore it and visualize it

## Set the working directory
setwd("~/Desktop/Hult_Intro2R/personalFiles")

## Load the libraries; 1st time use install.packages('ggplot2')
library(ggplot2)
library(ggthemes)
library(rbokeh)

## Bring in some data
screenTime <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/C_EDA_VIZ/data/on_screen_time.csv')
scenes     <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/C_EDA_VIZ/data/force_awakens_scenes.csv')
characters <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/C_EDA_VIZ/data/force_awakens_character_info.csv')


## Exploratory Data Analysis, and indexing; top 10 rows
...(screenTime,...)

# New Column called length
screenTime$... <- screenTime$end - screenTime$start  # add new column by taking the difference between vectors
head(screenTime)

# Dimensions
...(scenes) #dimensions: whats the order?

# Tally by factor column character
table(...$...) 

# Indexing
characters$char.story[...] #5th entry in a single column

characters[...,] #returns all columns from 7th row

characters[...,...] #21st row, 3rd column

# Subset the data when the char.name column is equal to 'Admiral Ackbar'
filteredCharacters <- subset(characters,
                             ...$...== ...)

# Random sample
set.seed(1234) #just for consistency in class
idx <- sample(1:nrow(screenTime),5) # Take 5 rows from the data set, notice the nested function

# Use idx to select the sampled rows fo screenTime
sampledData <- ...[...,]

# Create a new column, called length, for each scene
scenes$... <- scenes$end - scenes$start # same as before but different data frame

# More EDA - apply summary to a data frame scenes
...(...) #base summary stats, quartile of a named vector

# More EDA - apply summary to a single column of scenes length
...(...$...)

# Sort to find longest scenes
# Example in two lines
reorderedIndex <- order(scenes$length, decreasing=T) # get the numeric re-order
reorderedIndex # examine results

# Use the row index object to reorder the scenes DF
scenes <- ...[...,] #remember "rows, then columns" so place as the row index left of the comma

# Example in 1 line nesting functions
scenes <- scenes[order(scenes$length, decreasing=T),] #reorder the data frame by the new length column

# Examine the 10 longest scenes, more EDA
...(scenes,10) # object and number to return, default is 6 rows

# Examine the 8 shortest scenes ONLY a vector
...(scenes$defined.scenes,8) 

## Visuals
# Summarise character appearances
# Tally the screenTime character column
...(...$...)

# It has to be changed into a matrix for plotting with as.matrix
characterTally <- ...(table(screenTime$character)) #nesting functions operate inside out

# Examine the top 5 of characterTally
...(..., ...)

# Reorder the rows of characterTally
# Hint: look back and find the order() function
... <- ...[...,] # order the data frame
head(characterTally)

# Base R barplot
# Using indexing select the top 1:5 values of characterTally 
barplot(...[...], 
        main='Force Awakens: Character Scene Tally', 
        las = 2)

# Base plot() default is a scatter; here we change to line chart to see the scene drop off 
plot(characterTally, 
     main='Force Awakens: Character Scene Tally', 
     type ='l')

# Base plot() scatterplot to see start and end time relationship, possible outlier?
plot(scenes$start, 
     scenes$end, 
     main='Force Awakens: scene start & end')

# Save a basic plot to disk in the personal folder since it was set as the "working directory"
png("characterTally_plot.png")
plot(characterTally, main='Force Awakens: Character Scene Tally')
dev.off()

# BACK TO PPT FOR EXPLANATION
# ggplot2: Commented layers with ggplot to make a line plot
# The data is screenTime
# The color is done by character
# Add a geom_segment layer
# Line segments are defined by the x = start column, xend by end column, y by character column, yend by character columns
ggplot(data = ..., 
       aes(colour=...)) + # data frame then aesthetics
  ...(aes(x    = ..., 
          xend = ..., 
          y    = ..., 
          yend = ...), linewidth=3) + #add layer of segments & declare x/y 
  theme_gdocs() + #add a default "theme"
  theme(legend.position="none") # turn off the need for a legend
ggsave("character_scenes.pdf")
ggsave("character_scenes.png")
ggsave("character_scenes.jpg")

# Make a javascript small webpage for interactivity!
# HTMLwidgets:rbokeh library 
# %>% is like the ggplot + 
# Instantiate the figure 
# Add a layer with ly_points
# x is the start column
# y is the character column
# we are using the screenTime data
# points should be colored by the character column
p <- ...(legend_location = NULL) %>%
  ...(x = ..., 
      y = .., 
      data = ...,
      color = ..., 
      hover = list(character, start, end))
p

# End
