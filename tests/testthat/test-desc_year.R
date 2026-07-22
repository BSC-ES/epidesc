# Valid df for testing
dfval <- data.frame(
  spatialID = c(rep("A", 100), rep("B", 100)),
  epiyw = rep(seq(as.Date("2026-01-04"), by = "7 days", length.out = 100), 2),
  cases = rpois(200, 30),
  pop = rpois(200, 10000)
)
dfval$epiyw <- epiyearweek(dfval$epiyw)
descriptors <- list(
  "Ap" = list(fun = "Ap"),
  "Tp" = list(fun = "Tp"),
  "Cnf" = list(fun = "Cnf", n = 3, x = 5),
  "Cnf2" = list(fun = "Cnf", n = 6, x = 5),
  "Cmax" = list(fun = "Cmax", x = 5),
  "Cmed" = list(fun = "Cmed", x = 5),
  "p" = list(fun = "p", x = 5),
  "Cwf" = list(fun = "Cwf", n = 3),
  "Cwf2" = list(fun = "Cwf", n = 6),
  "Cwmax" = list(fun = "Cwmax"),
  "Cwmed" = list(fun = "Cwmed"),
  "Inc" = list(fun = "Inc", p = 1e5)
)

# Data checks ----

## data ----
test_that("desc_year errors if data is not a data.frame", {
  expect_error(
    desc_year(list(), "cases", "time", "space", descriptors),
    "'data' should be a data.frame"
  )
})

test_that("desc_year errors if cases column does not exist", {
  testdf <- data.frame()
  expect_error(
    desc_year(testdf, "nonexistent", "time", "space", "descriptors"),
    "No column.*'cases'"
  )
})

test_that("desc_year errors if cases column is not numeric", {
  testdf <- data.frame(cases = "string")
  expect_error(
    desc_year(testdf, "cases", "time", "space", "descriptors"),
    "'cases' column should be of type numeric"
  )
})

## time ----
test_that("desc_year errors if time column does not exist", {
  testdf <- data.frame(cases = rpois(5, 30))
  expect_error(
    desc_year(testdf, "cases", "nonexistent", "space", "descriptors"),
    "No column.*'time'"
  )
})
test_that("desc_year errors if time column is not character", {
  testdf <- data.frame(cases = rpois(5, 30), time = as.Date("2015-01-01"))
  expect_error(
    desc_year(testdf, "cases", "time", "space", "descriptors"),
    "'time' column should be of type character"
  )
})
test_that("desc_year errors if time column has missing values", {
  testdf <- data.frame(cases = rpois(5, 30), time = c(rep("2015-01-01", 4), NA))
  expect_error(
    desc_year(testdf, "cases", "time", "space", "descriptors"),
    "No missing values are allowed in the 'time'"
  )
})
test_that("desc_year errors if invalid epiyearweeks", {
  testdf <- data.frame(
    cases = rpois(5, 30),
    space = "A",
    time = c("202501", "202502", "202503", "202504", "2025055")
  )
  expect_error(
    desc_year(testdf, "cases", "time", "space", "descriptors"),
    "invalid epiyearweeks"
  )
  testdf <- data.frame(
    cases = rpois(5, 30),
    space = "A",
    time = c("202501", "202502", "202503", "202504", "202599")
  )
  expect_error(
    desc_year(testdf, "cases", "time", "space", "descriptors"),
    "invalid epiyearweeks"
  )
  testdf <- data.frame(
    cases = rpois(5, 30),
    space = "A",
    time = c("202501", "202502", "202503", "202504", "202506")
  )
  expect_error(
    desc_year(testdf, "cases", "time", "space", "descriptors"),
    "The time series is not regular"
  )
})

# space ----
test_that("desc_year errors if space column does not exist", {
  testdf <- data.frame(cases = rpois(5, 30), time = "20150101")
  expect_error(
    desc_year(testdf, "cases", "time", "nonexistent", "descriptors"),
    "No column.*'space'"
  )
})

test_that("desc_year errors if space column contains NAs", {
  testdf <- data.frame(cases = rpois(5, 30), time = "20150101", space = "A")
  testdf$space[4] <- NA
  expect_error(
    desc_year(testdf, "cases", "time", "space", descriptors),
    "No missing values.*'space'"
  )
})

# sweek ----
test_that("desc_year errors if sweek is not numeric", {
  expect_error(
    desc_year(
      dfval,
      "cases",
      "epiyw",
      "spatialID",
      descriptors,
      sweek = "40"
    ),
    "'sweek' should be of type numeric"
  )
})

test_that("desc_year errors if sweek is out of range", {
  expect_error(
    desc_year(dfval, "cases", "epiyw", "spatialID", descriptors, sweek = 0),
    "within the range 1-52"
  )
  expect_error(
    desc_year(dfval, "cases", "epiyw", "spatialID", descriptors, sweek = 53),
    "within the range 1-52"
  )
})

