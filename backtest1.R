# Stan Mlekodaj
#
###############################################################################
rm(list=ls())
library(xts)
library(TTR)
library(quantmod)
library(PerformanceAnalytics)

#########  FOLDER LOCATIONS  ##################################################
# R data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
# ticker data directory
tickerDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/ticker_data/",sep="")
# daily file archive directory
archiveDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/daily_archive/",sep="")

#########  INPUTS  ############################################################
quotesTechsFile <- "largeCap2007TechInd" # OHLC, returns, tech indicators for 19 US large caps
sp5yrFile <- "sp5yrsXTS" # SP500 5yr data XTS object

#########  OUTPUTS  ###########################################################

###############################################################################


# Load datafile with historical quotes & tech indicators into a new environment
big19 <- new.env()
load(file = quotesTechsFile,envir=big19)

#i<-ls(big19)[1] #debugging

for (i in ls(big19)) {
        curData <- get(i,envir=big19)


        trigger <- curData$daily.returns[curData$wpr14 < 20]
        
}

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

        
# SPY backtesting


rsi14Ret<-env1$SPY$daily.returns[lag(env1$SPY$rsi14 < 30)]





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
#
# Use PerfAnalytics to compute
#         annualized returns,
#         drawdown,
        

# Backtest on FinViz database
#  ideas:
#         analyst recomm, change
#         earnings results (changes in forecast EPS)
#         P/B, valuation


# Example




