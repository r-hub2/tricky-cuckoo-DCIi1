test_that("DCI never reports segment p-values even at length 100", {
  for (n in c(100, 200, 500)) {
    set.seed(n)
    x <- rnorm(n) + rep(c(0, 3), each = n / 2)
    a <- dcii1(x)
    expect_gt(nrow(a), 0)
    expect_true(all(is.na(a$pvalue)))
    expect_true(all(is.finite(a$istatistic)))
    expect_identical(attr(a, "settings")$inference, "candidate locations only")
    expect_equal(change_points(a), sort(unique(a$etavec)))
    expect_error(dcii1(x, calibration = "reference"), "unused argument")
  }
  set.seed(91)
  x <- rnorm(100)
  expect_true(all(is.na(dcii1(x, w1 = 16, flag_method = "runs")$pvalue)))
  expect_length(change_points(dcii1(x, r1 = 1e20)), 0)
})
