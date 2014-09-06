## read in txt file

library(dplyr)
library(data.table)
fh <- fread("household_power_consumption.txt", na.strings="?")
powerdata <- filter(fh, grep("^[1,2]/2/2007", Date))


##plot1  histgram 
png(file="plot1.png")
powerdata$Global_active_power<- as.numeric(powerdata$Global_active_power)
hist(powerdata$Global_active_power,main="Global Active Power",col="red", xlab="Global Active Power (kilowatts)" )
dev.off()