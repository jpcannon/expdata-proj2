######################################################################
##  Prog:  plot2.R
##  Date:   09/25/2015
##  Description: This is an R program for answering
##  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == 24510) from 1999 to 2008? 
##  Use the base plotting system to make a plot answering this question
##  datasets, 
##   NEI_data.zip
##  From: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#######################################################################

if (!file.exists("NEI_data.zip")) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method='libcurl')
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

# Sum year and type for Baltimore (NEI[NEI$fips == "24510",])
baltimoreTotalByYear <- aggregate(Emissions ~ year, NEI[NEI$fips == "24510",], sum)

# Simple Bar graph with Total Emmissions as Y and sum of Year as X
png('plot2.png')
titlestr <- "Exploratory Data Analysis P2 Answer 2"
ylabstr  <- expression("Total PM"[2.5]*" Emission for Baltimore, MD")
xlabstr  <- "Year"
png('plot2.png')
barplot(height=baltimoreTotalByYear$Emissions, names.arg=baltimoreTotalByYear$year, xlab=xlabstr, ylab=ylabstr,main=titlestr,col="purple")
dev.off()