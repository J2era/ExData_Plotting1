## read in txt file

library(dplyr)
library(data.table)
fh <- fread("household_power_consumption.txt", na.strings="?")
powerdata <- filter(fh, grep("^[1,2]/2/2007", Date))


##convert the Date and Time variables to Date/Time classes
powerdata$Timestamp = as.POSIXct(strptime(paste(powerdata$Date, powerdata$Time), format = "%Y-%m-%d %H:%M:%S"))

##plot4
png(file="plot4.png")
par(mfrow=c(2,2))
#1
with(powerdata, plot(Timestamp,Global_active_power,type = "l",cex.lab=0.5,cex.axis=0.6,xlab="",ylab="Global Active Power") )

#2
with(powerdata, plot(Timestamp,Voltage,type = "l", cex.lab=0.5,cex.axis=0.6,xlab="datetime",ylab="Voltage") )
#3

plot(powerdata$Timestamp,powerdata$Sub_metering_1,type = "l",cex.lab=0.5,cex.axis=0.6, xlab="",ylab="Energy sub metering")
lines(powerdata$Timestamp,powerdata$Sub_metering_2,col="red")
lines(powerdata$Timestamp,powerdata$Sub_metering_3,col="blue")
legend("topright",lty = 1,cex=.6,col=c("black","red" ,"blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#4
with(powerdata, plot(Timestamp,Global_reactive_power,type = "l",cex.lab=0.5,cex.axis=0.6, xlab="datetime",ylab="Global_reactive_power") )

dev.off()