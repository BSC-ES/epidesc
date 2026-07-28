test_that("Cnf works", {
  testnum <- c(1, 3, 5, 4, 7, 3, 8, 9, 7, 1, 4, 7, 9, 12, 10, 4, 10, 1)
  testdf <- data.frame(cases = testnum)
  expect_equal(desc_Cnf(testdf, n = 3, x = 7), 2)
  expect_equal(desc_Cnf(testdf, n = 1, x = 0), 1)
  expect_equal(desc_Cnf(testdf, n = 3, x = 10), 0)
})

test_that("Cmax works", {
  testnum <- c(1, 3, 5, 4, 7, 3, 8, 9, 7, 1, 4, 7, 9, 12, 10, 4, 10, 1)
  testdf <- data.frame(cases = testnum)
  expect_equal(desc_Cmax(testdf, 10), 2)
  expect_equal(desc_Cmax(testdf, 12), 1)
  expect_identical(desc_Cmax(testdf, 1), length(testnum))
  expect_identical(desc_Cmax(testdf, 100), 0)
})

test_that("Cmed works", {
  testnum <- c(1, 3, 5, 4, 7, 3, 8, 9, 7, 1, 4, 7, 9, 12, 10, 4, 10, 1)
  testdf <- data.frame(cases = testnum)
  expect_equal(desc_Cmed(testdf, 7), 2)
  expect_equal(desc_Cmed(testdf, 4), 3)
  expect_identical(desc_Cmed(testdf, 1), length(testnum))
  expect_identical(desc_Cmed(testdf, 100), 0)
})

test_that("Isof works", {
  expect_equal(desc_Isof(data.frame(cases = c(0, 1, 0))), 1)
  expect_equal(desc_Isof(data.frame(cases = c(1, 0, 0))), 1)
  expect_equal(desc_Isof(data.frame(cases = c(0, 0, 1))), 1)
  expect_equal(desc_Isof(data.frame(cases = c(4, 1, 6))), 0)
})

test_that("p works", {
  expect_equal(desc_p(data.frame(cases = c(5, 8, 7)), 7), 2 / 3)
  expect_equal(desc_p(data.frame(cases = c(1, 2, 3, 4)), 4), 0.25)
  expect_equal(desc_p(data.frame(cases = c(1, 2, 3)), 1), 1)
})
