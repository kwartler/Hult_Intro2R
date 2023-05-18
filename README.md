# Hult_Intro2R

## Course Topics: 

1.	Intro to R, R environment, installing libraries and loading packages
2.	Basic objects in R, different data types, testing and changing types, importing data into the R environment
3.	Basic data mining in R
4.	Creating frequency histograms, analyzing different distributions, visualizing data
5.	Basic machine learning algorithms
6.	Creating automated report using R markdown, report streamlining
7.	Creating an interactive dashboard in R

## Course Learning Outcomes:

-	CLO1: Learn how to program in R and how to use R for effective data analysis
-	CLO2: Access online resources for R and import new function packages into the R workspace
-	CLO3: Import, review, manipulate and summarize data-sets in R
-	CLO4: Perform appropriate statistical tests using R



### From the syllabus here is the course timeline.  

*The official system of record is canvas.*

| Date   |St    |H1   |H2   |H3   |Notes   |
|--------|------|-----|-----|-----|--------|
| May22  |5pm   | Intro & Administrative | 	Intro to R  | R, r-studio, git  |   |
| May23  |5pm   | How does GPT work?  | Prompting & Productivity  | Back to R: Object Classes  |   |
| May24  |5pm   | EDA: Data Sources, Data Manipulation  |EDA: Data Visualization   |More EDA   |   |
| May25  |5pm   | Loops & Logical Operations  |Custom Functions   | Writing Packages  |   |
| May29  |NA   |  NA |   |   |  Case 1 Due |
| May30  |5pm   | Machine Learning Data Prep  | Decision Tree  |Random Forest   |   |
| May31  |5pm   | R Markdown  |Flexdashboard   | Library(officer)  |   |
| June1  |5pm   |  Responsible & Trusted AI |Equity/Inclusion Modeling   |   |   |
| June6  |NA   | NA  |   |   | Case 2 Due  |

### Installation of packages

```
# Individually you can use 
# install.packages('packageName') such as below:
install.packages('ggplot2')
# or 
install.packages('pacman')
pacman::p_load('caret','data.table','devtools','DataExplorer','datawizard', 'dplyr', 'ggdark', 
               'ggplot2','ggthemes','httr', 'jsonlite', 'leaflet', 'lubridate',
               'mapproj','maps', 'MLmetrics', 'naniar','pbapply',
               'purrr','radiant.data','remotes','ranger','rbokeh', 
               'ROSE',  'rpart',  'rpart.plot', 'stringr','tidyr','vtreat','fairness')

# We also use these unofficial packages for 1 script, but if you have trouble don't worry about it.  Not a big deal:
devtools::install_github("bayesball/CalledStrike")
devtools::install_github("BillPetti/baseballr")
# OR
remotes::install_github("bayesball/CalledStrike")
remotes::install_github("bayesball/baseballr")
```
