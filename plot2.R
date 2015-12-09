## plot2.R

url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download the zip if it doesn't exist

localFilename = "household_power_consumption.zip"
if (!file.exists(localFilename)){
  cat("Downloading the dataset zip file.typ..")
  download.file(url,destfile = localFilename )
  cat("Done!\n")
}

# Unzip the file if it exists
if (file.exists(localFilename)) {
  cat("Unzipping the dataset file...")
  unzip(localFilename, overwrite=TRUE)
  cat("Done!\n")
} else {
  stop("Error: Unable to find zip file")
}

cat("Reading the table...")
colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")
householdPower <- read.table("household_power_consumption.txt", colClasses=colClasses, sep=";",header=T,na.strings="?")
cat("Done!\n")

# Combine and convert date times to PISXlt formate
cat("Creating datetime...")
householdPower$datetime <- with(householdPower,strptime(paste(Date,Time), "%d/%m/%Y %H:%M:%S"))
cat("Done!\n")

# Get rid of the character columns
householdPower = householdPower[, !(names(householdPower) %in% c("Date","Time"))]

# Get rid of data not on 2/1/2007 or 2/2/2007 
cat("Subsetting rows...")
householdPower = householdPower[householdPower$datetime>=as.POSIXlt("2007-02-01", format="%Y-%m-%d") & 
                                  householdPower$datetime< as.POSIXlt("2007-02-03", format="%Y-%m-%d"),]
cat("Done!\n")


# Create png
cat("Creating png...")
png(filename='plot2.png', width=480, height=480)
with(householdPower,plot(datetime,Global_active_power,type="l",ylab="Global Active Power (kilowatts)",xlab=""))
dev.off(which=dev.cur())
cat("\nAll Done!\n")
