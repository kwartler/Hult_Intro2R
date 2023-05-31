# Accessing the Cereal Database
cereals <- read.csv("https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/A1_CerealEDA/cereals.csv")
cereals$rawGPTRank

# Extract just numbers
justNumbers <- gsub('100%','',cereals$rawGPTRank)
justNumbers <- gsub("\\D", "", justNumbers)
justNumbers

# One crazy one!
justNumbers <- ifelse(nchar(justNumbers)>2,
                      substr(justNumbers, start = nchar(justNumbers) - 2, stop = nchar(justNumbers)),
                      justNumbers)

# The compound repies need to be fixt 9 out of 10 became 910 
justNumbers <- ifelse(nchar(justNumbers)==3 |nchar(justNumbers)==4, 
                      as.numeric(gsub('10','',justNumbers)),
                      justNumbers)
justNumbers

# Fix scale
justNumbers <- ifelse(nchar(justNumbers)==2,as.numeric(justNumbers)/10,as.numeric(justNumbers))
justNumbers



