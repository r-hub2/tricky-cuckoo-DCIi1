test_that("adaptive contrasts and symmetric aggregates match direct definitions", {
  set.seed(101)
  for (n in c(22, 37, 100)) {
    x <- rnorm(n)
    for (w in c(2, 5, 11)) {
      expect_equal(DCIi1:::leveldif(x, 2 * w), direct_contrasts(x, w), tolerance = 1e-12)
      expected <- direct_i1(x, w)
      actual <- i1_test(x, w1 = 2 * w, calibration = "none")
      expect_equal(actual$i1, round(expected[[1]], 4))
      expect_equal(actual$etahat, expected[[2]])
      expect_equal(actual$cpmag, expected[[3]], tolerance = 1e-12)
    }
  }
})

test_that("finite filter, variance and step response match equations (4)-(6)", {
  set.seed(102)
  for (w in c(2, 5, 11)) {
    f <- filter_coefficients(w)
    expect_equal(sum(f$c), 0, tolerance = 1e-14)
    expect_equal(sum(f$c^2), 4 * w / 3 + 2 / (3 * w), tolerance = 1e-13)
    x <- rnorm(120)
    d <- direct_contrasts(x, w)
    for (t in seq.int(2 * w - 1, 120 - 2 * w + 1)) {
      expect_equal(sum(f$c * x[t + f$r]), sum(d[(t - w + 1):(t + w - 1)]),
                   tolerance = 1e-12)
    }
    step <- c(rep(0, 60), rep(3, 60))
    d <- direct_contrasts(step, w)
    z <- sapply(seq.int(2 * w - 1, 120 - 2 * w + 1),
                function(t) sum(d[(t - w + 1):(t + w - 1)]))
    expect_equal(max(z), w * 3)
  }
})

test_that("normalization, direction and magnitude have explicit units", {
  set.seed(103)
  x <- rnorm(100) + rep(c(0, 3), each = 50)
  a <- i1_test(x)
  b <- i1_test(-x)
  expect_equal(a$i1, b$i1)
  expect_equal(a$etahat, b$etahat)
  expect_equal(a$cpmag, -b$cpmag)
  expect_equal(plain(i1_test(7 * x + 30)), plain(a), tolerance = 1e-11)
  sigma <- attr(a, "diagnostics")$sigma
  expect_equal(a$cpmag * sigma,
    mean(x[(a$etahat + 1):(a$etahat + 11)]) - mean(x[(a$etahat - 10):a$etahat]))
  expect_equal(i1_stt(x), direct_i1(x)[[1]], tolerance = 1e-12)
  rho <- 1 + 2 * cor(diff(x)[-99], diff(x)[-1])
  expected_scale <- IQR(diff(x)) / (-2 * sqrt(2) * (1 - rho) * qnorm(.25))
  expect_equal(DCIi1:::.standardize(x, 1)$sigma, expected_scale, tolerance = 1e-12)
  expect_equal(i1_stt(x, 1), direct_i1(x, rho = rho)[[1]], tolerance = 1e-12)
})

test_that("p-local scaling agrees with independent Hankel construction", {
  set.seed(104)
  x <- rnorm(79)
  for (fraction in c(.1, .35, 1)) {
    expect_equal(DCIi1:::iqrstdp_i1(x, fraction), direct_scaling(x, fraction), tolerance = 1e-13)
  }
  expect_error(DCIi1:::iqrstdp_i1(x, .001), "at least 2")
  expect_error(DCIi1:::iqrstdp_i1(rep(0, 30)), "local IQR")
})
