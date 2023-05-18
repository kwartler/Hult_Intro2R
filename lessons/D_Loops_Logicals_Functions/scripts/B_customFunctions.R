#' Author: Ted Kwartler
#' Data: May 18, 2023
#' Purpose: Start building custom functions
#' 

# Let's examine a base-R function
rnorm
rnorm()

# or from a package
ggthemes::theme_few
ggthemes::theme_gdocs


## Obj 1: Basic Function Structure
# Create a simple function that has two arguments to sum.
# Call the function twoInputSum 
# Parameter 1: firstNum
# Parameter 2: secondNum

# Call the function with 1,2

# Call the function with 100,200

# Rewrite the function to return a named list that includes the inputs and the sum

# Re-Call the function with 1, 2 & examine the output


# Re-Call the function with 342, 567 & examine the output

## Obj 2: Adding Defaults
# Create a simple function that has three arguments to multiply.
# Call the function threeDigitMultiply 
# Parameter 1: firstNum
# Parameter 2: secondNum
# Parameter 3: thirdNum

# Call the function with only 2 inputs: 2 & 4.  What happens?

# Call the function with 3 inputs, 2, 4, & 6.  

# Rewrite the function so that parameter 3: `thirdNum` has a default value of 10 

# Call the function with only 2 inputs: 2 & 4.  What happens?

# Call the function with 3 inputs, 2, 4, & 6.  

## Obj 3: Runtime assertions
# Call threeDigitMultiply with the following inputs:
# Parameter 1: firstNum 2
# Parameter 2: secondNum 4
# Parameter 3: thirdNum "10"

# Rewrite threeDigitMultiply with runtime assertions
# use stopifnot(is.numeric(firstNum), is.numeric(secondNum),is.numeric(thirdNum))

# Call threeDigitMultiply with 
# Parameter 1: firstNum "2"
# Parameter 2: secondNum 4
# Parameter 3: thirdNum 10

# Call threeDigitMultiply with 
# Parameter 1: firstNum 2
# Parameter 2: secondNum 4
# Parameter 3: thirdNum "10"

# Call threeDigitMultiply with 
# Parameter 1: firstNum 2
# Parameter 2: secondNum 4
# Parameter 3: thirdNum 10

# Rewrite threeDigitMultiply with runtime assertions and custom message
# if(is.numeric(firstNum)==F){stop('the firstNum input is not numeric')}
# Do this for all inputs

# Call threeDigitMultiply with 
# Parameter 1: firstNum "2"
# Parameter 2: secondNum 4
# Parameter 3: thirdNum 10

# Call threeDigitMultiply with 
# Parameter 1: firstNum 1
# Parameter 2: secondNum 2
# Parameter 3: thirdNum "3"

# Call threeDigitMultiply with 
# Parameter 1: firstNum 1
# Parameter 2: secondNum 2
# Parameter 3: thirdNum 3

# Rewrite threeDigitMultiply with a warning to coerce the character into a numeric
# Use an if statement to check is.character(firstNum) where if TRUE firstNum <- as.numeric(firstNum) and add the warning message warning('attempting to coerce firstNum into a numeric') for the user. 
# Do this for all other inputs.
# Next create a custom stop message in case NA was returned from the previous check. Use if(is.na(firstNum)) and stop('Tried to coerce firstNum into a numeric but NA was returned.')
# Repeat for other inputs.

# Call threeDigitMultiply with 
# Parameter 1: firstNum 1
# Parameter 2: secondNum 2
# Parameter 3: thirdNum 3

# Call threeDigitMultiply with 
# Parameter 1: firstNum "1"
# Parameter 2: secondNum 2
# Parameter 3: thirdNum 3

# Call threeDigitMultiply with 
# Parameter 1: firstNum "a"
# Parameter 2: secondNum 2
# Parameter 3: thirdNum 3

# End