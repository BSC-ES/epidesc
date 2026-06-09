test_that("Inc works", {
  testdf <- data.frame(cases = rep(1, 5), pop = 10)
  expect_equal(desc_Inc(testdf, p = 1), 0.5)
  expect_equal(desc_Inc(testdf, p = 100), 50)
})
