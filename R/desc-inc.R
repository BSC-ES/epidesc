#' Inc
#'
#' @description Disease incidence per 'p' persons.
#'
#' @param df A data.frame with numeric 'cases' and 'pop' columns.
#' @param p Number of persons representing the scale of the incidence.
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
#' desc_Inc(oneyear, 100000)
#' @returns The computed Inc epidescriptor.
#' @export
desc_Inc <- function(df, p) {
  res <- sum(df$cases) / mean(df$pop)
  res <- res * p

  res
}
