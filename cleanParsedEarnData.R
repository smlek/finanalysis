# Stan Mlekodaj
# March 1, 2016
# Takes output of parseEarningsData, cleans it, saves it.
# Cleaning: 
#       - Removes non-numerical columns
#       - Removes 2 columns with high NA counts which would otherwise
#               reduce the data set significantly
###############################################################################

rm(list=ls())


#########  INPUTS  ############################################################
# data directory
dataDir<-paste(Sys.getenv("HOME"),"/Rscripts/data/",sep="")
# input data file
dataFile <- "earningsData.csv"
inputData <- read.csv(paste(dataDir,dataFile,sep=""))
nonNumericCols <- c(1:5, 68:71) # non-numeric column indexes

# file <- "C:/Users/smlek001/Documents/Finance/earnings_database/EarningsData4q2013.csv"
# earnData <- read.csv(file)
# nonNumericCols <- c(1,2,3,37)

###############################################################################

#########  OUTPUTS  ###########################################################
# Output file
outputFile <- paste(dataDir, "earningsData_cleaned_Robj", sep="")
###############################################################################

# select input data - can filter by sector, country, etc.
earnData <- inputData

# flags for data cleaning
removeNonNumerics <- TRUE
removeNArows <- TRUE

#remove non-numeric data
if (removeNonNumerics) {
        #earnData <- earnData[, -nonNumericCols] 
        earnData <- earnData[, sapply(earnData, is.numeric)]
}

# removing columns with high NA count
earnData <- subset(earnData, select = -c(Dividend.Yield, P.Free.Cash.Flow))

# count incomplete rows with at least one NA column
naRows <- apply(earnData, 1, function(x){any(is.na(x))})
numNArows <- sum(naRows)
naRowRate <- numNArows / nrow(earnData) 

# # count incomplete columns with at least one NA row
# naCols <- apply(earnData, 2, function(x){any(is.na(x))})
# numNAcols <- sum(naCols)
# naColRate <- numNAcols / ncol(earnData) 

# nasPerRow <- sort(apply(earnData, 1, function(x){sum(is.na(x))}))
# nasPerCol <- sort(apply(earnData, 2, function(x){sum(is.na(x))}))

# create new data set of complete rows
#earnDataComplete <- earnData[!naRows, ]

# remove all rows with NA's
if (removeNArows) {
        earnData <- earnData[!naRows, ]
}

# save cleaned data
save(earnData, file = outputFile)
