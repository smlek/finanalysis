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
#quotesTechsFile <- "largeCap2007TechInd" # OHLC, returns, tech indicators for 19 US large caps
quotesTechsFile <- "nasdaq100_2007TechInd" # OHLC, returns, tech indicators for Nasdaq100


#########  OUTPUTS  ###########################################################

###############################################################################


# Load datafile with historical quotes & tech indicators into a new environment
env1 <- new.env()
load(file = quotesTechsFile,envir=env1)

#i<-ls(env1)[1] #debugging

# initialize matrix of strategy returns
returns <- xts()
tzone(returns) <- tzone(env1$SPY)
returns$SPY_REF <- env1$SPY$daily.returns     # SPY as market benchmark
leverage <- 1

# loop over all stocks 
#i <- "AAPL"
for (i in ls(env1)) {
        curData <- get(i,envir = env1)
        holdings <- longEnter <- longExit <- shortEnter <- shortExit <-
                rep(FALSE,length(curData$daily.returns)) # initialize holdings vector
        

        # STRATEGY. Using "lag" assuming buy at Close(n) giving returns(n+1). lag() fills in with NA's
        
        # LONG entry
        longEnter <- lag(curData$pctB < 0, k=1)      #below lower BBand
        #longEnter <- lag(curData$rsi14 < 20, k=1)    # RSI<20
        # LONG exit
        # SHORT entry (DONT FORGET TO NEGATE RETURNS)
        # SHORT exit
        
        holdings <- longEnter|longExit|shortEnter|shortExit
        # pull returns using long/short mask
        ret <- curData$daily.returns*holdings*leverage
                
        names(ret) <- i     # rename to ticker
        returns<-merge.xts(returns,ret,join="left")  # "left" to keep reference time index
}

# Performance Analysis
Return.cumulative(returns)
mean(Return.cumulative(returns)[-1]) #portfolio return except SPY

max(rowSums(!is.na(returns[,-1]))) # daily portfolio size (non-NA values by row except SPY)
mean(rowSums(!is.na(returns[,-1])))



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
#       Create long & short indicators. Buy/Sell when indicator transitions
#               Negate returns during short periods to use standard perf. meas.







