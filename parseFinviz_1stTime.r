

# clear all variables
rm(list=ls())
# set working directory
setwd("C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/")
# ticker data directory
tickerDir <- "./ticker_data/"
# read in list of Tickers to parse
tickers <- as.character(read.csv(paste(tickerDir, "allTickers.csv",sep=""))[,1])

####  FIRST TIME ONLY - CREATE FILES  #########
file_list <- "20140326.csv"
firstFile <- read.csv(file_list)
Dates <- data.frame(Date=as.Date(substr(file_list,1,8),format="%Y%m%d"))

for (symb in tickers){
	write.csv(cbind(Dates,firstFile[firstFile$Ticker==symb,]),paste(tickerDir,symb,".csv",sep=""),row.names=FALSE)
}
#############################################

	
