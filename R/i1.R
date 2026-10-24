# Public documentation is maintained directly in man/; it is checked by R CMD check.
i1_test <- function(y, archeck = 0, w1 = 22, calibration = c("reference", "none")) {
  y <- .series(y, 4L)
  w <- .window(w1, length(y))
  .mode(archeck)
  calibration <- .calibration(calibration, w1, length(y), archeck)
  fit <- .i1_fit(y, archeck, w)
  key <- if (calibration == "reference") "0" else NA_character_
  p <- if (calibration == "reference") .tail_probability(fit$statistic, key) else NA_real_
  ans <- data.frame(pvalue = p, i1 = round(fit$statistic, 4),
                    etahat = as.numeric(fit$location), cpmag = fit$magnitude)
  attr(ans, "diagnostics") <- list(sigma = fit$sigma, rho = fit$rho,
    calibration = calibration, calibration_key = key, w1 = w1,
    statistic = fit$statistic,
    calibration_n = 100L, calibration_length_matches = length(y) == 100L,
    calibration_provenance = "supplied Gaussian reference density; n=100, w1=22",
    inference_scope = if (calibration == "reference") "iid Gaussian, n=100, w1=22" else "statistic only")
  ans
}

.i1_fit <- function(y, archeck, w) {
  s <- .standardize(y, archeck)
  a <- .aggregate(leveldif(s$y, 2 * w), length(y), w)
  index <- which.max(abs(a$values))
  location <- a$locations[index]
  magnitude <- mean(s$y[seq.int(location + 1, location + w)]) -
    mean(s$y[seq.int(location - w + 1, location)])
  list(statistic = abs(a$values[index]), location = location,
       magnitude = magnitude, sigma = s$sigma, rho = s$rho)
}

i1_stt <- function(y, archeck = 0, w1 = 22) {
  y <- .series(y, 4L)
  w <- .window(w1, length(y))
  .mode(archeck)
  .i1_fit(y, archeck, w)$statistic
}
