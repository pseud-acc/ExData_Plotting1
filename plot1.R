# ==============================================================================
# Exploratory Data Analysis - Week 1 - Programming assignment
# ==============================================================================
# Script to generate plot1.png showing histogram of Global Active Power values
# across 2 days in a household
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

#Plot histogram of global active power
hist(raw_power_data_reduced$Global_active_power, main = "Global Active Power",
     col="red", xlab = "Global Active Power (kilowatts)")

#Export plot to file
dev.copy(png, file="plot1.png") #default heightxwidth is 480x480 pixels
dev.off() #Close PNG device