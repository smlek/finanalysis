# Stan Mlekodaj
#
# Search thru daily archive data and sift earnings and associated data
# need to pull out EOD data just before earnings and the % change from day after earnings
# This is specific to database from FinViz
###############################################################################
rm(list=ls())
########### start/end date for searching for earnings #############
# endData should  be second to last file collected in order to parse last file
startDate <- as.Date("2014-04-01") 	#YYYY-MM-DD format
endDate <- as.Date("2014-04-21")   	#YYYY-MM-DD format
###################################################################


# output data file
outFile <- "earningsData.csv"

#data file verification - number of columns
tickerFileCols <- 69
archiveFileCols <- 68

# output data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
# ticker data directory
tickerDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/ticker_data/",sep="")
# daily file archive
archiveDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/daily_archive/",sep="")

# list of current data files
tickerFiles <- list.files(tickerDir,pattern=".csv")
archiveFiles <- list.files(archiveDir,pattern=".csv")

# files between start/end dates to be searched
fileList <- archiveFiles[(as.Date(substr(archiveFiles,1,8),format="%Y%m%d")>=startDate)&(as.Date(substr(archiveFiles,1,8),format="%Y%m%d")<=endDate)]


#for each daily file except the last one (last one is for only after-earnings data)
for (i in 1:(length(fileList)-1)) {
#i <- 1
        fileToday <- fileList[i]
        fileTomorrow <- fileList[i+1]
	print(fileToday)
	curDate <- as.Date(substr(fileToday,1,8),format="%Y%m%d") #date of data
	curFile <- read.csv(paste(archiveDir,fileToday,sep=""))   # today's data file
        nextFile <- read.csv(paste(archiveDir,fileTomorrow,sep=""))   # next day data file
        curFile$Ticker<-as.character(curFile$Ticker)
        nextFile$Ticker<-as.character(nextFile$Ticker)
        
        if (ncol(curFile)!=archiveFileCols) stop("Invalid Data File Format!") # check for proper datafile size

	#if (ncol(curFile)!=tickerFileCols) stop("Invalid Data File Format!") # check for proper datafile size

	#converting Earnings.Date to readable format
	# column has varying formats, sometimes date, date+hh:mm, date time sec AM/PM,
	# add column with date when data was collected
	dataDate <- data.frame(Data.Date=rep(curDate,nrow(curFile)),row.names=NULL)
	EarnDate <- as.Date(curFile$Earnings.Date,format='%m/%d/%Y')#only gives the date 
	#strptime(curFile$Earnings.Date,format='%m/%d/%Y %I:%M:%S %p') #gives NA if different format, date+time if compliant format
	EarnHour <- as.numeric(substr(strptime(curFile$Earnings.Date,format='%m/%d/%Y %H:%M'),12,13))  #extracts the hour digits. can be 12 or 24 format
	EarnTime <- replace(EarnHour,EarnHour%in%c(7,8),"Morning")
	EarnTime <- replace(EarnTime,EarnTime%in%c(4,16),"Afternoon")
	EarnTime <- replace(EarnTime,!EarnTime%in%c("Morning","Afternoon"),"") #blank if not Morning or Afternoon
	
	curFile <- cbind(curFile,EarnDate,EarnTime,dataDate) #add columns with earnings date, am/pm, data collection date
	
        # only extracting earnings where date and time are listed. If time unlisted, earnings likely unconfirmed
	# if earnings were yesterday afternoon or today morning, then extract data
	#daysData <- subset(curFile,((EarnDate==curDate)&(EarnTime=="Morning"))|((EarnDate==(curDate-1))&(EarnTime=="Afternoon")))

        # extract EOD data (pre-earnings) if earnings are today afternoon or tomorrow mornings
        # Then, extract $Change, $Gap from next day's data (post earnings)
        eodData <- subset(curFile,((EarnDate==curDate)&(EarnTime=="Afternoon"))|((EarnDate==(curDate+1))&(EarnTime=="Morning")))
        postEarn <- subset(nextFile,nextFile$Ticker%in%eodData$Ticker)
        # find after-earnings data
        if (nrow(eodData)>0) { #check if any earnings found
                
                for (j in 1:length(eodData$Ticker)) {
                        if (j==1){
                                daysData <- cbind(eodData[j,],
                                                  ChgAftEarn=subset(postEarn,postEarn$Ticker==eodData[j,]$Ticker)$Change,
                                                  GapAftEarn=subset(postEarn,postEarn$Ticker==eodData[j,]$Ticker)$Gap)
                        } else {
                                daysData <- rbind(daysData,cbind(eodData[j,],
                                                        ChgAftEarn=subset(postEarn,postEarn$Ticker==eodData[j,]$Ticker)$Change,
                                                        GapAftEarn=subset(postEarn,postEarn$Ticker==eodData[j,]$Ticker)$Gap))
                        }
                                
                } 
        
        
        	if (!exists("parsedEarnings")) {
        		parsedEarnings <- daysData
        	} else {
        		#check for recent duplicate earnings (10 days), delete older data
        		parsedEarnings <- parsedEarnings[!((parsedEarnings$Ticker%in%daysData$Ticker)&parsedEarnings$EarnDate%in%(curDate-10:1)),]
        		#append new data
        		parsedEarnings <- rbind(parsedEarnings,daysData)
        	}
        }
	# clear variables in the loop
	rm(fileToday,fileTomorrow,curDate,curFile,nextFile,eodData,postEarn,dataDate,EarnDate,EarnHour,EarnTime,daysData)
}

#output file 
if ((outFile %in% list.files(path=dataDir,pattern=".csv"))){
	earningsData <- read.csv(paste(dataDir,outFile,sep=""))
	write.csv(rbind(earningsData,parsedEarnings),paste(dataDir,outFile,sep=""),row.names=FALSE)
} else {
	write.csv(parsedEarnings,paste(dataDir,outFile,sep=""),row.names=FALSE)
}
