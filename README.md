# Hult_Intro2R

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
