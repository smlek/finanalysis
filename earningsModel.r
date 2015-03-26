rm(list=ls())

# Local directory
#paste(Sys.getenv("HOME"),"/Rscripts",sep="")

file <- "C:/Users/smlek001/Desktop/Finance/earnings_database/EarningsData4q2013.csv"
todayDate <- format(Sys.Date(),"%Y%m%d")

earnData <- read.csv(file)
numData <- earnData[,-c(1,2,3,37)] #remove non-numeric data


model1 <- lm(numData$Change.After~.,data=numData)
model2 <- lm(abs(numData$Change.After)~.,data=numData)
#model3 <- lm(abs(numData$Change.After)~Float.Short+Profit.Margin+Volatility..Week.+EPS..,data=numData)
model3 <- lm(abs(numData$Change.After)~Float.Short+Profit.Margin+Volatility..Week.+Volatility..Month.+EPS..,data=numData)

#earnData$Earnings.Date <- as.Date(earnData$Earnings.Date)


#download.file("http://finviz.com/export.ashx?v=151&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68",method="internal",mode="wb",fileName)
# filtered for Optionable & Earnings Today After Close
#http://finviz.com/export.ashx?v=151&f=earningsdate_todayafter,sh_opt_option&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68

# earnings tomorow before open
#http://finviz.com/export.ashx?v=151&f=earningsdate_tomorrowbefore,sh_opt_option&c=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68
