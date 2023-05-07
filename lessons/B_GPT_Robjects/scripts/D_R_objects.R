#' Author: Ted Kwartler
#' May 7, 2023
#' Purpose: Explore Data Types
#' 


# Numeric Vector; use the "combine" function c()
c(1,10,12,3.47)

# Boolean Vector: R recognized Boolean at 1,0
# Best practice is to spell it all out but I dont ;)
c(T, T, F, T, F)
c(TRUE,TRUE, FALSE, TRUE,FALSE)
c(T,TRUE, F, TRUE,FALSE)
sum(c(T, T, F, T, F))

# Factor Vectors: repeatable "levels" of information
# R doesn't care about single or double quotes but they must be closed!  
# Dont mix them.
as.factor(c('MALE','FEMALE','FEMALE'))
as.factor(c("MALE","FEMALE","FEMALE"))

# You can makde ordinal factors
#"Ordered factors differ from factors only in their class, 
# but methods and the model-fitting functions treat 
# the two classes quite differently."
factor(c('first', 'second','third', 'fourth'), ordered = T) #alphabetical!!
factor(c('first', 'second','third', 'fourth'), 
       ordered = is.ordered(c('first', 'second','third', 'fourth'))) #in order submitted

# can work for changing numbers to factors with levels ie 1st, 2nd, 3rd
factor(1:10, order=T)

# String Vectors: natural language, can be much longer and even documents
c('MALE','FEMALE','FEMALE')
c('I love the class', 'learning R is easy', 'this part is boring!')

# Matrix
as.matrix(warpbreaks[1:10, ])

# Data Frame
warpbreaks[1:10, ]

# Attributes of an object contain meta-information and can have unique identifiers
attributes(warpbreaks[1:10,])


# List craziness!
singleVal  <- 123
singleDF   <- data.frame(vec=c(1,2,3), vec2=c(4,5,6))
singleVec  <- c(T,T,F,F,F)

# Construct list
listA <- list(singleVal=singleVal,
              singleDF=singleDF,
              singleVec=singleVec)

# Get the first element of the list
listA[[1]]

# Get the 2nd element of the list
listA[[2]]

# Get the 3rd element of the list
listA[[3]]

# Get the 3rd element, first object
listA[[3]][1]

# Get the 2nd element, second column
listA[[2]][,2]

# Get the 2nd element, 1sr row
listA[[2]][1,]

# Its a best practice to name each element as the list complexity grows
listA$singleVec
listA$singleDF$vec
listA$singleVal

# When in doubt call class()
class(warpbreaks)
class(listA)

# Or check the structuture with str()
str(warpbreaks)
str(listA)

# Sometimes you or other packages will create non-standard class objects
class(warpbreaks)


# First create the class
fakeClass  <- setClass("fakeClass", slots = c(x="numeric", y="character"))
someObject <- fakeClass(x = 1:10, y = letters[1:10])
class(someObject)
str(someObject)

# Another example of an entire object
# Define a new class `superDF` that inherits from 'data.frame'
setClass("superDF", contains = "data.frame", slots = c('data.frame','secretCode'))

# Create a new object of 'superDF' class
warpSuperDF <- new("superDF", warpbreaks, secretCode = 'somethingSecret')

# Check the classes of the object
class(warpSuperDF)
str(warpSuperDF)
attributes(warpSuperDF)

# End