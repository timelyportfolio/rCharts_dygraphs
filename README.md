## Installation

You can install `rCharts` from `github` using the `devtools` package

```coffee
require(devtools)
install_github("rCharts","timelyportfolio",ref="dimple_layer") # use this specific branch with temp fix
install_github('rCharts_dygraphs', 'danielkrizian')
```

## Example 

```coffee
library(rChartsDygraph); library(quantmod)
getSymbols("SPY", from = "1993-01-01")
SPY <- data.frame(Date=index(SPY), Price=SPY$SPY.Close)
SPY$Momentum20days <- momentum(SPY$SPY.Close, 20)/lag(SPY$SPY.Close, 20)*100

dygraph1 <- dygraph(data=SPY[,c("Date","SPY.Close")], sync=TRUE, crosshair="vertical", legendFollow=TRUE, width=1000)
dygraph2 <- dygraph(data=SPY[,c("Date","Momentum20days")], sync=TRUE, crosshair="vertical", legendFollow=TRUE, width=1000, colors='grey')

layout_dygraphs(dygraph1, dygraph2)
```

This should produce [two charts like here (link)](http://rawgit.com/danielkrizian/rCharts_dygraphs/master/examples/multi-layout.html)

Zoom: mouse left-click & drag; Pan: Shift + mouse left-click & drag

<iframe src="http://rawgit.com/danielkrizian/rCharts_dygraphs/master/examples/multi-layout.html" style="width: 1200px; height: 900px;"/iframe>

