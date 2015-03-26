# Search thru daily archive data and sift earnings and associated data

rm(list=ls())

########### start/end date for searching for earnings #############
startDate <- as.Date("2014-04-01") 				#YYYY-MM-DD format
endDate <- as.Date("2014-08-20")   				#YYYY-MM-DD format
###################################################################

# output data file
outFile <- "earningsData.csv"

#data file verification - number of columns
tickerFileCols <- 69
archiveFileCols <- 68

## set working directory
#setwd("C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/")

# ticker data directory
tickerDir <- "C:/Users/smlek001/Desktop/Finance/earnings_database/all_close//ticker_data/"
# daily file archive
archiveDir <- "C:/Users/smlek001/Desktop/Finance/earnings_database/all_close//daily_archive/"

# list of current data files
tickerFiles <- list.files(tickerDir,pattern=".csv")
archiveFiles <- list.files(archiveDir,pattern=".csv")

# files between start/end dates to be searched
fileList <- archiveFiles[(as.Date(substr(archiveFiles,1,8),format="%Y%m%d")>=startDate)&(as.Date(substr(archiveFiles,1,8),format="%Y%m%d")<=endDate)]

#for each daily file
for (file in fileList){
	print(file)
	curDate <- as.Date(substr(file,1,8),format="%Y%m%d") #date of data
	curFile <- read.csv(paste(archiveDir,file,sep=""))   # data file
	if (ncol(curFile)!=archiveFileCols) stop("Invalid Data File Format!") # check for proper datafile size


	#curFile <- read.csv(paste(tickerDir,tickerFiles[2],sep=""))
	#if (ncol(curFile)!=tickerFileCols) stop("Invalid Data File Format!") # check for proper datafile size

	#converting Earnings.Date to readable format
	# column has varying formats, sometimes date, date+hh:mm, date time sec AM/PM,
	#EarnDate <- as.Date(strptime(curFile$Earnings.Date,format='%m/%d/%Y')) #only gives the date
	
	# add column with date when data was collected
	dataDate <- data.frame(Data.Date=rep(curDate,nrow(curFile)),row.names=NULL)
	EarnDate <- as.Date(curFile$Earnings.Date,format='%m/%d/%Y')#only gives the date 
	#strptime(curFile$Earnings.Date,format='%m/%d/%Y %I:%M:%S %p') #gives NA if different format, date+time if compliant format
	EarnHour <- as.numeric(substr(strptime(curFile$Earnings.Date,format='%m/%d/%Y %H:%M'),12,13))  #extracts the hour digits. can be 12 or 24 format
	EarnTime <- replace(EarnHour,EarnHour%in%c(7,8),"Morning")
	EarnTime <- replace(EarnTime,EarnTime%in%c(4,16),"Afternoon")
	EarnTime <- replace(EarnTime,!EarnTime%in%c("Morning","Afternoon"),"") #blank if not Morning or Afternoon
	
	curFile <- cbind(curFile,EarnDate,EarnTime,dataDate) #add columns with earnings date, am/pm, data collection date
	
	# if earnings were yesterday afternoon or today morning, then extract data
	#curFile$Date <- as.Date(curFile$Date)
	#curFile[((curFile$Date==EarnDate)&(EarnHour==8))|(((curFile$Date-1)==EarnDate)&(EarnHour==16))==TRUE,] #for ticker files
	#daysData <- subset(curFile,((EarnDate==curDate)&(EarnHour==8))|((EarnDate==(curDate-1))&((EarnHour==16|EarnHour==4))))
	daysData <- subset(curFile,((EarnDate==curDate)&(EarnTime=="Morning"))|((EarnDate==(curDate-1))&(EarnTime=="Afternoon")))


	#if daysData$Ticker is in parsedEarnings[last 5 days]
	if (!exists("parsedEarnings")) {
		parsedEarnings <- daysData
	} else {
		#check for recent duplicate earnings (10 days), delete older data
		parsedEarnings <- parsedEarnings[!((parsedEarnings$Ticker%in%daysData$Ticker)&parsedEarnings$EarnDate%in%(curDate-10:1)),]
		#append new data
		parsedEarnings <- rbind(parsedEarnings,daysData)
	}
	

	# clear variables in the loop
	rm(curDate,curFile,EarnDate,EarnHour,EarnTime)
}


#output file 
if ((outFile %in% list.files(pattern=".csv"))){
	earningsData <- read.csv(outFile)
	write.csv(rbind(earningsData,parsedEarnings),outFile,row.names=FALSE)
} else {
	write.csv(parsedEarnings,outFile,row.names=FALSE)
}
