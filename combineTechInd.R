# Stan Mlekodaj
#
###############################################################################
rm(list=ls())
library(xts)
# library(TTR)
# library(quantmod)
# library(PerformanceAnalytics)
library(RSNNS)
#library(ROCR)
library(caret)

#########  FOLDER LOCATIONS  ##################################################
# R data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")


#########  INPUTS  ############################################################
#quotesTechsFile <- "largeCap2007TechInd" # OHLC, returns, tech indicators for 19 US large caps
quotesTechsFile <- "nasdaq100_2007TechInd" # OHLC, returns, tech indicators for Nasdaq100


#########  OUTPUTS  ###########################################################

###############################################################################


# Load datafile with historical quotes & tech indicators into a new environment
env1 <- new.env()
load(file = quotesTechsFile,envir=env1)


# Merge into one dataset
i <- "AAPL"
dailyData <- data.frame()
for (i in ls(env1)) {
        curData <- data.frame(get(i,envir = env1)[, -(1:6)], row.names = NULL)
        dailyData <- rbind(curData, dailyData)
}

dailyData <- na.omit(dailyData)
save(dailyData, file = "nasdaq100_2007TechInd_combined")






