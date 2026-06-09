#' Cwf
#'
#' @description Frequency of periods of consecutive weeks with at least 'n'
#' weeks without cases.
#'
#' @param df A data.frame consisting of 52 rows (1 year) for a single spatial
#' unit with columns 'time' (epiyearweek), 'cases', 'epiweek' and 'epiyear'.
#' @param n Number of consecutive weeks.
#'
#' @returns The computed Cwf epidescriptor.
#' @export
desc_Cwf <- function(df, n) {
  res <- nseq::trle_cond(df$cases, a_op = "gte", a = n, b_op = "e", b = 0)

  return(res)
}

#' Cwmax
#'
#' @description Maximum duration in consecutive weeks without cases.
#'
#' @param df A data.frame consisting of 52 rows (1 year) for a single spatial
#' unit with columns 'time' (epiyearweek), 'cases', 'epiweek' and 'epiyear'.
#'
#' @returns The computed Cmax epidescriptor.
#' @export
desc_Cwmax <- function(df) {
  res <- nseq::trle_cond_stat(df$cases, b_op = "e", b = 0, stat = "max")

  # If no sequences are found
  if (is.na(res)) {
    res <- 0
  }

  return(res)
}

#' Cwmed
#'
#' @description Median duration in consecutive weeks without cases.
#'
#' @param df A data.frame consisting of 52 rows (1 year) for a single spatial
#' unit with columns 'time' (epiyearweek), 'cases', 'epiweek' and 'epiyear'.
#'
#' @returns The computed Cmed epidescriptor.
#' @export
desc_Cwmed <- function(df) {
  res <- nseq::trle_cond_stat(df$cases, b_op = "e", b = 0, stat = "median")

  # If no sequences are found
  if (is.na(res)) {
    res <- 0
  }

  return(res)
}
