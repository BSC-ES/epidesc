#' Ap
#'
#' @description Maximum weekly case count (height of the epidemic peak).
#'
#' @inheritParams desc_Cnf
#'
#' @examples
#' desc_Ap(dengueRio)
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
#' @inheritParams desc_Cnf
#'
#' @examples
#' desc_Tp(dengueRio)
#' @returns The computed Tp epidescriptor.
#' @export
desc_Tp <- function(df) {
  res <- df$epiweek[which.max(df$cases)]

  res
}
