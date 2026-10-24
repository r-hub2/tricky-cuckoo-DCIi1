test_that("deterministic ties, boundary shifts and short series remain defined", {
  fixtures <- list(rep(c(-1, 1), 50), rep(c(-2, 0, 1, 2), 25))
  for (x in fixtures) {
    expected <- direct_i1(x)
    actual <- i1_test(x)
    expect_equal(actual$i1, round(expected[[1]], 4))
    expect_equal(actual$etahat, expected[[2]])
  }
  set.seed(109)
  for (position in c(1, 3, 11, 89, 97, 99)) {
    x <- rnorm(100) + c(rep(0, position), rep(3, 100 - position))
    a <- i1_test(x)
    expect_true(a$etahat >= 11 && a$etahat <= 89)
    expect_equal(a$i1, round(direct_i1(x)[[1]], 4))
  }
  expect_equal(i1_test(c(0, 1, 0, 2), w1 = 4, calibration = "none")$etahat, 2)
  expect_error(i1_test(rnorm(100), w1 = 1 + 1i), "w1")
  expect_error(i1_test(rnorm(100), calibration = c("none", "reference")), "length 1")
})

test_that("fixed small simulations distinguish a strong shift from null noise", {
  set.seed(110)
  B <- 60L
  null <- shifted <- logical(B)
  for (i in seq_len(B)) {
    x <- rnorm(100)
    null[i] <- i1_test(x)$pvalue <= .1
    shifted[i] <- i1_test(x + rep(c(0, 3), each = 50))$pvalue <= .1
  }
  # Monte Carlo confidence bounds, not a claim of nominal null calibration.
  expect_gt(binom.test(sum(shifted), B)$conf.int[1], .8)
  expect_lt(binom.test(sum(null), B)$conf.int[2], .4)
  expect_gt(sum(shifted), sum(null))
})

test_that("calibration does not silently clamp unsupported WD inputs", {
  set.seed(111)
  x <- as.numeric(arima.sim(list(ar = .8), 300))
  rho <- 1 + 2 * cor(diff(x)[-299], diff(x)[-1])
  expect_gt(rho, .2)
  expect_error(i1_test(x, 1), "restricted")
  expect_true(is.finite(i1_test(x, 1, calibration = "none")$i1))
  expect_error(dcii1(x, i1ar = 1), "Cannot evaluate flag.*dependence")
})
