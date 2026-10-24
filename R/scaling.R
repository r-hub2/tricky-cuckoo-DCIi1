# Streaming accumulation of equations (25)-(26); no Hankel character matrix.
iqrstdp_i1 <- function(vi, nbrhudfracleni1 = 1) {
  n <- length(vi)
  width <- round(n * nbrhudfracleni1)
  if (width < 2L) stop("The local scaling width must be at least 2.", call. = FALSE)
  total <- numeric(n)
  count <- numeric(n)
  for (start in seq_len(n - width + 1L)) {
    at <- seq.int(start, start + width - 1L)
    x <- vi[at]
    q <- stats::quantile(x, c(0.25, 0.75), names = FALSE)
    spread <- q[2L] - q[1L]
    if (!is.finite(spread) || spread <= 0) {
      stop("Zero or non-finite local IQR in scaling window starting at ", start,
           "; p-local scaling is undefined.", call. = FALSE)
    }
    scaled <- (pmax(x - q[2L], 0) - pmax(q[1L] - x, 0)) / spread
    total[at] <- total[at] + scaled
    count[at] <- count[at] + 1
  }
  ans <- total / count
  if (any(!is.finite(ans))) stop("Non-finite p-local scaling: rescale y.", call. = FALSE)
  ans
}
