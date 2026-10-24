flagwtg <- function(ipts, ctof = 0, method = "legacy") {
  n <- length(ipts)
  out <- numeric(n)
  if (!n) return(out)
  signs <- as.numeric(ipts > ctof) - as.numeric(ipts < -ctof)
  excess <- pmax(ipts - ctof, 0) + pmin(ipts + ctof, 0)
  groups <- rle(signs)
  ends <- cumsum(groups$lengths)
  starts <- ends - groups$lengths + 1L
  if (method == "runs") {
    for (j in which(groups$values != 0)) {
      # The paper does not specify how to round a noninteger centroid.
      at <- round((starts[j] + ends[j]) / 2)
      out[at] <- sum(excess[seq.int(starts[j], ends[j])])
    }
    return(out)
  }
  # Reference compatibility: retain only local maxima of absolute run counters.
  # This deliberately retains suppression of singleton/interfacing runs.
  counter <- numeric(n)
  for (j in which(groups$values != 0)) {
    counter[seq.int(starts[j], ends[j])] <- seq_len(groups$lengths[j])
  }
  candidates <- if (n >= 3L) which(counter[2:(n - 1L)] > counter[1:(n - 2L)] &
    counter[2:(n - 1L)] > counter[3:n]) + 1L else integer()
  if (n >= 2L && counter[n] > counter[n - 1L]) candidates <- c(candidates, n)
  for (end in candidates) {
    size <- counter[end]
    out[end - round(size / 2)] <- sum(excess[seq.int(end - size + 1L, end)])
  }
  out
}

.prune_flags <- function(weights, w1) {
  repeat {
    flags <- which(weights != 0)
    if (!length(flags)) break
    gaps <- diff(c(0, flags, length(weights)))
    bad <- which(head(gaps, -1L) + tail(gaps, -1L) < w1)
    if (!length(bad)) break
    weights[flags[bad[1L]]] <- 0
  }
  weights
}
