# Stan Mlekodaj
#
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
quotesTechsFile <- "largeCap2007TechInd" # contains OHLC, returns, tech indicators for 19 US large caps
# Input R data files
#quoteFile <- "largeCap2007" # OHLC data for 19 US large caps. 2007-April 2015
# SP500 5yr data
sp5yr<-read.csv(paste(dataDir,"/sp500_5yr.csv",sep=""))
sp5yr$Date<-as.Date(sp5yr$Date,format='%m/%d/%Y')       #format date
sp5yrts<-xts(sp5yr[,-1],sp5yr$Date)     # time series object

#########  OUTPUTS  ###########################################################

###############################################################################


# Load datafile with historical quotes & tech indicators into a new environment
env1 <- new.env()
load(file = quotesTechsFile,envir=env1)
ret <- xts()

i<-ls(env1)[1] 

#for (i in ls(env1)) {
        curData <- get(i,envir=env1)
        dayret <- curData$daily.returns; names(dayret) <- i
        ret <- merge(ret,
                     dayret)

        trigger <- curData$daily.returns[curData$rsi14 < 20]
#}

# Analysis 
# cumulative returns - look for periodicity
# 
# Return.cumulative(envmt$AAPL$daily.returns["2007"])
# Return.cumulative(envmt$AAPL$weekly.returns["2007"])
# 
# backtester outline:
#         load price data (& others) as xts - getSymbols()                              DONE
#         calculate returns                     - ClCl(), diff(log()), periodReturn()   DONE
#         add marker & analysis columns. Account for calculation delay  - TTR package   DONE
#       Create list of strategies
#               Simple:
#                       RSI
#       Create long & short indicators. Buy/Sell when indicator transitions

# Backtest on EOD close data
# long/short ideas:
#       bolinger bands, i.e. SMA +/- xSDDEVs
#       bolinger bands vs. market, industry, sector
#       RSI
#       trends: EMA, SMA
#       volatility, volume
#       Gap
#       USD/EUR
#       other indexes USA & foreign
# In order to use TTR package for indicators, need OHLC price objects (getSymbols)


# Backtest on FinViz database
#  ideas:
#         analyst recomm, change
#         earnings results (changes in forecast EPS)
#         P/B, valuation


# Example
f



