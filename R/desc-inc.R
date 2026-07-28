#' Inc
#'
#' @description Disease incidence per 'p' persons.
#'
#' @param df A data.frame consisting of 52 rows (1 year) for a single spatial
#' unit with columns 'time' (epiyearweek), 'cases', 'epiweek', 'epiyear',
#' and 'pop'.
#' @param p Number of persons representing the scale of the incidence.
#'
#' @examples
#' desc_Inc(dengueRio, 100000)
#' @returns The computed Inc epidescriptor.
#' @export
desc_Inc <- function(df, p) {
  res <- sum(df$cases) / mean(df$pop)
  res <- res * p

  res
}
