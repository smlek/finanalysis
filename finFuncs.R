# Stan Mlekodaj
#
# Various functions 
#

library(xts)
library(TTR)
library(quantmod)

# Add returns & technical indicators to price object made by getSymbols
# Replaces Close data with Adjusted Close
addSymbAnalysis<-function(i,envmt){
        
        # initialize indicators
        atr14<-bbands202<-cmf20<-cmo14<-ema20<-vwma20<-macd12269<-rsi14<-
                stoch1433<-wpr<-indicators<-curData<-
                dayret<-weekret<-monthret<-
                list()
        
        curData <- adjustOHLC(get(i,envir=envmt),use.Adjusted=TRUE) #replace Close with Adjusted prices
        
        # Returns
        dayret <- periodReturn(curData,period="daily", type="arithmetic")
        weekret <- periodReturn(curData,period="weekly", type="arithmetic")
        monthret <- periodReturn(curData,period="monthly", type="arithmetic")
        
        # Technical indicators
        atr14 <- ATR(HLC(curData), n=14, maType="EMA") # Average True Range
        bbands202 <- BBands(HLC(curData),n=20,sd=2) #Bollinger Bands
        cmf20 <- CMF(HLC(curData),Vo(curData),n=20); names(cmf20) <- "cmf20" #Chaikin Money Flow
        cmo14 <- CMO(Cl(curData),n=14); names(cmo14) <- "cmo14" # Chande Momentum Oscillator
        ema20 <- EMA(Cl(curData),n=20,wilder = FALSE); names(ema20) <- "ema20" # Exponential moving average
        vwma20 <- VWMA(Cl(curData),Vo(curData),n=20); names(vwma20) <- "vwma20" # Volume-weighed moving average
        macd12269 <- MACD(Cl(curData), nFast = 12, nSlow = 26, nSig = 9, maType="EMA", percent = TRUE) # MACD
        rsi14 <- RSI(Cl(curData),n=14,maType="SMA"); names(rsi14) <- "rsi14" # RSI
        stoch1433 <- stoch(HLC(curData), nFastK = 14, nFastD = 3, nSlowD = 3) # Stochastic oscillator-overbought(oversold) if >80 (<20)
        wpr14 <- WPR(HLC(curData), n = 14); names(wpr14) <- "wpr14" # William's %R - overbought(oversold) if <20 (>80)
        
        # add all indicators columns to original price data
        indicators <- merge(curData, 
                            dayret,
                            weekret,
                            monthret,
                            atr14,
                            bbands202,
                            cmf20,
                            cmo14,
                            ema20,
                            vwma20,
                            macd12269,
                            rsi14,
                            stoch1433,
                            wpr14
        )
        # replace original data
        assign(i,indicators,envir=envmt)
}