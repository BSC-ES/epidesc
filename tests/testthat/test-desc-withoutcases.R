test_that("Cwf works", {
  testnum <- c(1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1)
  testdf <- data.frame(cases = testnum)
  expect_equal(desc_Cwf(testdf, 1), 4)
  expect_equal(desc_Cwf(testdf, 2), 3)
  expect_equal(desc_Cwf(testdf, 4), 1)
})

test_that("Cwmax works", {
  testnum <- c(1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1)
  testdf <- data.frame(cases = testnum)
  expect_equal(desc_Cwmax(testdf), 4)
  expect_equal(desc_Cwmax(data.frame(cases = rep(1, 4))), 0)
})

test_that("Cwmed works", {
  testnum <- c(1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1)
  testdf <- data.frame(cases = testnum)
  expect_equal(desc_Cwmed(testdf), 2.5)
  expect_equal(desc_Cwmed(data.frame(cases = rep(1, 4))), 0)
})
