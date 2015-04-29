# Get the data from the text file
library(dplyr)
library(ggplot2)

message("loading data....")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")    
message("data loaded !")     

#subset data, keep only baltimore records
NEI <- NEI[NEI$fips == "24510",]

#create factors
NEI <- mutate(NEI,year=factor(year))
NEI <- mutate(NEI,type=factor(type))

#group by year and type of source
NEI_TypeYear <- group_by(NEI,type,year)

#consolidate
NEI_TypeYear_SUM <- summarize(NEI_TypeYear,pm25=sum(Emissions))

# Initiate the png file (device)
png("plot3.png", height=720, width=720)
message("device open")

g <- ggplot(NEI_TypeYear_SUM , aes(x=year, y=pm25,group=type,label=as.integer(pm25)))
g <- g + geom_point(color = "blue", size = 4, alpha = 1/2) 
g <- g + geom_line(aes(colour = pm25)) + scale_colour_gradient(low="blue")
g <- g + geom_text(size=4,hjust=0.3, vjust=-1)
g <- g + facet_grid(.~type) 
g <- g + labs(title = "Total PM2.5 emissions in Baltimore from 1999 to 2008 per type of source") 
g <- g + labs(x = "Year", y = "Amount of PM2.5 emitted (Tons)")

print(g)

# Close the device
dev.off()
message("device closed")

#free the memory
rm(NEI);rm(NEI_TypeYear);rm(NEI_TypeYear_SUM)