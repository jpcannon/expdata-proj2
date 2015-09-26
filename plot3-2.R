######################################################################
##  Prog:  plot3.R
##  Date:   09/25/2015
##  Description: This is an R program for answering
##  Of the four types of sources indicated by the type 
##  (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in 
##  emissions from 1999-2008 for Baltimore City? 
##  Which have seen increases in emissions from 1999-2008? 
##  Use the ggplot2 plotting system to make a plot answer this question
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

baltimoreTotalByYearType <- aggregate(Emissions ~ year + type, NEI[NEI$fips == "24510",], sum)


png("plot3-2.png")
titlestr <- "Exploratory Data Analysis P2 Answer 3"
ylabstr  <- expression("Total PM"[2.5]*" Emission in Baltimore City")
xlabstr  <- "Year"
ggplot(baltimoreTotalByYearType, aes(x=factor(year), y=Emissions,group=1)) +
    facet_grid(. ~ type) +
    geom_line(colour="Dark Blue", linetype="solid",size = 1.5) + 
    geom_point(colour="Red", size=2) +
    xlab(xlabstr) +
    ylab(ylabstr) +
    ggtitle(titlestr)+ 
    theme(axis.text=element_text(size=8))
dev.off()
