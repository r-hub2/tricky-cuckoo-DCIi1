dcii1 <- function(y, r1 = 0, nbrhudfracleni1 = 1, i1ar = 0,
                  w1 = 22, il_cutoff = 0,
                  flag_method = c("legacy", "runs")) {
  y <- .series(y, 4L)
  .window(w1, length(y))
  .mode(i1ar)
  .scalar(r1, "r1", 0)
  .scalar(il_cutoff, "il_cutoff", 0)
  .scalar(nbrhudfracleni1, "nbrhudfracleni1", 0, 1)
  flag_method <- match.arg(flag_method)
  .standardize(y, 0)
  scaled <- iqrstdp_i1(leveldif(y, w1), nbrhudfracleni1)
  weights <- flagwtg(scaled, il_cutoff, flag_method)
  weights[abs(weights) < r1] <- 0
  weights <- .prune_flags(weights, max(w1, 2 * round(w1 / 2)))
  flags <- which(weights != 0)
  n <- length(flags)
  ans <- data.frame(Flag = as.numeric(flags),
    Direction = as.character(ifelse(weights[flags] > 0, "+ve", "-ve")),
    pvalue = rep(NA_real_, n), istatistic = rep(NA_real_, n),
    etavec = rep(NA_real_, n), Magnitude = rep(NA_real_, n),
    stringsAsFactors = FALSE)
  boundaries <- c(0, flags, length(y))
  for (j in seq_len(n)) {
    interval <- seq.int(boundaries[j] + 1L, boundaries[j + 2L])
    fit <- tryCatch(i1_test(y[interval], i1ar, w1, calibration = "none"),
      error = function(e) stop("Cannot evaluate flag ", flags[j], ": ",
                               conditionMessage(e), call. = FALSE))
    ans$istatistic[j] <- fit$i1
    ans$etavec[j] <- boundaries[j] + fit$etahat
    ans$Magnitude[j] <- fit$cpmag
  }
  attr(ans, "settings") <- list(inference = "candidate locations only",
    flag_method = flag_method, w1 = w1, i1ar = i1ar,
    nbrhudfracleni1 = nbrhudfracleni1)
  ans
}

change_points <- function(x) {
  if (!is.data.frame(x) || !all(c("Flag", "etavec") %in% names(x)) ||
      !is.numeric(x$etavec) || any(!is.finite(x$etavec))) {
    stop("x must be a dcii1 result with finite numeric candidate locations.", call. = FALSE)
  }
  sort(unique(x$etavec))
}
