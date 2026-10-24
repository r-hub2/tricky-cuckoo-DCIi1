test_that("calibration is intact and tail probabilities are bounded and monotone", {
  repo <- DCIi1:::nulldistrepo
  expect_equal(as.numeric(names(repo)), attr(repo, "rho_grid"))
  for (key in names(repo)) {
    d <- repo[[key]]
    expect_equal(nrow(d), 512L)
    expect_true(all(is.finite(as.matrix(d))))
    expect_true(all(diff(d$x) > 0))
    expect_true(all(d$y >= 0))
    expect_lt(abs(sum(d$y) * diff(d$x)[1] - 1), 1e-6)
    support <- c(-10, d$x, 100)
    p <- vapply(support, DCIi1:::.tail_probability, numeric(1), key = key)
    expect_true(all(p >= 0 & p <= 1))
    expect_true(all(diff(p) <= 0))
    expect_equal(tail(p, 1), 0)
    expect_equal(p[1], 1)
    # A density-grid rectangle and a trapezoid have bounded local quadrature difference.
    rect <- sum(d$y[d$x >= 8]) * diff(d$x)[1]
    ids <- which(d$x >= 8)
    trap <- sum(diff(d$x[ids]) * (head(d$y[ids], -1) + tail(d$y[ids], -1)) / 2)
    expect_lte(abs(rect - trap), diff(d$x)[1] * max(d$y))
  }
})

test_that("reference probabilities have an enforced inference domain", {
  set.seed(105)
  x <- rnorm(100)
  expect_identical(attr(i1_test(x), "diagnostics")$calibration_key, "0")
  for (n in c(22, 99, 101, 200, 500, 1000)) {
    z <- rep(x, length.out = n)
    expect_error(i1_test(z), "restricted")
    expect_true(is.na(i1_test(z, calibration = "none")$pvalue))
  }
  expect_error(i1_test(x, 1), "restricted")
  expect_error(i1_test(x, w1 = 20), "restricted")
  expect_error(i1_test(x, calibration = "legacy"), "arg")
  expect_true(is.na(i1_test(x, 1, calibration = "none")$pvalue))
  expect_true(is.na(i1_test(x, w1 = 20, calibration = "none")$pvalue))
  expect_equal(i1_test(x, 1, calibration = "none")$i1,
               round(i1_stt(x, 1), 4))
})
