## read in txt file

library(dplyr)
library(data.table)
fh <- fread("household_power_consumption.txt", na.strings="?")
powerdata <- filter(fh, grep("^[1,2]/2/2007", Date))
close(fh)

##plot2 

png(file="plot2.png")
powerdata$Timestamp = as.POSIXct(strptime(paste(powerdata$Date, powerdata$Time), format = "%Y-%m-%d %H:%M:%S"))
with(powerdata, plot(Timestamp,Global_active_power,type = "l", xlab="",ylab="Global Active Power (kilowatts)") )
dev.off()