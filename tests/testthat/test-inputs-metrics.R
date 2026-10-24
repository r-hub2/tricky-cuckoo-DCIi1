test_that("invalid and degenerate inputs fail deliberately", {
  for (x in list(NULL, numeric(), 1, 1:3, letters, list(1:100),
                 matrix(1:100, 10), c(NA, rep(1, 99)), c(NaN, rep(1, 99)),
                 c(Inf, rep(1, 99)), rep(1 + 1i, 100))) {
    expect_error(i1_test(x), "numeric vector")
    expect_error(dcii1(x), "numeric vector")
  }
  expect_error(i1_test(rep(1, 100)), "IQR")
  expect_error(dcii1(1:100), "IQR")
  set.seed(108); x <- rnorm(100)
  for (w in list(0, -1, 2.5, Inf, NA, 102, "22")) expect_error(i1_test(x, w1 = w), "w1")
  expect_error(i1_test(x[1:23], w1 = 23), "2 \\*")
  for (v in list(-1, 2, NA, Inf, c(0, 1))) expect_error(i1_test(x, archeck = v), "archeck")
  expect_error(dcii1(x, r1 = -1), "r1")
  expect_error(dcii1(x, il_cutoff = -1), "il_cutoff")
  expect_error(dcii1(x, nbrhudfracleni1 = 2), "nbrhudfracleni1")
  expect_error(dcii1(x, nbrhudfracleni1 = 0), "scaling width")
  expect_error(dcii1(x, alpha = 1), "unused argument")
  expect_error(change_points(data.frame(Flag = 2, etavec = Inf)), "finite numeric")
  expect_true(is.finite(i1_stt(x * 1e-100)))
  expect_equal(i1_stt(x * 1e-100), i1_stt(x), tolerance = 1e-10)
  expect_error(i1_test((1:100)^2, archeck = 1, calibration = "none"), "dependence")
})

test_that("covering metrics agree with set-based definitions and handle duplicates", {
  direct <- function(n, a, b, weighted) {
    segments <- function(cp) {
      z <- c(0, sort(unique(cp)), n)
      lapply(seq_len(length(z) - 1), function(i) seq.int(z[i] + 1, z[i + 1]))
    }
    aa <- segments(a); bb <- segments(b)
    scores <- sapply(aa, function(x) max(sapply(bb, function(y)
      length(intersect(x, y)) / length(union(x, y)))))
    if (weighted) sum(lengths(aa) * scores) / n else mean(scores)
  }
  for (a in list(numeric(), c(10, 20), c(20, 10, 10))) {
    for (b in list(numeric(), c(15, 28), 1:29)) {
      expect_equal(covering_metric(30, a, b), direct(30, a, b, TRUE))
      expect_equal(covering_metric_unwtd(30, a, b), direct(30, a, b, FALSE))
    }
  }
  expect_equal(covering_metric(1, numeric(), numeric()), 1)
  expect_error(covering_metric(0, numeric(), numeric()), "Tl")
  for (cp in list(0, 30, NA, Inf, 2.5, "3")) expect_error(covering_metric(30, cp, numeric()), "Change points")
})
