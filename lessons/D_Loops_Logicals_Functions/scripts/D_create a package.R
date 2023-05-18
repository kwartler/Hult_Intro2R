#' Author: Ted Kwartler
#' Data: May 18, 2023
#' Purpose: The structure of an R package
#' 

## Set the working directory TO OUR DESKTOP
setwd("~/Desktop")
options(scipen=999)

# libs
library(devtools)
library(usethis)
library(ggplot2)

# Let's initiate a package structure on our desktop
create("quickPlotHult")

# Now change directory to the R package
setwd("~/Desktop/quickPlotHult")

# Add the license
use_mit_license("Ted Kwartler")

# Add packages that this relies on
use_package("ggplot2", "Depends")

# Let's create some testing data
df <- data.frame(x = c(1,2,3), y = c(10,20,30))

# Let's add it to the package so users have a good example
use_data(df)

# Let's create a function
hultScatter <- function(df, xVecName = 'x', yVecName = 'y', chartTitle = NULL, smoothLine = T){
  p <- ggplot(data = df, aes_string(x= xVecName, y = yVecName)) + 
    geom_point() + 
    theme_classic() +
    theme(panel.background = element_rect(fill = "#FEF7E9")) +
    theme(axis.line.x.bottom=element_line(color="#AD3E49")) +
    theme(axis.line.y=element_line(color="#AD3E49"))
  
  if(is.null(chartTitle)==F){
    p <- p + ggtitle(chartTitle) +
      theme(plot.title = element_text(color = "#D27044"))
  }
  if(smoothLine==T){
    p <- p + geom_smooth(color = '#A13C87')
  }
  
  return(p)
}

# Test it out
hultScatter(df, xVecName = 'x', yVecName = 'y', chartTitle = NULL, smoothLine = T)
hultScatter(df, xVecName = 'x', yVecName = 'y', chartTitle = NULL, smoothLine = F)
hultScatter(df, xVecName = 'x', yVecName = 'y', chartTitle = 'Hult Scatter Plot', smoothLine = T)
hultScatter(df, xVecName = 'x', yVecName = 'y', chartTitle = 'Hult Scatter Plot', smoothLine = F)

# Looks ok so let's add it to the package
# Open a new R script, copy/paste it and save in the R folder as hultScatter.R
# In that script go to code>Insert Roxygen Skeleton

# Once the header is filler out add the documentation
document()

# Build the compressed installation of the entire package; since this is a sub directory on the desktop it will save it to the desktop
build()

# Now let's install it!  You can use the gui or 
install.packages("~/Desktop/quickPlotHult_0.0.0.9000.tar.gz", repos = NULL, type = "source")

# Now restart R and search for the help pages.

# End