
TO DO LIST:
1. Download daily OHLC data - DONE
        19 symbols, since 2007. addTechIndicators.R
2. Add technical indicators - DONE
        addTechIndicators.R (calls finFuncs.R)  
        Outputs: largeCap2007TechInd, sp5yrsXTS (R objects)
3. Verify data - Done
        verified plots vs. Yahoo
        
Backtesting
        a. custom/additional indicators
        b. Use/Not Use "lag" - implementation implications
                Need to use lag if assuming Buy at Close price.
                        Close(n) generates indicators(n). Buy(Close(n)) generates Returns(n+1)

Performance Analysis
        cumulative returns, annualized returns, drawdown,
        benchmark against SPY, ActiveReturn(), 

Implementation
        a. Pull new price data (EOD, intraday?)
        b. update all indicators (only need to update new data, is this possible?)
        c. Use strategy, get new triggers
        