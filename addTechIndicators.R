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

#########  OUTPUTS  ###########################################################
# Output file
quotesTechsFile <- "largeCap2007TechInd" # contains OHLC, Returns, tech indicators for 19 US large caps

###############################################################################

envmt <- new.env()

# Get historical data for symbols in symbFile list
# symbs<-as.character(read.csv(paste(dataDir,symbFile,sep=""),header=FALSE)[,1])
# envmt <- new.env()
# getSymbols(symbs,env=envmt,src="yahoo")
#save(list = ls(envmt), file = quoteFile,envir=envmt) # save to datafile

# load OHLC data file 
load(file = quoteFile,envir=envmt)

#i<-ls(envmt)[1] # debugging
for (i in ls(envmt)) {
        # initialize indicators
        atr14<-bbands202<-cmf20<-cmo14<-ema20<-vwma20<-macd12269<-rsi14<-
                stoch1433<-wpr<-indicators<-curData<-
                dayret<-weekret<-monthret<-
                list()
        
        curData <- adjustOHLC(get(i,envir=envmt),use.Adjusted=TRUE) #replace Close with Adjusted prices
        #curData<-curData["2014"] # debugging
        
        # Returns
        dayret <- periodReturn(curData,period="daily", type="arithmetic")
        weekret <- periodReturn(curData,period="weekly", type="arithmetic")
        monthret <- periodReturn(curData,period="monthly", type="arithmetic")
        
        # Technical indicators
        atr14 <- ATR(HLC(curData), n=14, maType="EMA") # Average True Range
        bbands202 <- BBands(HLC(curData),n=20,sd=2) #Bollinger Bands
        cmf20 <- CMF(HLC(curData),Vo(curData),n=20); names(cmf20) <- "cmf20" #Chaikin Money Flow
        cmo14 <- CMO(Cl(curData),n=14); names(cmo14) <- "cmo14" # Chande Momentum Oscillator
        ema20 <- EMA(Cl(curData),n=20,wilder = FALSE); names(ema20) <- "ema20" # Exponential moving average
        vwma20 <- VWMA(Cl(curData),Vo(curData),n=20); names(vwma20) <- "vwma20" # Volume-weighed moving average
        macd12269 <- MACD(Cl(curData), nFast = 12, nSlow = 26, nSig = 9, maType="EMA", percent = TRUE) # MACD
        rsi14 <- RSI(Cl(curData),n=14,maType="SMA"); names(rsi14) <- "rsi14" # RSI
        stoch1433 <- stoch(HLC(curData), nFastK = 14, nFastD = 3, nSlowD = 3) # Stochastic oscillator-overbought(oversold) if >80 (<20)
        wpr14 <- WPR(HLC(curData), n = 14); names(wpr14) <- "wpr14" # William's %R - overbought(oversold) if <20 (>80)
        
        # add all indicators columns to original price data
        indicators <- merge(curData, 
                         dayret,
                         weekret,
                         monthret,
                         atr14,
                         bbands202,
                         cmf20,
                         cmo14,
                         ema20,
                         vwma20,
                         macd12269,
                         rsi14,
                         stoch1433,
                         wpr14
                         )
        # replace original data
        assign(i,indicators,envir=envmt)
}

# save price & tech indicators into datafile
save(list = ls(envmt), file = quotesTechsFile, envir=envmt)

