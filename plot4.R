# ==============================================================================
# Exploratory Data Analysis - Week 1 - Programming assignment - Plot1.R
# ==============================================================================
# Script to generate plot4.png showing Global Active Power, Voltage,
# Energy sub metering and Global reactive power across 2 days in a 
# household
# ==============================================================================
# Topic: Household Power Consumption
# ==============================================================================

#load packages
library(dplyr)
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
                        mutate(Global_active_power=as.numeric(Global_active_power),
                               Sub_metering_1=as.numeric(Sub_metering_1),
                               Sub_metering_2=as.numeric(Sub_metering_2),
                               Sub_metering_3=as.numeric(Sub_metering_3),
                               Voltage=as.numeric(Voltage),
                               Global_reactive_power=as.numeric(Global_reactive_power))

################
# PLOTTING
################

#set x-tick labels
xtick_vals <- raw_power_data_reduced$DateTime[1]+dhours(c(0,24,48))
xtick_labels <- c("Thu","Fri","Sat")

#adjust margins
par(mgp = c(2.5,1,0), mfcol = c(2,2), mar = c(4, 4, 3, 1.2), oma = c(0, 0, 0, 0))
### 
# Global Active Power
###
with(raw_power_data_reduced,
     plot(DateTime,Global_active_power,
          xlab = "",
          ylab = "Global Active Power",
          xaxt = "none",
          type = "l"))
#create custom x-axis ticks
axis(1, at=xtick_vals, labels=xtick_labels)

###
# Energy sub metering
###
with(raw_power_data_reduced,
     plot(DateTime,raw_power_data_reduced$Sub_metering_1,
          type = "l", ylab = "Energy sub metering", 
          xlab = "", xaxt = "none", col="black"))

#Add plot overlays
line_col <- c("red","blue")
for (i in seq_along(line_col)){
        xval <- paste0("Sub_metering_",i+1)
        lines(raw_power_data_reduced[,"DateTime"],raw_power_data_reduced[,xval],
              type = "l", ylab = "", xlab = "", xaxt = "none", col=line_col[i])
}
#Add legend
legend("topright", lwd = 1, col = c("black","blue", "red"),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty = "n")
#create custom x-axis ticks
axis(1, at=xtick_vals, labels=xtick_labels)


###
# Voltage
###
with(raw_power_data_reduced,
     plot(DateTime,Voltage,
          xlab = "datetime",
          ylab = "Voltage",
          xaxt = "none",
          type = "l"))
#create custom x-axis ticks
axis(1, at=xtick_vals, labels=xtick_labels)

###
# Global reactive power
###
with(raw_power_data_reduced,
     plot(DateTime,Global_reactive_power,
          xlab = "datetime",
          ylab = "Global_reactive_power",
          xaxt = "none",
          type = "l"))
#create custom x-axis ticks
axis(1, at=xtick_vals, labels=xtick_labels)

##################
#Export plot to file
#################
dev.copy(png, file="plot4.png") #default heightxwidth is 480x480 pixels
dev.off() #Close PNG device

