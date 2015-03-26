


# d<-rbind(a[1,],a[2,])

# b=read.csv("C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/20140328.csv")

# write.csv(d,"C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/a1.csv",row.names=FALSE)

# data.frame(Date=as.Date(substr(files,1,8),format="%Y%m%d"))
# c<-a(-1)

# test1<-do.call("rbind", lapply(list.files(), read.csv, header = TRUE))

# clear all variables
rm(list=ls())
# set working directory
setwd("C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/")
# ticker data directory
tickerDir <- "./ticker_data/"

# list of symbols to skip
invalidTicks <- c(""," ","CON", "PRN", "AUX", "NUL")

# read in list of Tickers to parse (moved to get from daily data file)
#tickers <- as.character(read.csv(paste(tickerDir, "__allTickers.csv",sep=""))[,1])

file_list<-list.files(pattern=".csv")
tickerFiles <- list.files(tickerDir)  # list of current data files


for (file in file_list){
	
	if (file.info(file)$size==0) stop("Empty Data File!!!")  # check for empty file
	curFile <- read.csv(file) # read daily datafile
	print(file)
	tickers <- as.character(curFile$Ticker) #get ticker list
	
	fileDate <- data.frame(Date=as.Date(substr(file,1,8),format="%Y%m%d")) # strip .csv extension
	
	for (symb in tickers){
		if (symb%in%invalidTicks) {
			next # skip invalid tickers
		}
		
		#check if file exists, if not, create it
		if (paste(symb,".csv",sep="")%in%tickerFiles) {
			tickFile <- read.csv(paste(tickerDir,symb,".csv",sep=""))
			tickFile$Date<-as.Date(tickFile$Date) #convert Date column to Date format, otherwise rbind() doesn't match
			
			if (tail(tickFile$Date,1)==fileDate$Date) {
			tickFile <- tickFile[1:nrow(tickFile)-1,] #if data for current date exists, erase it
			}
		
			write.csv(rbind(tickFile,cbind(fileDate,curFile[curFile$Ticker==symb,])),paste(tickerDir,symb,".csv",sep=""),row.names=FALSE)
		} else { #create new file
			write.csv(cbind(fileDate,curFile[curFile$Ticker==symb,]),paste(tickerDir,symb,".csv",sep=""),row.names=FALSE)
		}
	}
	
}

	
