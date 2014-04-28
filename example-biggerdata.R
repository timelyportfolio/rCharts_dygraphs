require(rCharts); require(quantmod); require(data.table)

d <- as.data.table(read.csv2(file="data/french_industry.csv",
                              header = TRUE, sep = ",",dec="."))

d[, Date:=paste0("#!new Date(",as.numeric(as.POSIXct(as.Date(d$Date, format="%d/%m/%Y"))) * 1000, ")!#")]


# another, slower way
# data = paste0("#!", toObj(toJSONArray(d[,c("Date","Rtail"), with=F], names = F)),"!#")

dy1 <- rCharts$new()
dy1$setLib( "." )
dy1$templates$script = "layouts/chart2.html"
dy1$set(
  dom = "dygraphRetail",
  data =  d, # d[,c("Date","Rtail", "Fin"), with=F],
  chart = list(
    labels= names(d), #c("Date","Rtail", "Fin"),
    title = "US Industries Since 1926 | source: Kenneth French",
    ylabel = "Cumulative Return (log)",
    legendFollow=TRUE,
    verticalCrosshair=TRUE,
    labelsDivStyles= list(
      background = 'none'
    ),
    strokeWidth = 0.75,
    showLabelsOnHighlight = TRUE,
    highlightCircleSize = 2,    
    highlightSeriesOpts = list(
      strokeWidth = 1,
      highlightCircleSize = 5
    ),
    width = 1000
  )
)
dy1$setTemplate(afterScript = "<script></script>")
# dy1$html( chartId = "dygraphRetail" )
dy1$show(cdn = TRUE)

# cat(noquote(dy1$html( chartId = "dygraphIndustry" )))
