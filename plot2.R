# ==============================================================================
# Exploratory Data Analysis - Week 1 - Programming assignment
# ==============================================================================
# Script to generate plot2.png showing Global Active Power across 2 days in a 
# household
# ==============================================================================
# Topic: Household Power Consumption
# ==============================================================================

#load packages
library(dplyr)
library(data.table)
library(lubridate)

# ==============================================================================
# Load Data
# ==============================================================================

#define file location
dat_dir <- "./data"
file_name <- "household_power_consumption.txt"
file_path <- paste(dat_dir,file_name,sep="/")

#import data
raw_power_data <- read.table(file_path, header = TRUE, sep = ";")
head(raw_power_data)

#set start and end dates
start_date <- ymd("2007-02-01")
end_date <- ymd("2007-02-03")

#Create DateTime column in correct format
raw_power_data <- raw_power_data %>% 
                mutate(DateTime = dmy_hms(paste(Date, Time, sep=" ")))
#extract data between start and end dates
raw_power_data_reduced <- raw_power_data %>% filter(DateTime >= start_date
                                                  & DateTime < end_date)
head(raw_power_data_reduced)

#delete unnecessary data set
rm(raw_power_data)

#Convert data to numeric 
raw_power_data_reduced <- raw_power_data_reduced %>% 
                        mutate(Global_active_power=as.numeric(Global_active_power))

#Plot of global active power vs. Time
with(raw_power_data_reduced,
     plot(DateTime,Global_active_power,
        xlab = "",
        ylab = "Global Active Power (kilowatts)",
        xaxt = "none",
        type = "l"))
#create custom x-axis ticks
axis(1, at=raw_power_data_reduced$DateTime[1]+dhours(c(0,24,48)), labels=c("Thu","Fri","Sat"))

#Export plot to file
dev.copy(png, file="plot2.png") #default heightxwidth is 480x480 pixels
dev.off() #Close PNG device