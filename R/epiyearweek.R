#' Compute epiyearweek (yyyyww) indicators from dates.
#'
#' @param date A date vector to compute epiweekyear.
#' @param start First day of the epiweek. Defaults to
#' 'Sunday', but can be also set to 'Monday'.
#'
#' @returns An epiweekyear integer vector.
#' @export
#'
#' @details The function uses lubridate's epi/iso week/year functions to
#' compute the conversion.
#'
#' @examples
#' input_dates <- seq.Date(as.Date("2025-01-01"), length.out = 7, by = "week")
#' epiyearweek(input_dates)

epiyearweek <- function(date, start = "Sunday") {
  # 0. Input checks ----

  # Input checks: date
  if (!inherits(date, "Date")) {
    stop("'date' must be a vector of class 'Date'.")
  } else if (anyNA(date)) {
    stop("'date' cannot have any missing entries.")
  }

  # Input checks: start
  if (!start %in% c("Sunday", "Monday")) {
    stop("'start' must be either 'Sunday' or 'Monday'.")
  }

  # 1. Compute epiweekyear ----
  if (start == "Sunday") {
    epidate <- paste0(
      sprintf("%04d", lubridate::epiyear(date)),
      sprintf("%02d", lubridate::epiweek(date))
    )
  } else if (start == "Monday") {
    epidate <- paste0(
      sprintf("%04d", lubridate::isoyear(date)),
      sprintf("%02d", lubridate::isoweek(date))
    )
  }

  # 2. Return ----
  epidate
}
