#' Purpose: Example GPT 3.5 API call as a function
#' Author: Ted Kwartler
#' May 4, 2023

# Only needed the first time, and can be saved to the environment to keep it from the actual script
source("~/Desktop/Hult_Intro2R/personalFiles/openAIKey.R")

codeHelp <- function(userPrompt,
                     apiKey = Sys.getenv("OPENAI_KEY"), 
                     language = 'R', #could be r-markdown or anything really
                     temperature=0, 
                     max_tokens=256, 
                     top_p=1,
                     frequency_penalty=0, 
                     presence_penalty=0,
                     codeOnly = T){ # only return the code and omit comments
  require(httr)
  require(jsonlite)
  
  # Construct the prompting
  promptList <- list(list(role='system',content = paste('You are an expert programmer and data scientist in all computer languages including R and python.  Using the',language,' language write code without any comments to answer the user.  Use markdown.')),
                     list(role='user', content ='How do you read in a CSV with the R language?'),
                     list(role='assistant', content = 'my_data <- read.csv("my_file.csv")'),
                     list(role='user',content=userPrompt))
  
  # Put together the API arguments
  args <- list(messages=promptList,
               model = 'gpt-3.5-turbo',
               temperature=temperature, 
               max_tokens=max_tokens, 
               top_p=top_p,
               frequency_penalty=frequency_penalty, 
               presence_penalty=presence_penalty) 
  
  # Post the arguments and data to the openAI service
  req <- POST(
    url = "https://api.openai.com/v1/chat/completions",
    body = toJSON(args, auto_unbox=TRUE),
    add_headers (
      "Content-Type" = "application/json",
      "Authorization" = paste("Bearer", apiKey)))
  
  statusChk <- status_code(req)
  if(statusChk==200){
    # Obtain just the information returned
    response <- capture.output(cat(fromJSON(content(req, as = "text", encoding = "UTF-8"))$choices$message$content))
    response <- response[nchar(response)>0]
    
    if(codeOnly==T & length(grep('```', response))==2){
      markdown <- grep('```', response)
      st <- markdown[1]
      en <- markdown[2]
      response <- response[st:en]
      drops <- grep('```', response)
      response <- response[-drops]
    } else {
      warning('codeOnly was tried but the back ticks weren\'t as expected so returning all.')
      response
    }
   
  } else {
    statusResp <- paste0('The POST request failed with status: ',statusChk)
    response <- statusResp
  }
  response <- paste(response, collapse = '\n')
  return(response)
}

# Example
#codeHelpExample <- codeHelp(userPrompt = "write code to create a stacked bar chart. Each bar should be for a state and The object `df` is a data frame with columns `id',`state`,  `subcateogry`,`revenue`", 
# max_tokens  = 256*2)
#cat(codeHelpExample)

# Test
#testResp <- codeHelp('write code to create a decision tree')
#testResp
#cat(testResp)

# Bring in the general gpt helper for an explanation
source("~/Documents/HultClass/lessons/B_GPT_Robjects/scripts/B_anyPromptOpenAI.R")
#anyPrompt(paste('can you explain the following code?',testResp, collapse = ' '),
#          apiKey = Sys.getenv("OPENAI_KEY"))

# End


