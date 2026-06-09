test_that("Ap works", {
  expect_equal(desc_Ap(data.frame(cases = c(4, 1, 6))), 6)
  expect_equal(desc_Ap(data.frame(cases = rep(0, 6))), 0)
})

test_that("Tp works", {
  testdf <- data.frame(
    cases = c(4, 1, 6, 8),
    epiweek = epiyearweek(seq(
      as.Date("2025-01-01"),
      by = "7 days",
      length.out = 4
    ))
  )
  expect_equal(desc_Tp(testdf), "202504")
})
