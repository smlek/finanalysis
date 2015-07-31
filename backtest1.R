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

# initialize matrix of strategy returns
returns <- xts()
tzone(returns) <- tzone(big19$SPY)
returns$SPY_REF <- big19$SPY$daily.returns     # SPY as market benchmark

# loop over all stocks 
#i <- "AAPL"
for (i in ls(big19)) {
        curData <- get(i,envir=big19)

        # strategy
        trigger <- curData$daily.returns[lag(curData$rsi14 < 20)]    # RSI<20
        
        names(trigger) <- i     # rename to ticker
        returns<-merge.xts(returns,trigger,join="left")  # "left" to keep reference time index
}

Return.cumulative(returns)
sum(Return.cumulative(returns)[-1])

max(rowSums(!is.na(returns["2007"][,-1]))) # max daily portfolio size (count non-NA values by row)

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
#                       BBands

#       Create long & short indicators. Buy/Sell when indicator transitions
#               Negate returns during short periods to use standard perf. meas.

        
# SPY backtesting




# Backtest on EOD close data
# long/short ideas:
#       bolinger bands, i.e. SMA +/- xSDDEVs
#       bolinger bands vs. market, industry, sector
#       RSI
#       trends: EMA, SMA
#       volatility, volume
#       Gap/OHLC
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




