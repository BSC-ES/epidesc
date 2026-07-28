#' Cwf
#'
#' @description Frequency of periods of consecutive weeks with at least 'n'
#' weeks without cases.
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
#' desc_Cwf(oneyear, 3)
#' @returns The computed Cwf epidescriptor.
#' @export
desc_Cwf <- function(df, n) {
  res <- nseq::trle_cond(df$cases, a_op = "gte", a = n, b_op = "e", b = 0)

  res
}

#' Cwmax
#'
#' @description Maximum duration in consecutive weeks without cases.
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
#' desc_Cwmax(oneyear)
#' @returns The computed Cwmax epidescriptor.
#' @export
desc_Cwmax <- function(df) {
  res <- nseq::trle_cond_stat(df$cases, b_op = "e", b = 0, stat = "max")

  # If no sequences are found
  if (is.na(res)) {
    res <- 0
  }

  res
}

#' Cwmed
#'
#' @description Median duration in consecutive weeks without cases.
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
#' desc_Cwmed(oneyear)
#' @returns The computed Cwmed epidescriptor.
#' @export
desc_Cwmed <- function(df) {
  res <- nseq::trle_cond_stat(df$cases, b_op = "e", b = 0, stat = "median")

  # If no sequences are found
  if (is.na(res)) {
    res <- 0
  }

  res
}
