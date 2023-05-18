#' Author: Ted Kwartler
#' Data: May 18, 2023
#' Purpose: Logical operators and conditional statements
#' 
#' 

# library
library(tidyr)

# Built in data
data(population)
head(population)
population <- as.data.frame(population)

# Obj1: Understand what logical operators are in programming.
#  ==, !=, <, >, <=, >=, !, &, |

# comparing values
4 == 4  #"is equal"
4 == 3  
4 != 3  # ! is the negation (flips)
4 != 4 
4 < 5   # less than
6 > 7   # greater than
5 <= 5  # less than or equal
7 >= 5  # greater than or equal

# flipping logic
!(4 == 5)  # TRUE
!(4 == 4)  # FALSE

# combining conditions
(4 < 5) & (5 < 6)  # And
(4 == 5) | (5 == 5)  # Or

# Obj2: Recognize and apply common logical operators in R.

# Common use: subset & filter
AfghanistanPop <- population[population$country=='Afghanistan',]
AfghanistanPop

# And operation
AfghanistanPop2000 <- population[(population$country=='Afghanistan'& population$year>=2000) ,]
AfghanistanPop2000

# Or Operation
AfghanistanPakistanIndia <- population[(population$country=='Afghanistan'|
                                          population$country=='Pakistan'|
                                          population$country=='India'|
                                          population$country=='NOT A COUNTRY'),]
table(AfghanistanPakistanIndia$country)

# Negate selections
notAfghanistanPakistanIndia <- population[!(population$country=='Afghanistan'|
                                            population$country=='Pakistan'|
                                            population$country=='India'),]
head(notAfghanistanPakistanIndia)

# Obj3: Conditional Expectations

# if statements checks one logical condition (not a vector)
if(Sys.Date()>"2023-05-17"){
  # Code to execute if true
  print('today is past 5-17-23')
}

# if else checks one logical condition (not a vector) and gives an alternate set of instructions
# Create an example value
x <- 5L #explicit declaration as an integer
y <- 3.14

if (is.integer(x)) {
  print("whole number")
  } else {
  print("floating-point numeric")
    }

# Check if y is an integer or a floating point numeric
if (is.integer(y)) {
  print("whole number")
  } else {
  print("floating-point numeric")
    }


# ifelse statements gives a vectorized version of ifelse
fakeVec <- c(1,2,3,4)
ifelse(fakeVec %% 2 == 0, "even", "odd")

# Another example
fakeVec <- c(2, 4, -3, 8, -5, 0)
result <- ifelse(fakeVec > 0, "positive", 
                 ifelse(fakeVec < 0, "negative", "zero"))
result

# switch statements are more efficient than nested ifelse;
# here we test one value against 5 options
switch('a',
       "a" = "Letter A",
       "b" = "Letter B",
       "c" = "Letter C",
       "d" = "Letter D",
       "e" = "Letter E")

# Swtich with a default
switch('z',
       "a" = "Letter A",
       "b" = "Letter B",
       "c" = "Letter C",
       "d" = "Letter D",
       "e" = "Letter E",
       'some default value') # notice how anything now found will "default" to this

# It needs to be nested in an apply function to work on a vector of a loop
fakeVec <- c('Male',
                  'Female',
                  'Non-binary/genderqueer',
                  'Transgender',
                  'Non-binary',
                  'Two-spirit',
                  'Genderfluid',
                  'Agender',
                  'Other',
                  'Unknown',
                  'Missing',
                  'NA',
                  'Prefer not to say')

result <- sapply(fakeVec, function(x) {
  switch(x,
         "Male"                   = "Letter A",
         "Female"                 = "Letter B",
         "Non-binary/genderqueer" = "Letter C",
         "Non-binary"             = "Letter C", #can be used for grouping similar
         "Transgender"            = "Letter E",
         'Letter F') # default for all other levels
})



# End