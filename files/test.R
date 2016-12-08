library(zoo)
library(bfast)
library(strucchange)
NDVIa <- as.ts(zoo(som$NDVI.a, som$Time))


# Results of the following functions will be automatically checked for equality using different package versions. Please make sure that the output has
# a simple type that can be compared with isTRUE(all.equal()).

bfastmonitor.hist.roc <- function() {
  x = bfastmonitor(NDVIa, start = c(2010, 13),history = "ROC", type="OLS-MOSUM",formula = response ~ trend + harmon,order=3,lag = NULL, slag = NULL)
  list(x$monitor,
       x$history,
       x$breakpoint,
       x$magnitude)
}

# history = BP
bfastmonitor.hist.bp <- function() {
  x = bfastmonitor(NDVIa, start = c(2010, 13),history = "BP", type="OLS-MOSUM",formula = response ~ trend + harmon,order=3,lag = NULL, slag = NULL)
  list(x$monitor,
       x$history,
       x$breakpoint,
       x$magnitude)
}

# history = all
bfastmonitor.hist.all <- function() {
  x = bfastmonitor(NDVIa, start = c(2010, 13),history = "all", type="OLS-MOSUM",formula = response ~ trend + harmon,order=3,lag = NULL, slag = NULL)
  list(x$monitor,
       x$history,
       x$breakpoint,
       x$magnitude)
}


modis.raster <- system.file("extdata/modisraster.grd", package="bfast")
require("raster")
modisbrick <- brick(modis.raster)

# from bfastmonitor examples 
bfastmonitor.modis <- function() {
  ## helper function to be used with the calc() function
  xbfastmonitor <- function(x,dates) {
    ndvi <- bfastts(x, dates, type = c("16-day"))
    ndvi <- window(ndvi,end=c(2011,14))/10000
    ## delete end of the time to obtain a dataset similar to RSE paper (Verbesselt et al.,2012)
    bfm <- bfastmonitor(data = ndvi, start=c(2010,12), history = c("ROC"))
    return(cbind(bfm$breakpoint, bfm$magnitude))
  }
  calc(modisbrick,function(x) {xbfastmonitor(x, dates)})
}



require(forecast)
rdist <- 10/length(harvest)


bfast.reccusum <- function() {
  bfast(harvest,h=rdist, type="Rec-CUSUM", season="harmonic", max.iter=1)
}

bfast.olscusum <- function() {
  bfast(harvest,h=rdist, type="OLS-CUSUM", season="harmonic", max.iter = 1)
}

bfast.olsmosum <- function() {
  bfast(harvest,h=rdist, type="OLS-MOSUM", season="harmonic", max.iter = 1)
}

bfast.recmosum <- function() {
  bfast(harvest,h=rdist, type="Rec-MOSUM", season="harmonic", max.iter = 1)
}

test.recresid <- function() {
  set.seed(1111)
  n <- 2000
  p <- 7
  X <- cbind(1,matrix(rnorm(n * p), n, p))
  y <- rnorm(n)
  
  recresid.default(x = X,y=y)
}



