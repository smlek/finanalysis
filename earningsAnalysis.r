# cor(a,method="spearman",use="pairwise.complete.obs")

# a=earningsData[6:67]
# cor(a, 
 
# Gap+Change.from.Open = Change-after-Earnings.  This is necessary since earnings are outside trading hours.

# Local directory
#paste(Sys.getenv("HOME"),"/Rscripts",sep="")
 
rm(list=ls())
# read earnings data (pre-parsed)

eData <-  read.csv("C:/Users/smlek001/Desktop/Finance/earnings_database/all_close/earningsData.csv")

#interaction.plot(eData$EarnDate,eData$Sector,eData$Change)


#avg chg vs. market chg

# #per sector:
# 1. sector performance, volatility, # companies, 
# 2. sector earnings: daily avg %chg, moving average over x days, 

# # market indicators, indexes (CPI), weather, GDP, currency

# # per industry
# 1. rank by top performance, top earnings

#industry analysis

Industry <- list()
PerfMonth <- list()
PerfQtr <- list()
PerfYear <- list()
PerfYTD <- list()
SMA50 <- list()
SMA200 <- list()
VolatMonth <- list()
PE <- list()
PB <- list()
AvgEChg <- list()
StDevEChg <- list()

numInd <- length(levels(eData$Industry))
for (ind in 1:numInd) {
	v1 <- subset(eData, eData$Industry==levels(eData$Industry)[ind])
	Industry[ind] <- levels(eData$Industry)[ind]
	PerfMonth[ind] <- mean(v1$Performance..Month, na.rm = TRUE)
	PerfQtr[ind] <-  mean(v1$Performance..Quarter, na.rm = TRUE)
	PerfYear[ind] <-  mean(v1$Performance..Year, na.rm = TRUE)
	PerfYTD[ind] <-  mean(v1$Performance..YTD, na.rm = TRUE)
	SMA50[ind] <- mean(v1$X50.Day.Simple.Moving.Average, na.rm = TRUE)
	SMA200[ind] <-  mean(v1$X200.Day.Simple.Moving.Average, na.rm = TRUE)
	VolatMonth[ind] <-  mean(v1$Volatility..Month, na.rm = TRUE)
	PE[ind] <- mean(v1$P.E, na.rm = TRUE)
	PB[ind] <- mean(v1$P.B, na.rm = TRUE)
	AvgEChg[ind] <- mean(v1$Change, na.rm = TRUE)
	StDevEChg[ind] <- sd(v1$Change, na.rm = TRUE)
	}
IndustryStats <- data.frame(Industry = as.character(Industry),
							PerfMonth = as.numeric(PerfMonth),
							PerfQtr = as.numeric(PerfQtr),
							PerfYear = as.numeric(PerfYear),
							PerfYTD = as.numeric(PerfYTD),
							SMA50 = as.numeric(SMA50),
							SMA200 = as.numeric(SMA200),
							VolatMonth= as.numeric(VolatMonth),
							PtoE = as.numeric(PE),
							PtoB = as.numeric(PB),
							AvgEarnChg = as.numeric(AvgEChg),
							StDevEarnChg = as.numeric(StDevEChg)
							)
	
#sector analysis
Sector <- list()
PerfMonth <- list()
PerfQtr <- list()
PerfYear <- list()
PerfYTD <- list()
SMA50 <- list()
SMA200 <- list()
VolatMonth <- list()
PE <- list()
PB <- list()
AvgEChg <- list()
StDevEChg <- list()

numSec <- length(levels(eData$Sector))
for (ind in 1:numSec) {
	v1 <- subset(eData, eData$Sector==levels(eData$Sector)[ind])
	Sector[ind] <- levels(eData$Sector)[ind]
	PerfMonth[ind] <- mean(v1$Performance..Month, na.rm = TRUE)
	PerfQtr[ind] <-  mean(v1$Performance..Quarter, na.rm = TRUE)
	PerfYear[ind] <-  mean(v1$Performance..Year, na.rm = TRUE)
	PerfYTD[ind] <-  mean(v1$Performance..YTD, na.rm = TRUE)
	SMA50[ind] <- mean(v1$X50.Day.Simple.Moving.Average, na.rm = TRUE)
	SMA200[ind] <-  mean(v1$X200.Day.Simple.Moving.Average, na.rm = TRUE)
	VolatMonth[ind] <-  mean(v1$Volatility..Month, na.rm = TRUE)
	PE[ind] <- mean(v1$P.E, na.rm = TRUE)
	PB[ind] <- mean(v1$P.B, na.rm = TRUE)
	AvgEChg[ind] <- mean(v1$Change, na.rm = TRUE)
	StDevEChg[ind] <- sd(v1$Change, na.rm = TRUE)
	}
SectorStats <- data.frame(Sector = as.character(Sector),
							PerfMonth = as.numeric(PerfMonth),
							PerfQtr = as.numeric(PerfQtr),
							PerfYear = as.numeric(PerfYear),
							PerfYTD = as.numeric(PerfYTD),
							SMA50 = as.numeric(SMA50),
							SMA200 = as.numeric(SMA200),
							VolatMonth= as.numeric(VolatMonth),
							PtoE = as.numeric(PE),
							PtoB = as.numeric(PB),
							AvgEarnChg = as.numeric(AvgEChg),
							StDevEarnChg = as.numeric(StDevEChg)
							)
	


	