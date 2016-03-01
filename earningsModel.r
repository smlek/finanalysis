# Stan Mlekodaj
# March 1, 2016

###############################################################################

rm(list=ls())
todayDate <- format(Sys.Date(),"%Y%m%d")


#########  INPUTS  ############################################################
# data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
# input data file
dataFile <- "earningsData_cleaned_Robj"
inputData <- load(paste(dataDir,dataFile,sep=""))

###############################################################################

#########  OUTPUTS  ###########################################################
# Output file

###############################################################################





model1 <- lm(ChgAftEarn~.,data=earnData)
#model2 <- lm(abs(earnData$Change.After)~.,data=earnData)
#model3 <- lm(abs(earnData$Change.After)~Float.Short+Profit.Margin+Volatility..Week.+EPS..,data=earnData)
#model3 <- lm(abs(earnData$Change.After)~Float.Short+Profit.Margin+Volatility..Week.+Volatility..Month.+EPS..,data=earnData)

#earnData$Earnings.Date <- as.Date(earnData$Earnings.Date)

library(caret)
cvCtrl <- trainControl(method = "repeatedcv", repeats = 3,
                       summaryFunction = twoClassSummary,
                       classProbs = TRUE
                       )

grid <- expand.grid(.model = "tree",
                    .trials = c(1:100),
                    .winnow = FALSE
                   )





#download.file("http://finviz.com/export.ashx?v=151&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68",method="internal",mode="wb",fileName)
# filtered for Optionable & Earnings Today After Close
#http://finviz.com/export.ashx?v=151&f=earningsdate_todayafter,sh_opt_option&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68

# earnings tomorow before open
#http://finviz.com/export.ashx?v=151&f=earningsdate_tomorrowbefore,sh_opt_option&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68