# descriptors ----
test_that("desc_year errors on unknown descriptor name", {
  bad_desc <- list(X = list(fun = "NotADescriptor"))
  expect_error(
    desc_year(dfval, "cases", "epiyw", "spatialID", bad_desc),
    "Unknown descriptors"
  )
})
test_that("desc_year errors if required descriptor parameter is missing", {
  bad_desc <- list(X = list(fun = "Cnf"))
  expect_error(
    desc_year(dfval, "cases", "epiyw", "spatialID", bad_desc),
    "Parameter n not supplied"
  )
})
test_that("desc_year errors if descriptor parameter is non-numeric", {
  bad_desc <- list(X = list(fun = "Cnf", n = "two"))
  expect_error(
    desc_year(dfval, "cases", "epiyw", "spatialID", bad_desc),
    "must be numeric"
  )
})

# pop/inc ----
test_that("desc_year errors if Inc used but pop not supplied", {
  inc_desc <- list(inc = list(fun = "Inc", p = 10000))
  expect_error(
    desc_year(dfval, "cases", "epiyw", "spatialID", inc_desc),
    "'pop' is required"
  )
})
test_that("desc_year errors if pop column does not exist in data", {
  inc_desc <- list(inc = list(fun = "Inc", p = 10000))
  expect_error(
    desc_year(
      dfval,
      "cases",
      "epiyw",
      "spatialID",
      inc_desc,
      pop = "nonexistent"
    ),
    "No column.*'pop'"
  )
})
test_that("desc_year errors if pop column contains NAs", {
  dfmiss <- dfval
  dfmiss$pop[40] <- NA
  inc_desc <- list(inc = list(fun = "Inc", p = 10000))
  expect_error(
    desc_year(
      dfmiss,
      "cases",
      "epiyw",
      "spatialID",
      inc_desc,
      pop = "pop"
    ),
    "No missing values.*'pop'"
  )
})

# Pre-processing ----
test_that("desc_year errors on duplicated time points within a spatial unit", {
  expect_error(
    desc_year(
      rbind(dfval, dfval),
      "cases",
      "epiyw",
      "spatialID",
      pop = "pop",
      descriptors
    ),
    "Duplicated time points"
  )
})
test_that("desc_year warns and expands grid when spatial units have missing time points", {
  df_missing <- dfval[!(dfval$spatialID == "A" & dfval$epiyw == "202605"), ]
  expect_warning(
    desc_year(
      df_missing,
      "cases",
      "epiyw",
      "spatialID",
      descriptors,
      pop = "pop"
    ),
    "spatio-temporal grid will be expanded"
  )
})

# collapse53 results ----
test_that("collapse53 acts as expected", {
  eyw <- c(as.character(1:53), as.character(1:52))
  eyw <- ifelse(nchar(eyw) == 1, paste0("0", eyw), eyw)
  eyw <- paste0(c(rep("2025", 53), rep("2026", 52)), eyw)
  descInc <- list("Inc" = list(fun = "Inc", p = 1))
  df53 <- data.frame(
    time = eyw,
    space = "A",
    cases = c(rep(1, 52), 1000, rep(1, 52)),
    pop = 1
  )

  # Collapse
  collTRUE <- desc_year(
    df53,
    "cases",
    "time",
    "space",
    descInc,
    pop = "pop"
  )
  expect_identical(collTRUE$Inc[1], 552)
  expect_identical(collTRUE$Inc[2], 552)

  collFALSE <- desc_year(
    df53,
    "cases",
    "time",
    "space",
    descInc,
    pop = "pop",
    collapse53 = FALSE
  )
  expect_identical(collFALSE$Inc[1], 1052)
  expect_identical(collFALSE$Inc[2], 52)
})

# sweek acts as expected
test_that("collapse53 acts as expected", {
  eyw <- c(as.character(1:53), as.character(1:52))
  eyw <- ifelse(nchar(eyw) == 1, paste0("0", eyw), eyw)
  eyw <- paste0(c(rep("2025", 53), rep("2026", 52)), eyw)
  descInc <- list("Inc" = list(fun = "Inc", p = 1))
  df53 <- data.frame(
    time = eyw,
    space = "A",
    cases = c(rep(1, 52), 1000, rep(1, 52)),
    pop = 1
  )

  # sweek1
  sweek1 <- desc_year(
    df53,
    "cases",
    "time",
    "space",
    descInc,
    pop = "pop"
  )
  expect_identical(sum(is.na(sweek1$Inc)), 0L)

  # sweek40
  sweek40 <- desc_year(
    df53,
    "cases",
    "time",
    "space",
    descInc,
    pop = "pop",
    sweek = 40
  )
  expect_identical(sum(is.na(sweek40$Inc)), 2L)
})
