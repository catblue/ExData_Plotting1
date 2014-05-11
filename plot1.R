#================================= CODE =====================================
if(!file.exists("./data/household_power_consumption.txt")){
  if(!file.exists("./data")){dir.create("./data")}
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
  download.file(fileUrl, destfile="./exdata-data-household_power_consumption.zip", method="curl")
  unzip("exdata-data-household_power_consumption.zip",exdir="./data")
}

#Fast data loading
if(!"data.table" %in% installed.packages()) install.packages("data.table")
library(data.table)
#update.packages()
options(warn = -1) #fread() doesn't react properly on arguments and sends warnings
energyTemp <- fread("data/household_power_consumption.txt", header=T, sep=";", na.strings = "?", 
                    stringsAsFactors=F, colClasses = c(rep("character",2), rep("numeric",7)))
options(warn = 0)
setkey(energyTemp,Date)
eng <- data.frame(energyTemp[(Date == "1/2/2007") | (Date == "2/2/2007")]) #a bit risky but it works!

eng$Time <- strptime(paste(eng$Date,eng$Time, sep=" "),format="%d/%m/%Y %H:%M:%S") #just better to have full time available
eng$Date <- as.Date(eng$Date,format="%d/%m/%Y")
energyTemp <- NULL

#----------- Plots ------------

#Plot1 - Global Active Power - histogram
if(!file.exists("./figure")){dir.create("./figure")}
png(filename="./figure/plot1.png", width = 480, height = 480, units = "px")
hist(as.numeric(eng$Global_active_power),col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")
dev.off()
