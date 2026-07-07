#' Cwf
#'
#' @description Frequency of periods of consecutive weeks with at least 'n'
#' weeks without cases.
#'
#' @inheritParams desc_Cnf
#'
#' @examples
#' desc_Cwf(dengueRio, 3)
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
#' @examples
#' desc_Cwmax(dengueRio)
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
#' @examples
#' desc_Cwmed(dengueRio)
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
