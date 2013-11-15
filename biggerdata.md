---
title: Dygraphs with Bigger Data | rCharts + dygraphs
author: TimelyPortfolio
github: {user: timelyportfolio, repo: rCharts_dygraphs, branch: "gh-pages"}
framework: bootstrap
mode: selfcontained
highlighter: prettify
hitheme: twitter-bootstrap
assets:
  css:
  - "http://fonts.googleapis.com/css?family=Raleway:300"
  - "http://fonts.googleapis.com/css?family=Oxygen"
  jshead:
  - "./lodash.js"
  - "./dygraph-combined.js"
--- 

<!-- thanks http://stackoverflow.com/questions/17836686/highlight-closest-series-but-only-show-x-y-of-highlighted-series -->
<style>
  #status > span { display: none; }
  #status > span.highlight { display: inline; }
  
.container{width:950px;}

body{
  font-family: 'Oxygen', sans-serif;
  font-size: 16px;
  line-height: 24px;
}

h1,h2,h3,h4 {
font-family: 'Raleway', sans-serif;
}

h3 {
background-color: #D4DAEC;
  text-indent: 100px; 
}

h4 {
text-indent: 100px;
}
</style>


# Dygraphs With Bigger but Not Quite Big Data

How big is big?  I'm not sure.  Sometimes with "big" data d3/svg gets sluggish.  An older robust canvas-based HTML5 library [`dygraphs`](http://dygraphs.com) claims,

<blockquote>
Handles huge data sets: dygraphs plots millions of points without getting bogged down.
</blockquote>

Let's test it with some "almost big" data in the form of US Industry daily return data since 1926 from the [Kenneth French data library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html).  This is 23,027 rows and 48 columns for 1,105,296 tuples.

Also, you should see the nice closest series highlighting functionality of `dygraphs`.

---



<div class = 'row'>
  <div id = "dygraphIndustry" class = 'span8' style = 'height:300px;'>
  </div>
  <div id="status" class = 'span4'>
  </div>  
</div>
<div class = 'row'>
  <div class = 'span8 offset2'>
    <small class="text-info">click/drag to zoom; shift+click/drag to pan; double-click to unzoom</small>
  </div>
</div>
<br>

### Get the Data

```r
library(rCharts)
# get very helpful Ken French data for this project we will look at Industry
# Portfolios
# http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/48_Industry_Portfolios_daily.zip

require(quantmod)
```



```r
# my.url will be the location of the zip file with the data
my.url = "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/48_Industry_Portfolios_daily.zip"
# this will be the temp file set up for the zip file
my.tempfile <- paste(tempdir(), "\\frenchindustry.zip", sep = "")
# my.usefile is the name of the txt file with the data
my.usefile <- paste(tempdir(), "\\48_Industry_Portfolios_daily.txt", sep = "")
download.file(my.url, my.tempfile, method = "auto", quiet = FALSE, mode = "wb", 
    cacheOK = TRUE)
unzip(my.tempfile, exdir = tempdir(), junkpath = TRUE)
# read space delimited text file extracted from zip
french_industry <- read.table(file = my.usefile, header = TRUE, sep = "", as.is = TRUE, 
    skip = 9, nrows = 23027)

# get dates ready for xts index
datestoformat <- rownames(french_industry)
datestoformat <- paste(substr(datestoformat, 1, 4), substr(datestoformat, 5, 
    6), substr(datestoformat, 7, 8), sep = "-")

# get xts for analysis
french_industry_xts <- as.xts(french_industry[, 1:NCOL(french_industry)], order.by = as.Date(datestoformat))

# divide by 100 to get percent
french_industry_xts <- french_industry_xts/100

# delete missing data which is denoted by -0.9999
french_industry_xts[which(french_industry_xts < -0.99, arr.ind = TRUE)[, 1], 
    unique(which(french_industry_xts < -0.99, arr.ind = TRUE)[, 2])] <- 0

# get price series or cumulative growth of 1
french_industry_price <- log(cumprod(french_industry_xts + 1))
```


### Write the Data To Demonstrate Data from url

```r
# write to a csv that we will read with dygraphs url
write.csv(data.frame(french_industry_price), "french_industry.csv", quote = F)
```


### rCharts Magic

```r
dy1 <- rCharts$new()
dy1$setLib(".")
dy1$templates$script = "chart_csv.html"
dy1$set(data = "./french_industry.csv", chart = list(title = "US Industries Since 1926 | source: Kenneth French", 
    ylabel = "Cumulative Return (log)", labelsDiv = "#!document.getElementById('status')!#", 
    labelsDivStyles = list(background = "none"), strokeWidth = 0.75, showLabelsOnHighlight = TRUE, 
    highlightCircleSize = 2, highlightSeriesOpts = list(strokeWidth = 1, highlightCircleSize = 5), 
    width = 550))
cat(noquote(dy1$html(chartId = "dygraphIndustry")))
```

<script>
  (function(){
    var params = {
 "dom": "dygraphIndustry",
"width":    800,
"height":    400,
"data": "./french_industry.csv",
"chart": {
 "title": "US Industries Since 1926 | source: Kenneth French",
"ylabel": "Cumulative Return (log)",
"labelsDiv": document.getElementById('status'),
"labelsDivStyles": {
 "background": "none" 
},
"strokeWidth":   0.75,
"showLabelsOnHighlight": true,
"highlightCircleSize":      2,
"highlightSeriesOpts": {
 "strokeWidth":      1,
"highlightCircleSize":      5 
},
"width":    550 
},
"id": "dygraphIndustry" 
};
    //var data = _.unzip([params.data[params.x],params.data[params.y]]);
    //params.chart.labels = [params.x,params.y];
    new Dygraph(
      document.getElementById( 'dygraphIndustry' ),
      params.data,
      params.chart
    );
  })();
</script>


---
### Thanks
- [Ramnath Vaidyanathan](http://twitter.com/ramnath_vaidya)
- Dan, Alistair, Robert, and Klaus - dygraphs contributors
- [Kenneth French](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html) for the data
