.segments <- function(Tl, cps) {
  if (!is.numeric(cps) || is.complex(cps) || any(!is.finite(cps)) ||
      any(cps != floor(cps)) || any(cps < 1 | cps >= Tl)) {
    stop("Change points must be finite integers between 1 and Tl - 1.", call. = FALSE)
  }
  boundaries <- c(0, sort(unique(cps)), Tl)
  cbind(start = head(boundaries, -1L) + 1, end = tail(boundaries, -1L))
}

.covering <- function(Tl, actual_cps, est_cps, weighted) {
  .scalar(Tl, "Tl", 1, integer = TRUE)
  actual <- .segments(Tl, actual_cps)
  estimated <- .segments(Tl, est_cps)
  size <- actual[, 2L] - actual[, 1L] + 1
  other_size <- estimated[, 2L] - estimated[, 1L] + 1
  best <- vapply(seq_len(nrow(actual)), function(i) {
    intersection <- pmax(0, pmin(actual[i, 2L], estimated[, 2L]) -
      pmax(actual[i, 1L], estimated[, 1L]) + 1)
    max(intersection / (size[i] + other_size - intersection))
  }, numeric(1))
  if (weighted) sum(size * best) / Tl else mean(best)
}

covering_metric <- function(Tl, actual_cps, est_cps) {
  .covering(Tl, actual_cps, est_cps, TRUE)
}

covering_metric_unwtd <- function(Tl, actual_cps, est_cps) {
  .covering(Tl, actual_cps, est_cps, FALSE)
}
