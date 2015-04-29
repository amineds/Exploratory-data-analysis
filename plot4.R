# Get the data from the text file
library(dplyr)
library(ggplot2)

message("loading data....")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")    
message("data loaded !")     

#preparing data to plots
#identify coal combustion-related sources 
scc_index <- grep("Coal", SCC$EI.Sector)
#extract SCC codes
scc_codes <- SCC[scc_index, 1]

#Subset the data
nei_coal <- NEI[NEI$SCC %in% scc_codes, ]

#Preparing data to plot
scc_ei_sec <- SCC[, c(1, 4)]
# data to plot : Emissions-Year-EI.Sector
data_2_plot <- merge(nei_coal, scc_ei_sec, by.x = "SCC", by.y = "SCC")[, c(4, 6, 7)]

#structuring data
data_2_plot <- mutate(data_2_plot,year=factor(year))

data_2_plot <- group_by(data_2_plot,EI.Sector,year)

data_2_plot_conso <- summarize(data_2_plot,pm25=sum(Emissions)/1000)

# Initiate the png file (device)
png("plot4.png", height=720, width=720)
message("device open")

g <- ggplot(data_2_plot_conso , aes(x=year, y=pm25,group=EI.Sector,label=as.integer(pm25)))
g <- g + geom_point(color = "blue", size = 4, alpha = 1/2) 
g <- g + geom_line(aes(colour = pm25))
g <- g + geom_text(size=4,hjust=0.3, vjust=-1)
g <- g + facet_grid(.~EI.Sector) 
g <- g + labs(title = "Total PM2.5 emissions from coal combustion-related sources in US") 
g <- g + labs(x = "Year", y = "Amount of PM2.5 emitted (1000 Tons)")

print(g)

# Close the device
dev.off()
message("device closed")

#free the memory
rm(NEI);rm(SCC);rm(nei_coal);rm(scc_ei_sec);rm(data_2_plot);rm(data_2_plot_conso)