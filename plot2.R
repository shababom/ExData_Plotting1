##  1/2/2007 starts on line 66638
## 2/2/2007 ends on line 69517
## downloader package makes it easy to download a file and unzip it
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
## Read in the first 5 rows of the file with the headers
headers <- read.table(file, header=TRUE, sep=";", na.strings="?", nrows=5) 

## Assign the colnames from the original file to the subset file
colnames(household_power_consumption) <- colnames(headers)

## Generate a column with the days of the week for the date of each observation
dateTime   <- as.POSIXlt(paste(as.Date(household_power_consumption$Date, format="%d/%m/%Y"), household_power_consumption$Time, sep=" "))

## Open a png graphic device, create a histogram of the Global Active Power data
png(filename="plot2.png", width=480, height=480)
plot(dateTime, household_power_consumption$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.off()