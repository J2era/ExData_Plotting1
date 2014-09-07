## read in txt file

library(dplyr)
library(data.table)
suppressWarnings(fh <- fread("household_power_consumption.txt", na.strings=c("NA","?","")))
powerdata <- filter(fh, grep("^[1,2]/2/2007", Date))
powerdata$Timestamp = as.POSIXct(strptime(paste(powerdata$Date, powerdata$Time), format = "%d/%m/%Y %H:%M:%S"))

##plot3

png(file="plot3.png")
plot(powerdata$Timestamp,powerdata$Sub_metering_1,type = "l")
lines(powerdata$Timestamp,powerdata$Sub_metering_2,col="red")
lines(powerdata$Timestamp,powerdata$Sub_metering_3,col="blue")
legend("topright",lty = 1,col=c("black","red" ,"blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()