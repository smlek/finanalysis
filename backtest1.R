# Stan Mlekodaj
#
###############################################################################
rm(list=ls())
library(xts)
library(TTR)
library(quantmod)

# R data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
# ticker data directory
tickerDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/ticker_data/",sep="")
# daily file archive directory
archiveDir <- paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/daily_archive/",sep="")
# datafiles
largeCapFile <- "largecapsymbs.csv"
usc401kFile <- "usc401kSymbs.csv"

# read SP500 5yr data
sp5yr<-read.csv(paste(dataDir,"/sp500_5yr.csv",sep=""))
sp5yr$Date<-as.Date(sp5yr$Date,format='%m/%d/%Y')       #format date
sp5yrts<-xts(sp5yr[,-1],sp5yr$Date)     # time series object


# Analysis 
# cumulative log-returns - look for periodicity
#
# 
# backtester outline:
#         load price data (& others) as xts - getSymbols()
#         calculate returns                     - ClCl(), diff(log()), periodReturn()
#         add marker & analysis columns. Account for calculation delay  - TTR package
#         add long & short indicators. Buy/Sell when indicator transitions

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

# Get historical data for 19 large cap symbols listed in csv file, the save to datafile
# largeCapSymbs<-as.character(read.csv(paste(dataDir,largeCapFile,sep=""),header=FALSE)[,1])
# largeCap <- new.env()
# largeCaps2007<-getSymbols(largeCapSymbs,env=largeCap,src="yahoo")
# save(list = ls(largeCap), file = "largeCap2007",envir=largeCap)

# load large cap historical quotes data file
largeCap <- new.env()
load(file ="largeCap2007",envir=largeCap)

envmt <- largeCap
for (i in ls(envmt)) {
        curData <- adjustOHLC(get(i,envir=envmt),use.Adjusted=TRUE) #replace Close with Adjusted
        assign(i,curData,envir=envmt) 
        curData<-curData["2014"] # debugging
        ATR(HLC(curData), n=14, maType="EMA") # Average True Range
        BBands(HLC(curData),n=20,sd=2) #Bollinger Bands
        #When Chaikin Money Flow is above/below +/- 0.25 it is a bullish/bearish signal. 
        #If Chaikin Money Flow remains below zero while the price is rising, it indicates a probable reversal.
        CMF(HLC(curData),Vo(curData),n=20) #Chaikin Money Flow
        CMO(Cl(curData),n=14) # Chande Momentum Oscillator
        EMA(Cl(curData),n=20,wilder = FALSE) # Exponential moving average
        VWMA(Cl(curData),Vo(curData),n=20) # Volume-weighed moving average
        MACD(Cl(curData), nFast = 12, nSlow = 26, nSig = 9, maType="EMA", percent = TRUE)
        RSI(Cl(curData),n=14)
        stoch(HLC(curData), nFastK = 14, nFastD = 3, nSlowD = 3) # Stochastic oscillator-overbought(oversold) if >80 (<20)
        WPR(HLC(curData), n = 14) # William's %R - overbought(oversold) if <20 (>80)
}


ATR(largeCap$AAPL["2014"])
merge(largeCap$AAPL["2014"],ATR(largeCap$AAPL["2014"])) # add ATR indicator
