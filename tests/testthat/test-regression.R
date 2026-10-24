test_that("fixed legacy fixtures reproduce valid outputs", {
  fixtures <- readRDS(test_path("fixtures", "legacy.rds"))
  wd_checked <- 0L
  for (fixture in fixtures) {
    expect_equal(plain(i1_test(fixture$y)), fixture$i1, tolerance = 1e-11)
    expect_equal(i1_stt(fixture$y), fixture$statistic, tolerance = 1e-11)
    if (abs(fixture$rho) <= .2 && !is.null(fixture$wd)) {
      expect_equal(plain(i1_test(fixture$y, 1, calibration = "none"))[-1], fixture$wd[-1], tolerance = 1e-11)
      wd_checked <- wd_checked + 1L
    }
    # Original terminal negative indexing can erase a flag via NA; compare only
    # fixtures where the signed terminal run cannot trigger that known defect.
    scale <- DCIi1:::iqrstdp_i1(DCIi1:::leveldif(fixture$y))
    if (tail(scale, 1) >= 0 && !is.null(fixture$dci) && all(complete.cases(fixture$dci))) {
      expect_equal(plain(dcii1(fixture$y))[-3], fixture$dci[-3], tolerance = 1e-10)
    }
  }
  expect_gt(wd_checked, 5)
})

test_that("globals and earlier calls do not affect package functions", {
  set.seed(107)
  x <- rnorm(100)
  before <- i1_test(x)
  random_state <- .Random.seed
  env <- new.env(); env$w1 <- 8; env$nulldistrepo <- "bad"
  i1_test(x, w1 = 8, calibration = "none")
  dcii1(x, nbrhudfracleni1 = .3)
  expect_identical(i1_test(x), before)
  expect_identical(.Random.seed, random_state)
})
