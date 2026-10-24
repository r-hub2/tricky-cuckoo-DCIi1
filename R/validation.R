# All validation is local: no options, working-directory or global changes.
.scalar <- function(x, name, lower = -Inf, upper = Inf, integer = FALSE) {
  if (!is.numeric(x) || is.complex(x) || length(x) != 1L || is.na(x) || !is.finite(x) ||
      x < lower || x > upper || (integer && x != floor(x))) {
    stop(name, " must be a finite ", if (integer) "integer " else "number ",
         "in [", lower, ", ", upper, "].", call. = FALSE)
  }
  invisible(x)
}

.series <- function(y, minimum = 2L) {
  if (!is.numeric(y) || is.complex(y) || !is.null(dim(y)) ||
      length(y) < minimum || any(!is.finite(y))) {
    stop("y must be a finite numeric vector with at least ", minimum,
         " observations; missing values are not allowed.", call. = FALSE)
  }
  as.numeric(y)
}

.window <- function(w1, n) {
  .scalar(w1, "w1", 4, n, integer = TRUE)
  w <- round(w1 / 2)
  if (2 * w > n) stop("length(y) must be at least 2 * round(w1 / 2).",
                      call. = FALSE)
  w
}

.mode <- function(archeck) {
  .scalar(archeck, "archeck", 0, 1, integer = TRUE)
  invisible(archeck)
}
