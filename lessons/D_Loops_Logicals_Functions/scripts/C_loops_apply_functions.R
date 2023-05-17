#' Author: Ted Kwartler
#' Data: May 12, 2023
#' Purpose: Use loops, and efficient code to work across multiple tables efficiently
#' https://www.kaggle.com/datasets/lokeshparab/amazon-products-dataset?select=All+Appliances.csv

## Set the working directory
setwd("~/Desktop/Hult_Intro2R/personalFiles")
options(scipen=999)

# libs
library(pbapply)
library(data.table)

# Where are all the files?
pth <- '~/Desktop/Hult_Intro2R/lessons/D_Loops_Logicals_Functions/data/amazon'

# Get their names and paths programmatically!
tmp <- list.files(path = pth, pattern = 'csv', full.names = T)

# Read in as a list and ensure names are appended
allDF <- pblapply(tmp, read.csv)
names(allDF) <- make.names(gsub('.csv','',sapply(strsplit(tmp, '/'), tail,1)))

# Examine one
head(allDF[[1]])

# If you need a specfic column from each data frame
names(allDF$Air.Conditioners)
onlyActualPrice <- lapply(allDF, '[',9)
onlyActualPrice[[1]]

# If you want a single flat table 
masterDF <- rbindlist(allDF, fill = T)
dim(masterDF)
rm(masterDF)
gc()

# Inefficient but easy to manage and understand
for(i in 1:length(allDF)){
  print(nrow(allDF[[i]]))
}

# Another method which is more efficient (fewer lines)
sapply(allDF, nrow)
# Compare
lapply(allDF, nrow)

# There is also an apply function which can work row or column wise
# We are using a different [single] data frame for the example
data(mtcars)
mtcars
apply(mtcars,1,mean, na.rm = T) #row wise; non-sense result
apply(mtcars,2, mean, na.rm = T) #column wise

# Here we apply it to our first DF to get the column-wise class for the single DF
apply(allDF$Air.Conditioners,2, class) #column wise

# To do this for all data frames we can use a loop or lapply
lapply(allDF, function(x){apply(x, 2, class)})

# Now lets examine getting the stats of rating for each df
# First remove empty data frames
sapply(allDF, nrow)>0
allDF <- allDF[sapply(allDF, nrow)>0] # single brackets!


# Let's do this for the first DF
x <- allDF[[1]]
x <- as.numeric(x$ratings)
x <- summary(x)
x
class(x)
as.matrix(x)
t(as.matrix(x))
data.frame(t(as.matrix(x)))

# Select the rating column of all DFs and 
# Loop
allRatings <- list()
for(i in 1:length(allDF)){
  print(names(allDF)[i])
  x <- allDF[[i]]
  x <- as.numeric(x$ratings)
  x <- summary(x)
  x <- data.frame(t((as.matrix(x))))
  x$numObs <- nrow(allDF[[i]])
  x$product <- allDF[[i]]$sub_category[1]
  x <- x %>% select(product, everything())
  allRatings[[names(allDF)[i]]] <- x
  
}
# Bind it together, need fill = T bc some have no NA 
allRatings <- rbindlist(allRatings, fill = T)

# Examine
head(allRatings)

# Now lets do it as a function
ratingSummary <- function(df){
  x <- summary(as.numeric(df$ratings))
  response <- data.frame(product = df$sub_category[1],
                         data.frame(t((as.matrix(x)))),
                         numObs = nrow(df))
 return(response)
}
allRatingsFunction <- lapply(allDF, ratingSummary)
allRatingsFunction <- rbindlist(allRatingsFunction, fill = T)

# Examine
allRatingsFunction

# suppose you want to see the top 2 rows from each df
# with lapply you can specific function paramters with commas
lapply(allDF, head, n = 2)


# Suppose we want to plot the relationship between price & rating for each df
# We could do this as a loop; first clean it up then extract what we want and plot it
for(i in 1:length(allDF)){
  oneDF <- allDF[[i]]
  # Ruppee  ₹
}

# We could do this using apply functions
onlyActualPrice <- lapply(allDF, '[',9)
onlyRatings     <- lapply(allDF, '[',6)

# We could do this with a custom function



# End