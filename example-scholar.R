# Fama from Google Scholar
# http://scholar.google.com/citations?user=yP7euFUAAAAJ&hl=en

library(scholar)
famaId = "yP7euFUAAAAJ"
fama.df <- compare_scholar_careers(famaId)

#you will need this branch of rCharts
#require(devtools)
#install_github("rCharts","timelyportfolio",ref="dimple_layer")
library(rCharts)

fama.df$date <- paste0(
  "#!new Date(",
  as.numeric(as.POSIXct(paste0(fama.df$year,"-12-31"))) * 1000,
  ")!#"
)

dy1 <- rCharts$new()
dy1$setLib( "." )
dy1$templates$script = "layouts/chart2.html"
dy1$set(
  data = fama.df[,c("date","cites")],
  chart = list(
    labels=c("date","cites"),
    title = "Eugene Fama - Career in Citations from Google Scholar",
    ylabel = "Citations",
    verticalCrosshair=TRUE,
    legendFollow=TRUE,
    #showRangeSelector = TRUE,
    labelsDivStyles= list(
      background = 'none'
    ),
    strokeWidth = 1.5
  )
)
dy1$setTemplate(afterScript = "<script></script>")
dy1$html( chartId = "dygraphScholar" )
dy1$show(cdn = TRUE)
