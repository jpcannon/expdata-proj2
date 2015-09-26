######################################################################
##  Prog:  plot1.R
##  Date:   09/25/2015
##  Description: This is an R program for answering
##  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
##  Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 
##  1999, 2002, 2005, and 2008.
##  datasets, 
##   NEI_data.zip
##  From: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#######################################################################

if (!file.exists("NEI_data.zip")) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method="libcurl")
}

if (!file.exists("*.rds")) {
    unzip("NEI_data.zip")
}


if(!exists("NEI")){
    NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")) {
    SCC <- readRDS("Source_Classification_Code.rds")
}

# Sum up data by year
totalByYear <- aggregate(Emissions ~ year, NEI, sum)

# Simple Bar graph with Total Emmissions as Y and sum of Year as X
png("plot1.png")
titlestr <- "Exploratory Data Analysis P2 Answer 1"
ylabstr  <- expression("Total PM"[2.5]*" Emission")
xlabstr  <- "Year"
barplot(height=totalByYear$Emissions, names.arg=totalByYear$year, xlab=xlabstr, ylab=ylabstr,main=titlestr, col='Red' )
dev.off()