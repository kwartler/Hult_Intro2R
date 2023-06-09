#' Author: Ted Kwartler
#' Data: Feb 16,2023
#' Purpose: R bar visual ggplot scatter & bubble examples
#' Good resource: https://r-graphics.org/

# wd
setwd("~/Desktop/Hult_Intro2R/personalFiles")

# libs
library(ggplot2)
library(ggthemes)
library(ggdark) #invert_geom_defaults() 
library(CalledStrike) 
#devtools::install_github("bayesball/CalledStrike")
#devtools::install_github("BillPetti/baseballr")
library(lubridate)
library(dplyr)

# Load & define the data folder path for your computs
pth              <- '~/Desktop/Hult_Intro2R/lessons/C_EDA_VIZ/data/'
possiblePurchase <- read.csv('https://raw.githubusercontent.com/kwartler/Hult_Intro2R/main/lessons/C_EDA_VIZ/data/MarthasVineyardCondo.csv')

# Clean $ signs
possiblePurchase$Avg.Price.Per.Night <- as.numeric(gsub('[$]', '', possiblePurchase$Avg.Price.Per.Night))

# Clean dates by splitting up info
tmp <- strsplit(possiblePurchase$Month,'-')
tmp # show
tmpMonth <- unlist(lapply(tmp, head, 1))
tmpMonth # show

# match month abbreviation to number & append 20 prefix
possiblePurchase$month <- match(tmpMonth,month.abb)
possiblePurchase$yr    <- paste0('20',unlist(lapply(tmp, tail, 1)))

# Check in to see whats going on
head(possiblePurchase)

# concatenate yr, month in format to be a "date" class using 1st day of month
tmpDates <- as.Date(paste(possiblePurchase$yr,possiblePurchase$month, '1', sep = '-'), "%Y-%m-%d")
tmpDates

# But this date is monthly stats _after_ the month is done so concatenate to the last day of the month ; notice the leap year!
possiblePurchase$closingDate <- days_in_month(tmpDates) # from lubridate

# Now put the Month column into a closing month Date class by overwriting it
possiblePurchase$Month <- as.Date(paste(possiblePurchase$yr,possiblePurchase$month,possiblePurchase$closingDate,sep='-'), "%Y-%m-%d")

# Finally 
head(possiblePurchase)

# Simple Scatter: relationship between two variables
scatterPlotBase <- ggplot(data = possiblePurchase, 
                          aes(x=NightOccupied, y=EffectiveGrossIncome)) + 
  geom_point() + 
  theme_gdocs()
scatterPlotBase

# Now add a trend line, linear regression 
scatterPlotBase + geom_smooth(method = "lm", se = TRUE) + 
  theme_gdocs() + 
  labs(x="Occupied Nights", y = "Gross Income", title= "MV Motel Condo")

# You can color code by a group easily too
ggplot(data = possiblePurchase, aes(x=NightOccupied, y=EffectiveGrossIncome, color = yr)) + 
  geom_point() + 
  theme_stata() + labs(x="Occupied Nights", y = "Gross Income", title= "MV Motel Condo")

# Add another dimension size; number of nights occupied has a relationship to income and so does price to night.  no shocker there bc of "high season" has high occupancy and high rates, but a good example still
ggplot(data = possiblePurchase, 
       aes(x=NightOccupied, y=EffectiveGrossIncome, color = yr, linewidth = Avg.Price.Per.Night)) + 
  geom_point() + 
  theme_wsj()

# a Cleveland Dot plot, xy both class levels, color and size can be other dimensions but this shows only 3
df <- subset(possiblePurchase, possiblePurchase$yr !='2020')
ggplot(data = df, 
       aes(x=yr, y=factor(month), size = NetOperatingIncome, color = NetOperatingIncome)) + 
  geom_point() +  
  scale_colour_viridis_c(option = "magma")  + 
  ggdark::dark_theme_gray() + 
  theme(legend.position = "none") +
  labs(x="year", y = "month", title= "Operating Income MV Condo")

# dumb bell plot to compare extremes by group, data wrangling you can use group_by but this is to be clear for new R programmers
minIncomes <- aggregate(NetOperatingIncome~month, data = df, FUN= min)
minIncomes
maxIncomes <- aggregate(NetOperatingIncome~month, data = df, FUN= max)
maxIncomes
incomes <- left_join(minIncomes, maxIncomes, by = 'month')
names(incomes) <- c('month','minIncome','maxIncome')
incomes

ggplot(incomes) + 
  geom_segment(aes(x=minIncome, xend=maxIncome,
                   y=factor(month), yend=factor(month)),size=2,  color = "#aeb6bf", alpha = 0.5) +
  geom_point(data = incomes, aes(x=minIncome, y=factor(month)), color = 'red', size = 2) + 
  geom_point(data = incomes, aes(x=maxIncome, y=factor(month)), color = 'blue', size = 2) +
  geom_vline(xintercept = 0, linetype = 'dotted', color = 'darkgrey', size = 0.5) +
  theme_few() + 
  theme(legend.position="none") +
  labs(x="Income", y = "Month", title= "Min/Max Income by Month")

# Deal w over-plotting
# Load other data, using the EXACT path on your computer instantiated at the beginning
player <- readRDS(paste0(pth,'player_copy.rds'))
head(data.frame(player$plate_x, player$plate_z))
pitchingLocations <- data.frame(plate_x = player$plate_x, plate_z = player$plate_z)
basePlot <- ggplot(data = pitchingLocations, aes(x = plate_x, y = plate_z)) + ggtitle("Miguel Castro's Pitch Locations")
basePlot + geom_point() + ggdark::dark_theme_classic()

# Jitter, move dots slightly and add them in red to see how they move.  In reality you would not do it this way because it doubles points.
basePlot + geom_point(color = 'red') + ggdark::dark_theme_classic() + geom_jitter(width = 0.7, height = 0.20)

# This is the real way which just applies the gitter to a single set of points.
basePlot + geom_jitter(width = 0.7, height = 0.70)  + ggdark::dark_theme_classic()

# Alpha, make semi-transparent
basePlot + geom_point(alpha = 0.25)  + ggdark::dark_theme_classic()

# Make a 2d Density plot 
basePlot + geom_density_2d_filled(contour_var = 'ndensity') + theme(legend.position = "none") 

# Or use a facet to subset the visual by a group
ggplot(data = player) + theme_hc() +
  geom_density_2d_filled( aes(x = plate_x, y = plate_z), contour_var = 'ndensity') + 
  CalledStrike::add_zone(Color = "red") + # Comment this line if you don't have library(CalledStrike) installed
  theme(legend.position = 'none',
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ggtitle(paste('Miguel Castro Pitch Location')) +
  coord_equal() +
  facet_wrap(pitch_name ~ .)
# End
