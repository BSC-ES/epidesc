#' Cnf
#'
#' @description Frequency of periods of consecutive 'n' weeks or longer with at
#' least 'x' cases.
#'
#' @param df A data.frame with a numeric 'cases' column.
#' @param n Number of consecutive weeks.
#' @param x Number of cases.
#'
#' @details This function is designed to be called by [desc_year] on data
#' that has already been split into a single epidemiological year for a
#' single spatial unit. Using it directly outside of that context is not
#' recommended, as no input validation is performed.
#'
#' @examples
#' # Single spatial unit and epidemiological year
#' oneyear <- dengueRio[dengueRio$muni_code == 330455, ]
#' oneyear$time <- epiyearweek(oneyear$date)
#' oneyear <- oneyear[substr(oneyear$time, 1, 4) == "2019", ]
#' desc_Cnf(oneyear, 3, 50)
#' @returns The computed Cnf epidescriptor.
#' @export
desc_Cnf <- function(df, n, x) {
  res <- nseq::trle_cond(df$cases, a_op = "gte", a = n, b_op = "gte", b = x)

  res
}

#' Cmax
#'
#' @description Maximum duration in consecutive weeks with at least 'x' cases.
#'
#' @inheritParams desc_Cnf
#'
#' @details This function is designed to be called by [desc_year] on data
#' that has already been split into a single epidemiological year for a
#' single spatial unit. Using it directly outside of that context is not
#' recommended, as no input validation is performed.
#'
#' @examples
#' # Single spatial unit and epidemiological year
#' oneyear <- dengueRio[dengueRio$muni_code == 330455, ]
#' oneyear$time <- epiyearweek(oneyear$date)
#' oneyear <- oneyear[substr(oneyear$time, 1, 4) == "2019", ]
#' desc_Cmax(oneyear, 50)
#' @returns The computed Cmax epidescriptor.
#' @export
desc_Cmax <- function(df, x) {
  res <- nseq::trle_cond_stat(df$cases, b_op = "gte", b = x, stat = "max")

  # If no sequences are found
  if (is.na(res)) {
    res <- 0
  }

  res
}

#' Cmed
#'
#' @description Median duration in consecutive weeks with at least 'x' cases.
#'
#' @inheritParams desc_Cnf
#'
#' @details This function is designed to be called by [desc_year] on data
#' that has already been split into a single epidemiological year for a
#' single spatial unit. Using it directly outside of that context is not
#' recommended, as no input validation is performed.
#'
#' @examples
#' # Single spatial unit and epidemiological year
#' oneyear <- dengueRio[dengueRio$muni_code == 330455, ]
#' oneyear$time <- epiyearweek(oneyear$date)
#' oneyear <- oneyear[substr(oneyear$time, 1, 4) == "2019", ]
#' desc_Cmed(oneyear, 50)
#' @returns The computed Cmed epidescriptor.
#' @export
desc_Cmed <- function(df, x) {
  res <- nseq::trle_cond_stat(df$cases, b_op = "gte", b = x, stat = "median")

  # If no sequences are found
  if (is.na(res)) {
    res <- 0
  }

  res
}

#' Isof
#'
#' @description Number of weeks with isolated cases, i.e. weeks with 0 cases
#' both in the previous and following week.
#'
#' @inheritParams desc_Cnf
#'
#' @details This function is designed to be called by [desc_year] on data
#' that has already been split into a single epidemiological year for a
#' single spatial unit. Using it directly outside of that context is not
#' recommended, as no input validation is performed.
#'
#' @examples
#' # Single spatial unit and epidemiological year
#' oneyear <- dengueRio[dengueRio$muni_code == 330455, ]
#' oneyear$time <- epiyearweek(oneyear$date)
#' oneyear <- oneyear[substr(oneyear$time, 1, 4) == "2019", ]
#' desc_Isof(oneyear)
#' @returns The computed Isof epidescriptor.
#' @export
desc_Isof <- function(df) {
  res <- nseq::trle_cond(
    df$cases,
    a_op = "e",
    a = 1,
    b_op = "gt",
    b = 0,
    isolated = TRUE
  )

  res
}

#' p
#'
#' @description Proportion of weeks with at least 'x' cases.
#'
#' @inheritParams desc_Cnf
#'
#' @details This function is designed to be called by [desc_year] on data
#' that has already been split into a single epidemiological year for a
#' single spatial unit. Using it directly outside of that context is not
#' recommended, as no input validation is performed.
#'
#' @examples
#' # Single spatial unit and epidemiological year
#' oneyear <- dengueRio[dengueRio$muni_code == 330455, ]
#' oneyear$time <- epiyearweek(oneyear$date)
#' oneyear <- oneyear[substr(oneyear$time, 1, 4) == "2019", ]
#' desc_p(oneyear, 50)
#' @returns The computed p epidescriptor.
#' @export
desc_p <- function(df, x) {
  res <- df$cases >= x
  res <- sum(res) / length(res)

  res
}
