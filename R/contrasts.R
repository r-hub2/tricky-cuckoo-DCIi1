# Equation (24), with centering before cumulative sums to reduce cancellation.
leveldif <- function(its, w1 = 22) {
  n <- length(its)
  w <- round(w1 / 2)
  x <- its - mean(its)
  cs <- c(0, cumsum(x))
  t <- seq_len(n - 1L)
  left <- pmax(1, t - w + 1)
  right <- pmin(n, t + w)
  ans <- (cs[right + 1L] - cs[t + 1L]) / (right - t) -
    (cs[t + 1L] - cs[left]) / (t - left + 1L)
  if (any(!is.finite(ans))) stop("Non-finite contrasts: rescale y.", call. = FALSE)
  ans
}

.aggregate <- function(d, n, w) {
  locations <- seq.int(w, n - w)
  # The legacy aggregate is a sequential sum. Direct sums preserve tied peaks
  # and avoid subtracting large cumulative sums for this short filter.
  values <- vapply(locations, function(t) sum(d[seq.int(t - w + 1, t + w - 1)]),
                   numeric(1))
  list(locations = locations, values = values)
}
