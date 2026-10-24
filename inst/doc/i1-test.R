## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(DCIi1)

## -----------------------------------------------------------------------------
set.seed(12)
y <- rnorm(100) + rep(c(0, 3), each=50)
fit <- i1_test(y)
fit
diagnostics <- attr(fit, "diagnostics")
diagnostics
fit$cpmag * diagnostics$sigma

## -----------------------------------------------------------------------------
i1_test(y, archeck=1, calibration="none")
i1_test(y, w1=16, calibration="none")
set.seed(13)
long_series <- rnorm(300)
i1_stt(long_series)
i1_test(long_series, calibration="none")

