
TO DO LIST:

1. Download daily OHLC data - 
        19 symbols, since 2007. addTechIndicators.R DONE
        Get more symbols
                Nasdaq (DONE Nasdaq 100)
                SP, AMEX, by marketcap...
2. Add technical indicators - DONE
        addTechIndicators.R (calls finFuncs.R)  
        Outputs: largeCap2007TechInd, nasdaq100_2007TechInd  (R objects)
                sp500 TBD
3. Verify data - Done
        verified plots vs. Yahoo

Analysis
        Probably should omit initial NA's in all indicators
        Analysis of ideas. correlations, cross correlations, periodicity
                ccf(x, y, lag.max = NULL, type = c("correlation", "covariance"),
                        plot = TRUE, na.action = na.fail, ...)
        Correlate daily.returns
                
        
Backtesting
        a. custom/additional indicators (getFinancials())
                IBrokers data?
                Macroeconomics
                Indexes, Forex, 
        b. Use/Not Use "lag" - implementation implications
                Need to use lag if assuming Buy at Close price.
                        Close(n) generates indicators(n). Buy(Close(n)) generates Returns(n+1)
        c. exit strategy, ex. length of time, another indicator...

        Backtest on EOD close data
        long/short ideas:
              bolinger bands, i.e. SMA +/- xSDDEVs
              bolinger bands vs. market, industry, sector
              RSI
              trends: EMA, SMA
              volatility, volume
              Gap/OHLC
              USD/EUR
              other indexes USA & foreign
        
        Backtest on FinViz database
         ideas:
                analyst recomm, change
                earnings results (changes in forecast EPS)
                P/B, valuation


Performance Analysis
        cumulative returns, annualized returns, drawdown,
        benchmark against SPY, ActiveReturn(), 


Implementation
        a. Pull new price data (EOD, intraday?)
        b. update all indicators (only need to update new data, is this possible?)
        c. Use strategy, get new triggers




> a<-c(0,0,0,0,1,1,1,1,0,0,0,0)
> filter(a,c(1,-1))
Time Series:
Start = 1 
End = 12 
Frequency = 1 
 [1]  0  0  0  1  0  0  0 -1  0  0  0 NA
> diff(a)
 [1]  0  0  0  1  0  0  0 -1  0  0  0