# Stan Mlekodaj
# April 14, 2015
#
# Takes a list of stock symbols from a csv file and downloads historical data
# from Yahoo Finance. Then adjusts Close prices for dividends/splits. Then adds
# various technical indicators to each downloaded symbol and saves all results
# into a R datafile.
###############################################################################
rm(list=ls())
library(xts)
library(TTR)
library(quantmod)

#########  EXTERNAL FUNCTIONS  ################################################
source("finFuncs.R")

#########  FOLDER LOCATIONS  ##################################################
# R data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
# ticker data directory
tickerDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/ticker_data/",sep="")
# daily file archive directory
archiveDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/daily_archive/",sep="")

#########  INPUTS  ############################################################
# csv stock symbol files
symbFile <- "largecapsymbs.csv"
usc401kFile <- "usc401kSymbs.csv"
# Input R data files
quoteFile <- "largeCap2007" # OHLC data for 19 US large caps. 2007-April 2015
# SP500 5yr data
sp5yr<-read.csv(paste(dataDir,"/sp500_5yr.csv",sep=""))
sp5yr$Date<-as.Date(sp5yr$Date,format='%m/%d/%Y')       #format date
sp5yrts<-xts(sp5yr[,-1],sp5yr$Date)     # time series object
rm(sp5yr)

#########  OUTPUTS  ###########################################################
# Output file
quotesTechsFile <- "largeCap2007TechInd" # contains OHLC, Returns, tech indicators for 19 US large caps
sp5yrFile <- "sp5yrsXTS"
###############################################################################

envmt <- new.env()

## Get historical data for symbols in symbFile list (only need to do once)
# symbs<-as.character(read.csv(paste(dataDir,symbFile,sep=""),header=FALSE)[,1])
# getSymbols(symbs,env=envmt,src="yahoo")
# save(list = ls(envmt), file = quoteFile,envir=envmt) # save to datafile

# load OHLC data file 
load(file = quoteFile,envir=envmt)
# Add technical indicators to symbols 
for (i in ls(envmt)) {
        addSymbAnalysis(i,envmt=envmt)
}

# save price & tech indicators into datafile
save(list = ls(envmt), file = quotesTechsFile, envir=envmt)
save(sp5yrts,file=sp5yrFile)

