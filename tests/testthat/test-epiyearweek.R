test_that("epiyearweek captures wrong inputs", {
  expect_error(epiyearweek("invalid"), "'date' must be a vector ")
  expect_error(
    epiyearweek(c(as.Date("2015-01-01"), NA)),
    "'date' cannot have "
  )
  expect_error(
    epiyearweek(as.Date("2015-01-01"), "Tuesday"),
    "'start' must be either"
  )
})

test_that("epiyearweek with different start days", {
  # 2015-01-01 is a Thursday so it should be week 1 if start day
  # is Monday and week 53 if Sunday
  expect_identical(epiyearweek(as.Date("2015-01-01")), "201453")
  expect_identical(epiyearweek(as.Date("2015-01-01"), start = "Monday"), "201501")
})

