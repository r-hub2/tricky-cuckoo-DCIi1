# DCIi1

I1 mean-change testing and descriptive DCI candidate detection, based on
Waychal, Laha and Sinha (2026), [arXiv:2610.23476](https://doi.org/10.48550/arXiv.2610.23476).

## Installation

```r
install.packages("DCIi1_0.2.0.tar.gz", repos = NULL, type = "source")
library(DCIi1)
```

## I1 test

Reference p-values require **100 observations, w1=22 and independent Gaussian
noise**. The input checks enforce length, window and mode; the user assesses
the noise assumption. Mean-shift alternatives are allowed.

```r
set.seed(12)
y <- rnorm(100) + rep(c(0, 3), each = 50)
result <- i1_test(y)
result
attr(result, "diagnostics")
```

The calibration is an empirical density approximation. In 10000 independent
Gaussian null validation series, rejection rates were 0.86%, 4.15% and 8.57%
at nominal levels 1%, 5% and 10%. This is finite-sample evidence, not a claim
of exact size or validity under other distributions.

For other lengths, windows or WD scaling, use statistic-only analysis:

```r
set.seed(13)
long_series <- rnorm(300)
i1_test(long_series, calibration = "none")  # pvalue is NA
i1_stt(long_series)
i1_test(y, archeck = 1, calibration = "none")
```

## DCI candidate locations

DCI flags and refines candidate mean changes. It does not assign p-values to
data-selected segments or label candidates statistically significant.

```r
set.seed(21)
y_multi <- rnorm(160) + rep(c(0, 4, -3, 1), c(50, 15, 15, 80))
candidates <- dcii1(y_multi)
locations <- change_points(candidates)
plot(y_multi, type = "l", xlab = "Observation", ylab = "Value")
abline(v = locations, col = "firebrick", lty = 2)
covering_metric_unwtd(160, c(50, 65, 80), locations)
```

All DCI pvalue entries are NA. Candidate locations can occur under a constant
mean. `change_points()` sorts and deduplicates candidates without testing them.
Locations are the last observation before a boundary. Magnitudes are signed
standardized contrasts, not original-unit shifts. For I1, multiply cpmag by
the diagnostics sigma to recover data units.

## Practical scope

* Numeric finite univariate data; no implicit missing-value deletion.
* Default full window 22 means up to 11 observations on each side.
* The WD denominator is -2 * sqrt(2) * (1-rho) * qnorm(.25), as in Appendix B.1.
* Zero IQR, undefined WD estimates and unsupported inferential settings error explicitly.
* No asymptotic p-values, multiplicity adjustment, or general variance-change test.
* No external data downloads, workspace loading or compiled code are needed.

See `?i1_test`, `?dcii1`, `vignette("i1-test", package="DCIi1")` and
`vignette("dci-algorithm", package="DCIi1")`.

## Authors and licence

Nachiketas Waychal, Arnab Kumar Laha and Ankur Sinha are the software authors
and copyright holders. Maintainer: Nachiketas Waychal
<nachiketas.waychal@yahoo.com>. Distributed under GPL-3.
Affiliations, attribution and AI-assisted development acknowledgement are in
`inst/NOTICE`. Cite the method with `citation("DCIi1")`.
