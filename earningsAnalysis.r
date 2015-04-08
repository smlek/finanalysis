# Stan Mlekodaj
#
# Loads and analyzes parsed earnings data produced by parseEarningsData.r
###############################################################################

# Clear variables and load packages
rm(list=ls())
require(xts)

# Data directories.  Assumes R directory is "Rscripts"
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
finDataDir<-paste(Sys.getenv("HOME"),"/Finance/earnings_database/all_close/",sep="")
earnDataFile <- "earningsData.csv"

# read earnings data (pre-parsed)
eData<-read.csv(paste(dataDir,earnDataFile,sep=""))

# data cleanup
names(eData)<-tolower(names(eData)) # make headings all lowercase for simplicity
eDataNum <- eData[,-c(1:5,68:71)] #remove non-numeric columns

# Correlations
earnCor <- cor(eDataNum,eData$chgaftearn,use="pairwise.complete",method="spearman")

index <- which(eDataNum$chgaftearn >= 0.1 | eDataNum$chgaftearn < -0.1) #index for correlation
earnCor <- cor(eDataNum[index,],eData$chgaftearn[index],use="pairwise.complete",method="spearman")
RSIsma20cor <- cor(eData$relative.strength.index..14.,eData$x20.day.simple.moving.average,
                use="pairwise.complete",method="spearman")

#interaction.plot(eData$earndate,eData$sector,eData$change)

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

numInd <- length(levels(eData$industry))
for (ind in 1:numInd) {
	v1 <- subset(eData, eData$industry==levels(eData$industry)[ind])
	Industry[ind] <- levels(eData$industry)[ind]
	PerfMonth[ind] <- mean(v1$performance..month, na.rm = TRUE)
	PerfQtr[ind] <-  mean(v1$performance..quarter, na.rm = TRUE)
	PerfYear[ind] <-  mean(v1$performance..year, na.rm = TRUE)
	PerfYTD[ind] <-  mean(v1$performance..ytd, na.rm = TRUE)
	SMA50[ind] <- mean(v1$x50.day.simple.moving.average, na.rm = TRUE)
	SMA200[ind] <-  mean(v1$x200.day.simple.moving.average, na.rm = TRUE)
	VolatMonth[ind] <-  mean(v1$volatility..month, na.rm = TRUE)
	PE[ind] <- mean(v1$p.e, na.rm = TRUE)
	PB[ind] <- mean(v1$p.b, na.rm = TRUE)
	AvgEChg[ind] <- mean(v1$change, na.rm = TRUE)
	StDevEChg[ind] <- sd(v1$change, na.rm = TRUE)
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

numSec <- length(levels(eData$sector))
for (ind in 1:numSec) {
	v1 <- subset(eData, eData$sector==levels(eData$sector)[ind])
	Sector[ind] <- levels(eData$sector)[ind]
	PerfMonth[ind] <- mean(v1$performance..month, na.rm = TRUE)
	PerfQtr[ind] <-  mean(v1$performance..quarter, na.rm = TRUE)
	PerfYear[ind] <-  mean(v1$performance..year, na.rm = TRUE)
	PerfYTD[ind] <-  mean(v1$performance..ytd, na.rm = TRUE)
	SMA50[ind] <- mean(v1$x50.day.simple.moving.average, na.rm = TRUE)
	SMA200[ind] <-  mean(v1$x200.day.simple.moving.average, na.rm = TRUE)
	VolatMonth[ind] <-  mean(v1$volatility..month, na.rm = TRUE)
	PE[ind] <- mean(v1$p.e, na.rm = TRUE)
	PB[ind] <- mean(v1$p.b, na.rm = TRUE)
	AvgEChg[ind] <- mean(v1$change, na.rm = TRUE)
	StDevEChg[ind] <- sd(v1$change, na.rm = TRUE)
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
	


	