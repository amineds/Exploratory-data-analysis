# Get the data from the text file
library(dplyr)

message("loading data....")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")    
message("data loaded !")     


#make the year as a factor
NEI <- mutate(NEI,year=factor(year))

#group by year
NEI_YEAR <- group_by(NEI,year)

#consolidate per year
NEI_YEAR_SUM <- summarize(NEI_YEAR,pm25=sum(Emissions))

#divide per thousand to avoid large values in the
NEI_YEAR_SUM <- mutate(NEI_YEAR_SUM, pm25=pm25/1000)

# Initiate the png file (device)
png("plot1.png", height=700, width=700)
message("device open")

#do the plotting
par(pch=19)
plot(NEI_YEAR_SUM$year,
     NEI_YEAR_SUM$pm25,
     type="n",
     xlab="Year",
     ylab="Amount of PM2.5 emitted (1000 Tons)",
     main="Total PM2.5 emissions in the US from 1999 to 2008"
     )

lines(NEI_YEAR_SUM$year,NEI_YEAR_SUM$pm25,type="b", lwd=2,lty=2,col="blue")

text(NEI_YEAR_SUM$year, NEI_YEAR_SUM$pm25, as.integer(NEI_YEAR_SUM$pm25), pos=3, offset = 0.6, col="black") 

# Close the device
dev.off()
message("device closed")

#free the memory
rm(NEI);rm(NEI_YEAR);rm(NEI_YEAR_SUM)