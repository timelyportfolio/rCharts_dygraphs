library(rChartsDygraph); library(quantmod)
getSymbols("SPY", from = "1993-01-01")
SPY <- data.frame(Date=index(SPY), Price=SPY$SPY.Close)
SPY$Momentum20days <- momentum(SPY$SPY.Close, 20)/lag(SPY$SPY.Close, 20)*100

dygraph1 <- dygraph(data=SPY[,c("Date","SPY.Close")], sync=TRUE, crosshair="vertical", legendFollow=TRUE, width=1000)
dygraph2 <- dygraph(data=SPY[,c("Date","Momentum20days")], sync=TRUE, crosshair="vertical", legendFollow=TRUE, width=1000, colors='grey')

layout_dygraphs(dygraph1, dygraph2)
