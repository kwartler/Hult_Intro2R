#' Purpose: Example GPT 3.5 API call
#' Author: Ted Kwartler
#' May 4, 2023

# Only needed the first time, and can be saved to the environment to keep it from the actual script
source("~/Desktop/Hult_Intro2R/personalFiles/openAIKey.R")

# Library
library(httr)
library(jsonlite)

# Get the API Key
apiKey <-Sys.getenv("OPENAI_KEY")

# Construct the prompting
promptList <- list(list(role='system',content = 'You are a helpful assistant.'),
                   list(role='user', content ='Who won the world series in 2020?'),
                   list(role='assistant', content = 'The Los Angeles Dodgers won the World Series in 2020.'),
                   list(role='user',content="Where was it played?"))


# Put together the API arguments
args <- list(messages=promptList,
             model = 'gpt-3.5-turbo',
             temperature=0, # creativity
             max_tokens=256, # maximum numbers of tokens to return
             top_p=1,#probability distribution cutoff, lower values = less variety, higher values = more unpredictable
             frequency_penalty=0, # discourage the repetition of the same tokens
             presence_penalty=0) # discourage GPT-3 from generating text from a specific category

# Post the arguments and data to the openAI service
req <- POST(
  url = "https://api.openai.com/v1/chat/completions",
  body = toJSON(args, auto_unbox=TRUE),
  add_headers (
    "Content-Type" = "application/json",
    "Authorization" = paste("Bearer", apiKey)
  )
)

# Review the response object
req
status_code(req)
class(req)
tmp <- content(req)

# Obtain just the information returned
response <- capture.output(cat(fromJSON(content(req, as = "text", encoding = "UTF-8"))$choices$message$content))
response

# End