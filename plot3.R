##  1/2/2007 starts on line 66638
## 2/2/2007 ends on line 69517
library(datasets)

## The file is large and the data we want to work with is just data from 
## Feb 1 and 2 2007.  To determine what rows to read in, use the grep 
## function to determine the first row in the file for the date Feb 1, 2007
## and the first row in the file for the date Feb 3, 2007 (row after the last row we want)
## This assumes that the file is ordered by date
start <- grep("1/2/2007",readLines(file))[1] 
end <- grep("3/2/2007",readLines(file))[1]

## Read in the rows from the file for the dates Feb 1 and 2, 2007 - this removes the headers
household_power_consumption <- read.table(file, header=FALSE, sep=";", na.strings="?", skip=start-1,  nrows=end-start) 
## Read in the first 5 rows of the file with the headers
headers <- read.table(file, header=TRUE, sep=";", na.strings="?", nrows=5) 

## Assign the colnames from the original file to the subset file
colnames(household_power_consumption) <- colnames(headers)

data2 <- melt(household_power_consumption, id.vars=c("Date", "Time"), measure.vars=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Generate a column with the days of the week for the date of each observation
dateTime   <- as.POSIXlt(paste(as.Date(data2$Date, format="%d/%m/%Y"), data2$Time, sep=" "))

## Open a png graphic device, create a histogram of the Global Active Power data
png(filename="plot3.png", width=480, height=480)
with(subset(data2, variable=="Sub_metering_1"), plot(dateTime, data2$value, type="l", ylab="Energy sub metering", xlab=""))
legend(
  "topright"
  , pch = 
    1
  , col = c("black", "blue", "red"), legend = c("Sub_metering_1"
    , 
    "Sub_metering_2", "Sub_metering_3"
  ))
dev.off()