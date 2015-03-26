# Downloads daily stock data from FinViz.com and parses it by ticker and by date
# If ticker files dont exist, it creates it. If exists, appends new data.
#
#
#
rm(list=ls())
# set working directory
setwd("C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/")
# ticker data directory
tickerDir <- "./ticker_data/"
# daily file archive
archiveDir <- "./daily_archive/"
# list of symbols to skip
invalidTicks <- c(""," ","CON", "PRN", "AUX", "NUL")
# list of current data files
tickerFiles <- list.files(tickerDir)  

todayDate <- format(Sys.Date(),"%Y%m%d")
file <- paste(todayDate, ".csv",sep="") #filename is today's date
download.file("http://finviz.com/export.ashx?v=151&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68",method="internal",mode="wb",file)
if (file.info(file)$size==0) stop("Empty Data File!!!")  # check for empty file

# filtered for Optionable & Earnings Today After Close
#http://finviz.com/export.ashx?v=151&f=earningsdate_todayafter,sh_opt_option&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68

# earnings tomorow before open
#http://finviz.com/export.ashx?v=151&f=earningsdate_tomorrowbefore,sh_opt_option&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68

# parse into individual ticker files
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
			#if data for current date exists, erase it
			if (tail(tickFile$Date,1)==fileDate$Date) {
			tickFile <- tickFile[1:nrow(tickFile)-1,] 
			}
			# append to existing data
			write.csv(rbind(tickFile,cbind(fileDate,curFile[curFile$Ticker==symb,])),paste(tickerDir,symb,".csv",sep=""),row.names=FALSE)
		} else { #create new file
			write.csv(cbind(fileDate,curFile[curFile$Ticker==symb,]),paste(tickerDir,symb,".csv",sep=""),row.names=FALSE)
		}
	}
	
file.copy(file, archiveDir) #archive parsed file
if (file.exists(paste(archiveDir,file, sep=""))) {
	file.remove(file)
	}