######################################################################
##  Prog:  plot4.R
##  Date:   09/25/2015
##  Description: This is an R program for answering
##  Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
##  datasets, 
##   NEI_data.zip
##  From: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#######################################################################
library(ggplot2)

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

## Combine all sources
NEISCC <- merge(NEI, SCC, by="SCC")

# Find Coal source
coal <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
coals <- NEISCC[coal, ]

#sum up emmisions from coal by year
totalByYearCoal <- aggregate(Emissions ~ year, coals, sum)

png("plot4.png")

titlestr <- "Exploratory Data Analysis P2 Answer 4"
ylabstr  <- expression("Total PM"[2.5]*" Emission from Coal")
xlabstr  <- "Year"
ggplot(totalByYearCoal, aes(factor(year), Emissions)) +
##  With ggplot you add adornments
    geom_bar(stat="identity", fill="Blue") +
    xlab(xlabstr) +
    ylab(ylabstr) +
    ggtitle(titlestr)

dev.off()

