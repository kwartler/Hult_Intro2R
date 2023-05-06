#' Purpose: Example GPT 3.5 API call as a function
#' Author: Ted Kwartler
#' May 4, 2023

# Only needed the first time, and can be saved to the environment to keep it from the actual script
source("~/Desktop/Hult_Intro2R/personalFiles/openAIKey.R")


anyPrompt <- function(apiKey = Sys.getenv("OPENAI_KEY"), 
                      userPrompt, 
                      temperature=0, 
                      max_tokens=256, 
                      top_p=1,
                      frequency_penalty=0, 
                      presence_penalty=0){
  require(httr)
  require(jsonlite)
  
  # Construct the prompting
  # You could improve this base prompting system and response example significantly to improve your results
  promptList <- list(list(role='system',content = 'You are a helpful assistant.'),
                     list(role='user', content ='Who won the world series in 2020?'),
                     list(role='assistant', content = 'The Los Angeles Dodgers won the World Series in 2020.'),
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
    
  } else {
    statusResp <- paste0('The POST request failed with status: ',statusChk)
    response <- statusResp
  }
  return(response)
}

# Example
#exampleGPT <- anyPrompt(userPrompt = 'name 3 methods for EDA of a data set',
#                        max_tokens  = 256*2)
#exampleGPT



# End