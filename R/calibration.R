.tail_probability <- function(statistic, key = "0") {
  d <- nulldistrepo[[key]]
  # Original rectangular quadrature, with four-decimal reporting.
  p <- sum(d$y[d$x >= statistic]) * (d$x[2L] - d$x[1L])
  round(min(1, max(0, p)), 4)
}

.calibration <- function(calibration, w1, n, archeck) {
  calibration <- match.arg(calibration, c("reference", "none"))
  if (calibration == "reference" && (w1 != 22 || n != 100L || archeck != 0)) {
    stop("Reference p-values are restricted to length(y) = 100, w1 = 22 and ",
         "archeck = 0 under independent Gaussian noise. Use calibration = 'none' ",
         "for statistic-only analysis of other settings.", call. = FALSE)
  }
  calibration
}
