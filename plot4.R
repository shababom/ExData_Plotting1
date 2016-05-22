##  1/2/2007 starts on line 66638
## 2/2/2007 ends on line 69517
install.packages("downloader")
library(datasets)
library(downloader)

## Download file from UCI website
## Unzip the file into the working directory
download("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", dest="household_power_consumption.zip", mode="wb")
unzip("household_power_consumption.zip")
file <- ("household_power_consumption.txt")

## The file is large and the data we want to work with is just data from 
## Feb 1 and 2 2007.  To determine what rows to read in, use the grep 
## function to determine the first row in the file for the date Feb 1, 2007
## and the first row in the file for the date Feb 3, 2007 (row after the last row we want)
## This assumes that the file is ordered by date
start <- grep("1/2/2007",readLines(file))[1] 
end <- grep("3/2/2007",readLines(file))[1]

## Read in the rows from the file for the dates Feb 1 and 2, 2007 - this removes the headers
household_power_consumption <- read.table(file, header=FALSE, sep=";", na.strings="?", skip=start-1,  nrows=end-start) 

##remove missing fields observations
household_power_consumption <- household_power_consumption[complete.cases(household_power_consumption),]

## Read in the first 5 rows of the file with the headers
headers <- read.table(file, header=TRUE, sep=";", na.strings="?", nrows=5) 

## Assign the colnames from the original file to the subset file
colnames(household_power_consumption) <- colnames(headers)

##Convert Date Column  to Date Type 
household_power_consumption$Date <- as.Date(household_power_consumption$Date,"%d/%m/%Y")

##Convert Time Column  to POSIXlt and POSIXct Type
household_power_consumption$Time <- strptime(paste(household_power_consumption$Date, household_power_consumption$Time,sep=" "), "%Y-%m-%d %H:%M:%S")

##Construct a png file
png(file = "Plot4.png", bg = "transparent",width = 480, height = 480)

##setup plot with 2 rows 2 columns and set margins

par(mfrow =c(2,2), mar =c (4,4,2,1), oma = c(0,0,2,0))

with(household_power_consumption,{
  
  ##Plot graph - Plot 1 on Row 1, col 1
  plot(Time,Global_active_power,ylab = "Global Active Power", type="n" , xlab="")
  lines(Time,Global_active_power)
  
  ##Plot graph - Plot 2  on Row 2, col 1
  plot(Time,Voltage ,ylab = "Voltage", type="n", xlab="datetime")
  lines(Time,Voltage)
  
  ##Plot graph - Plot 3  on Row 1, col 2
  plot(Time, Sub_metering_1,type="n",ylab = "Energy Sub Metering", xlab="")
  lines(Time,Sub_metering_1,col="black")
  lines(Time,Sub_metering_2,col="red")
  lines(Time,Sub_metering_3,col="blue")
  
  legend("topright",col=c("black","red","blue"),lwd=1,bty="n", legend = c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"))
  
  ##Plot graph - Plot 4  on Row 2, col 2
  plot(Time,Global_reactive_power , type="n", xlab="datetime")
  lines(Time,Global_reactive_power )
})


##Close PNG device
dev.off() 