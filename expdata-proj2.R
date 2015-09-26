# set to your working directory
#setwd("C:/Users/yan.fei/Desktop/current/learnR/JH/EDA/")
getwd()
if (!file.exists("NEI_data.zip")) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method='libcurl')
}

if (!file.exists("*.rds")) {
    unzip("NEI_data.zip")
}



## This first line will likely take a few seconds. Be patient!
if(!exists("NEI")){
    NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")) {
    SCC <- readRDS("Source_Classification_Code.rds")
}

# Q1
totalByYear <- aggregate(Emissions ~ year, NEI, sum)

png('plot1.png')
barplot(height=totalByYear$Emissions, names.arg=totalByYear$year, xlab="year", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions by year'))
dev.off()

# Q2 
baltimore <- NEI[NEI$fips == "24510",]
baltimoreTotalByYear <- aggregate(Emissions ~ year, baltimore, sum)
png('plot2.png')
barplot(height=baltimoreTotalByYear$Emissions, names.arg=baltimoreTotalByYear$year, xlab="year", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions by year for Baltimore'))
dev.off()

# Q3 
library(ggplot2)
baltimoreTotalByYearType <- aggregate(Emissions ~ year + type, baltimore, sum)
#png('plot3.png')
qplot(year, Emissions, data = baltimoreTotalByYearType, geom = c("point", "smooth"), method = "lm", facets = .~ type )
dev.off()

# Q4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
# merge the two data sets 
if(!exists("NEISCC")){
    NEISCC <- merge(NEI, SCC, by="SCC")
}
coalSources <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
coals <- NEISCC[coalSources, ]
totalByYearCoal <- aggregate(Emissions ~ year, coals, sum)
png("plot4.png", width=1024, height=768)
g <- ggplot(totalByYearCoal, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
    xlab("year") +
    ylab(expression('Total PM'[2.5]*" Emissions")) +
    ggtitle('Total Emissions from coal combustion-related sources - 1999 to 2008')
print(g)
dev.off()

# Q5
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
# look for ON-ROAD type in NEI
# try searching for 'motor' in SCC only gave a subset (non-cars)
baltimoreMotor <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD",  ]
totalByYearBaltimoreMotor <- aggregate(Emissions ~ year, baltimoreMotor, sum)

png("plot5.png", width=1024, height=768)
g <- ggplot(totalByYearBaltimoreMotor, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
    xlab("year") +
    ylab(expression('Total PM'[2.5]*" Emissions")) +
    ggtitle('Total Emissions for motor vehicle (type = ON-ROAD) in Baltimore, MD from 1999 to 2008')
print(g)
dev.off()


# Q6 
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

subsetNEI <- NEI[NEI$type=="ON-ROAD" & (NEI$fips=="24510"|NEI$fips=="06037"),  ]

totalByYearAndFips <- aggregate(Emissions ~ year + fips, subsetNEI, sum)

totalByYearAndFips$fips[totalByYearAndFips$fips=="24510"] <- "Baltimore, MD"
totalByYearAndFips$fips[totalByYearAndFips$fips=="06037"] <- "Los Angeles, CA"

png("plot6.png", width=1024, height=768)
g <- ggplot(totalByYearAndFips, aes(factor(year), Emissions))
g <- g + facet_grid(. ~ fips)
g <- g + geom_bar(stat="identity", fill = "#ff9999" )  +
    xlab("year") +
    ylab(expression('Total PM'[2.5]*" Emissions")) +
    ggtitle('Total Emissions from motor vehicle (type=ON-ROAD) in Baltimore, MD vs Los Angeles, CA - 1999-2008')
print(g)
dev.off()


