#' Author: Ted Kwartler
#' Data: May 17, 2023
#' Purpose: Ethics of DS example
#' 
#' 

# libs 
library(rpart)
library(lubridate)
library(rpart.plot)

# data
df <- read.csv('~/Desktop/Hult_Intro2R/lessons/G_TrustedAI_Ethics/data/compas-scores-two-years.csv')
head(df)

# Clean up
df$screening_date <- as.Date(df$screening_date, format = "%m/%d/%y")
df$dob <- as.Date(df$dob, format = "%m/%d/%y")
df$c_jail_in <- as.POSIXct(df$c_jail_in, format = "%m/%d/%y %H:%M")
df$c_jail_out <- as.POSIXct(df$c_jail_out, format = "%m/%d/%y %H:%M")
df$c_case_number <- NULL
df$c_offense_date <- as.Date(df$c_offense_date, format = "%m/%d/%y")
df$c_arrest_date <- as.Date(df$c_arrest_date, format = "%m/%d/%y")
df$r_case_number <- NULL
df$r_offense_date <- as.Date(df$r_offense_date, format = "%m/%d/%y")
df$r_jail_in <- as.Date(df$r_jail_in, format = "%m/%d/%y")
df$r_jail_out <- as.Date(df$r_jail_out, format = "%m/%d/%y")
df$vr_case_number <- NULL
df$vr_offense_date <- as.Date(df$vr_offense_date, format = "%m/%d/%y")
df$screening_date <- NULL
df$v_type_of_assessment <- NULL
df$v_screening_date <- NULL
df$in_custody <- as.Date(df$in_custody, format = "%m/%d/%y")
df$out_custody <- as.Date(df$out_custody, format = "%m/%d/%y")

# Protected features 
sensitive <- c('sex', 'age', 'age_cat', 'race')

# Informative features
informative <- c(juv_fel_count,juv_misd_count,juv_other_count,c_days_from_compas,c_charge_degree,is_recid,r_charge_degree,
                 r_days_from_arrest,is_violent_recid,vr_charge_degree,decile_score,score_text,v_decile_score,v_score_text)

informative <- c('age', 'age_cat','c_charge_desc','c_jail_in','c_jail_out','days_b_screening_arrest', 'decile_score',
                 'race','score_text','sex')

# target
yVar <- 'two_year_recid'

# Training Data
training <- df[,c(informative, yVar)]
training$timeDiff <- round(difftime(training$c_jail_out,training$c_jail_in, units = 'days'),2)
drops <- c('c_jail_out','c_jail_in')
training <- training[,!(names(training) %in% drops)]


# Treat the data
xVars <- c("age","age_cat","c_charge_desc","days_b_screening_arrest",
           "decile_score","race","score_text","sex","two_year_recid", "timeDiff")               
plan <- designTreatmentsC(training, xVars,yVar, 0)

# Apply
treatedTrain <- prepare(plan, training)

# Fit
tree <- rpart(as.factor(two_year_recid)~., treatedTrain, cp = 0.01)
prp(tree)

# Predict and eval
predict(tree, treatedTrain)

# End