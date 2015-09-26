######################################################################
##  Prog:  plot6.R
##  Date:   09/25/2015
##  Description: This is an R program for answering
##  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
##  sources in Los Angeles County, California (fips == 06037). Which city has seen greater changes 
##  over time in motor vehicle emissions?
##  datasets, 
##   NEI_data.zip
##  From: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#######################################################################
library(ggplot2)
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


## Get data for On-Road vehicles for Baltimore and LA
subsetNEI <- NEI[NEI$type=="ON-ROAD" & (NEI$fips=="24510"|NEI$fips=="06037"),  ]

##Sum by Year
totalByYearAndFips <- aggregate(Emissions ~ year + fips, subsetNEI, sum)

## Replace number with name
totalByYearAndFips$fips[totalByYearAndFips$fips=="24510"] <- "Baltimore, MD"
totalByYearAndFips$fips[totalByYearAndFips$fips=="06037"] <- "Los Angeles, CA"

png("plot6.png")
titlestr <- "Exploratory Data Analysis P2 Answer 6"
ylabstr  <- expression("Total PM"[2.5]*" Emission")
xlabstr  <- "Year"
ggplot(totalByYearAndFips, aes(factor(year), Emissions)) +
    facet_grid(. ~ fips) +
    geom_bar(stat="identity", fill = "Dark Blue" )  +
    xlab(xlabstr) +
    ylab(ylabstr) +
    ggtitle(titlestr)
dev.off()