#' Ap
#'
#' @description Week where the maximum peak occurred.
#'
#' @param df A data.frame consisting of 52 rows (1 year) for a single spatial
#' unit with columns 'time' (epiyearweek), 'cases', 'epiweek' and 'epiyear'.
#'
#' @returns The computed Ap epidescriptor.
#' @export
desc_Ap <- function(df) {
  res <- max(df$cases)

  return(res)
}

#' Tp
#'
#' @description Week where the maximum peak occurred.
#'
#' @param df A data.frame consisting of 52 rows (1 year) for a single spatial
#' unit with columns 'time' (epiyearweek), 'cases', 'epiweek' and 'epiyear'.
#'
#' @returns The computed Tp epidescriptor.
#' @export
desc_Tp <- function(df) {
  res <- df$epiweek[which.max(df$cases)]

  return(res)
}
