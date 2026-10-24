.standardize <- function(y, archeck) {
  dy <- diff(y)
  sigma <- stats::IQR(dy) / (-2 * sqrt(2) * stats::qnorm(0.25))
  if (!is.finite(sigma) || sigma <= 0) {
    stop("The IQR of first differences must be positive and finite; ",
         "constant, noiseless or degenerate series cannot be calibrated.", call. = FALSE)
  }
  rho <- 0
  if (archeck == 1) {
    rho <- 1 + 2 * stats::cor(dy[-length(dy)], dy[-1L])
    if (!is.finite(rho) || abs(rho) >= 1) {
      stop("Estimated dependence must be finite and strictly between -1 and 1.",
           call. = FALSE)
    }
    sigma <- sigma / (1 - rho)
  }
  z <- (y - mean(y)) / sigma
  if (!is.finite(sigma) || sigma <= 0 || any(!is.finite(z))) {
    stop("Non-finite standardization: rescale y.", call. = FALSE)
  }
  list(y = z, sigma = sigma, rho = rho)
}
