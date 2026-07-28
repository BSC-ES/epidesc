#' Ap
#'
#' @description Maximum cases peak - amplitude.
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
#' desc_Ap(oneyear)
#' @returns The computed Ap epidescriptor.
#' @export
desc_Ap <- function(df) {
  res <- max(df$cases)

  res
}

#' Tp
#'
#' @description Week where the maximum peak occurred.
#'
#' @param df A data.frame with numeric 'cases' and 'epiweek' columns.
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
#' oneyear$epiweek <- as.numeric(substr(oneyear$time, 5, 6))
#' desc_Tp(oneyear)
#' @returns The computed Tp epidescriptor.
#' @export
desc_Tp <- function(df) {
  res <- df$epiweek[which.max(df$cases)]

  res
}
