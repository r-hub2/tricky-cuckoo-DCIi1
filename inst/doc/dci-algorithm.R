## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(DCIi1)

## -----------------------------------------------------------------------------
set.seed(21)
y <- rnorm(160) + rep(c(0,4,-3,1), c(50,15,15,80))
candidates <- dcii1(y)
candidates
locations <- change_points(candidates)
locations
plot(y, type="l", xlab="Observation", ylab="Value")
abline(v=locations, col="firebrick", lty=2)

## -----------------------------------------------------------------------------
dcii1(y, nbrhudfracleni1=.5)
dcii1(y, flag_method="runs")

## -----------------------------------------------------------------------------
truth <- c(50,65,80)
covering_metric(length(y), truth, locations)
covering_metric_unwtd(length(y), truth, locations)

