#downloading and unziping data
if(!file.exists("./data/household_power_consumption.txt")){
  if(!file.exists("./data")){dir.create("./data")}
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
  download.file(fileUrl, destfile="./exdata-data-household_power_consumption.zip", method="curl")
  unzip("exdata-data-household_power_consumption.zip",exdir="./data")
}
#Fast data loading
if(!"data.table" %in% installed.packages()) install.packages("data.table")
library(data.table)
options(warn = -1) #fread() doesn't react properly on arguments and sends warnings
energyTemp <- fread("data/household_power_consumption.txt", header=T, sep=";", na.strings = "?", 
                    stringsAsFactors=F, colClasses = c(rep("character",2), rep("numeric",7)))
options(warn = 0)

#subseting dataframe
setkey(energyTemp,Date)
eng <- data.frame(energyTemp[(Date == "1/2/2007") | (Date == "2/2/2007")]) #a bit risky but it works!

#some cleaning
eng$Time <- strptime(paste(eng$Date,eng$Time, sep=" "),format="%d/%m/%Y %H:%M:%S") #just better to have full time available
eng$Date <- as.Date(eng$Date,format="%d/%m/%Y")
energyTemp <- NULL

#----------- Plot generation ------------
#Plot3 - Energy Sub-metering - scaterplot
if(!file.exists("./figure")){dir.create("./figure")}
png(filename="./figure/plot3.png", width = 480, height = 480, units = "px")
x <- eng$Time; 
y <- eng$Sub_metering_1
col1="black"; col2="red"; col3="blue"

plot(x,y, ylab="Energy sub metering", xlab="", type="n" )

points(x,eng$Sub_metering_1,type="l",col=col1)
points(x,eng$Sub_metering_2,type="l",col=col2)
points(x,eng$Sub_metering_3,type="l",col=col3)

legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c(col1, col2,col3),
       text.col = c(col1, col2,col3), lty=1)
dev.off()