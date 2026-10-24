# Independent definitions: direct means and sums, not cumulative-sum code.
direct_contrasts <- function(x, w) {
  vapply(seq_len(length(x) - 1L), function(t) {
    mean(x[seq.int(t + 1L, min(length(x), t + w))]) -
      mean(x[seq.int(max(1L, t - w + 1L), t)])
  }, numeric(1))
}
direct_i1 <- function(x, w = 11, rho = 0) {
  s <- (quantile(diff(x), .75) - quantile(diff(x), .25)) /
    (2 * sqrt(2) * qnorm(.75)) / (1 - rho)
  z <- (x - mean(x)) / s
  d <- direct_contrasts(z, w)
  candidates <- seq.int(w, length(x) - w)
  a <- sapply(candidates, function(t) Reduce(`+`, d[(t - w + 1):(t + w - 1)]))
  loc <- candidates[which.max(abs(a))]
  c(statistic = unname(max(abs(a))), location = loc,
    magnitude = unname(mean(z[(loc + 1):(loc + w)]) - mean(z[(loc - w + 1):loc])))
}
filter_coefficients <- function(w) {
  r <- seq.int(-2 * w + 2, 2 * w - 1)
  c <- ifelse(r <= -w + 1, -(r + 2 * w - 1) / w,
    ifelse(r <= 0, (r - 1) / w, ifelse(r <= w, r / w, (2 * w - r) / w)))
  list(r = r, c = c)
}
direct_scaling <- function(x, fraction) {
  width <- round(length(x) * fraction)
  rows <- length(x) - width + 1
  estimates <- matrix(NA_real_, rows, length(x))
  for (i in seq_len(rows)) {
    at <- seq.int(i, i + width - 1L)
    q <- quantile(x[at], c(.25, .75))
    estimates[i, at] <- vapply(x[at], function(v) {
      if (v < q[1]) (v - q[1]) / diff(q) else
        if (v > q[2]) (v - q[2]) / diff(q) else 0
    }, numeric(1))
  }
  colMeans(estimates, na.rm = TRUE)
}
plain <- function(x) {
  attributes(x) <- attributes(x)[c("names", "row.names", "class")]
  x
}
