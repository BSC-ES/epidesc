#' Compute yearly epidescriptors
#'
#' @description Compute yearly epi descriptors based on weekly case counts.
#'
#' @param data Data frame with the input data.
#' @param cases Character. Name of the variable in `data` that contains the
#' case counts.
#' @param time Character. Name of the variable in `data` that contains the
#' *epiyearweek* date temporal identifier (see [epiyearweek()]). It must be of
#' type character.
#' @param space Character. Name of the variable in `data` that  contains the
#' spatial identifier for which a case count time series is available.
#' @param descriptors A named list with the descriptor function and their
#' arguments. See details.
#' @param pop Character. Name of the variable in `data` that contains the
#' population counts. Only required if the descriptor 'Inc' (incidence) is used.
#' @param sweek Integer between 1-52 that determines the first week of
#' the season for which the descriptors will be calculated; e.g. `sweek=40` will
#' compute descriptors between week 40 and week 39 next year. Defaults to 1.
#' @param collapse53 If TRUE (default), collapse week 53 such that
#' half of the cases are assigned to the previous (w52) and next (w01) weeks.
#' It is recommended so that all years have the same number of weeks.
#'
#' @details
#' The argument `descriptors` consists of a nested list where:
#' - The name of the first level will determine the name of the descriptor.
#' - The elements of the first levels should also be a list with elements
#' `fun` (descriptor type) and the parameters `n`, `x` or `p` if necessary.
#'
#' Please see the example to see it in practice.
#'
#' @returns A data frame with the resulting descriptors for every
#' epidemiological year.
#'
#' @seealso [desc_list()] to access the list of descriptors and its parameters.
#' @export
#'
#' @examples
#' # Spatiotemporal
#' data(dengueRio)
#' dengue <- dengueRio
#'
#' # Prepare epiyearweeks
#' dengue$yearweek <- epiyearweek(dengue$date)
#'
#' # List of descriptors to be computed
#' descriptors <- list(
#'   "Ap" = list(fun = "Ap"),
#'   "Tp" = list(fun = "Tp"),
#'   "Cnf" = list(fun = "Cnf", n = 3, x = 5),
#'   "Cnf2" = list(fun = "Cnf", n = 6, x = 5),
#'   "Cmax" = list(fun = "Cmax", x = 5),
#'   "Cmed" = list(fun = "Cmed", x = 5),
#'   "p" = list(fun = "p", x = 5),
#'   "Cwf" = list(fun = "Cwf", n = 3),
#'   "Cwf2" = list(fun = "Cwf", n = 6),
#'   "Cwmax" = list(fun = "Cwmax"),
#'   "Cwmed" = list(fun = "Cwmed"),
#'   "Inc" = list(fun = "Inc", p = 1e5)
#' )
#'
#' # Compute them
#' res <- desc_year(
#'   dengue,
#'   cases = "cases",
#'   time = "yearweek",
#'   space = "muni_code",
#'   pop = "pop",
#'   sweek = 40,
#'   descriptors = descriptors
#' )

desc_year <- function(
  data,
  cases,
  time,
  space,
  descriptors,
  pop = NULL,
  sweek = 1,
  collapse53 = TRUE
) {
  # 0. Input checks ----

  # data
  if (!is.data.frame(data)) {
    stop("'data' should be a data.frame.")
  }

  # cases
  if (is.null(data[[cases]])) {
    stop("No column of the data matches the 'cases' argument.")
  } else if (!is.numeric(data[[cases]])) {
    stop("'cases' column should be of type numeric.")
  }

  # time
  if (is.null(data[[time]])) {
    stop("No column of the data matches the 'time' argument.")
  } else if (!is.character(data[[time]])) {
    stop("'time' column should be of type character.")
  } else if (anyNA(data[[time]])) {
    stop("No missing values are allowed in the 'time' column.")
  }

  # space
  if (is.null(data[[space]])) {
    stop("No column of the data matches the 'space' argument.")
  } else if (anyNA(data[[space]])) {
    stop("No missing values are allowed in the 'space' column.")
  }

  # sweek
  if (!is.numeric(sweek)) {
    stop("'sweek' should be of type numeric.")
  } else if (sweek < 1 || sweek > 52) {
    stop("'sweek' must be within the range 1-52.")
  }

  # duplicated time points
  duppl <- tapply(data[[space]], data[[time]], anyDuplicated)
  if (any(duppl)) {
    stop("Duplicated time points have been detected within spatial units.")
  }

  # valid and regular time stamps
  uniquetimes <- unique(data[[time]])
  if (any(nchar(uniquetimes) != 6)) {
    stop(
      "Found invalid epiyearweeks in 'time': ",
      paste(uniquetimes[nchar(uniquetimes) != 6])
    )
  } else if (!all(substr(uniquetimes, 5, 6) %in% sprintf("%02d", 1:53))) {
    stop(
      "Found invalid epiyearweeks in 'time': ",
      paste(
        uniquetimes[!substr(uniquetimes, 5, 6) %in% sprintf("%02d", 1:53)],
        collapse = " "
      )
    )
  } else {
    minepi <- min(as.numeric(uniquetimes))
    maxepi <- max(as.numeric(uniquetimes))
    rangeepi <- as.character(minepi:maxepi)
    rangeepi <- rangeepi[
      !substr(rangeepi, 5, 6) %in% c("00", as.character(53:99))
    ]
    if (!all(rangeepi %in% uniquetimes)) {
      stop(
        "The time series is not regular, missing times ",
        paste(rangeepi[!rangeepi %in% uniquetimes], collapse = "")
      )
    }
  }

  # descriptors
  desc_names <- sapply(descriptors, `[[`, "fun")
  if (!all(desc_names %in% .descriptors_list$fun)) {
    stop(
      "Unkown descriptors: ",
      paste(desc_names[!desc_names %in% .descriptors_list$fun], collapse = "")
    )
  }

  # descriptor params
  for (d in seq_along(descriptors)) {
    p1 <- .descriptors_list$param1[
      .descriptors_list$fun == descriptors[[d]]$fun
    ]
    if (!is.na(p1)) {
      if (!p1 %in% names(descriptors[[d]])) {
        stop(
          "Parameter ",
          p1,
          " not supplied for ",
          names(descriptors[d]),
          "."
        )
      } else if (!is.numeric(descriptors[[d]][[p1]])) {
        stop("Parameter ", p1, " must be numeric")
      }
    }
    p2 <- .descriptors_list$param2[
      .descriptors_list$fun == descriptors[[d]]$fun
    ]
    if (!is.na(p2)) {
      if (!p2 %in% names(descriptors[[d]])) {
        stop(
          "Parameter ",
          p2,
          " not supplied for ",
          names(descriptors[d]),
          "."
        )
      } else if (!is.numeric(descriptors[[d]][[p2]])) {
        stop("Parameter ", p2, " must be numeric")
      }
    }
  }

  # population data
  if ("Inc" %in% desc_names) {
    if (is.null(pop)) {
      stop("The argument 'pop' is required to compute incidence.")
    } else if (is.null(data[[pop]])) {
      stop("No column of the data matches the 'pop' argument.")
    } else if (anyNA(data[[pop]])) {
      stop("No missing values are allowed in the 'pop' column.")
    }
  }

  # 1. Pre-processing ----

  # New object with only relevant columns
  dataclean <- data.frame(
    space = data[[space]],
    time = data[[time]],
    cases = data[[cases]],
    pop = NA
  )
  if (!is.null(pop)) {
    dataclean$pop <- data[[pop]]
  }
  dataclean <- dataclean[order(dataclean$space, dataclean$time), ]

  # missing spatio-temporal observations: expand grid
  tab <- table(dataclean$time, dataclean$space)
  balanced <- length(unique(rowSums(tab > 0))) == 1 &&
    all(rowSums(tab > 0) == ncol(tab))
  if (!isTRUE(balanced)) {
    warning(
      "Some spatial units do not have all time points. The ",
      "spatio-temporal grid will be expanded with NAs."
    )

    all_combos <- expand.grid(
      time = unique(dataclean$time),
      space = unique(dataclean$space),
      stringsAsFactors = FALSE
    )
    dataclean <- merge(
      all_combos,
      dataclean,
      by = c("time", "space"),
      all.x = TRUE
    )
    dataclean <- dataclean[c("time", "space", "cases", "pop")]
  }

  # Collapse week 53
  dataclean$epiweek <- as.numeric(substr(dataclean$time, 5, 6))
  if (isTRUE(collapse53)) {
    if (any(dataclean$epiweek == 53)) {
      data53 <- dataclean[dataclean$epiweek == 53, ]
      dataclean <- dataclean[dataclean$epiweek != 53, ]

      data52 <- data53 # Half to the week before
      data52$time <- as.character(as.numeric(data52$time) - 1)
      data52$cases <- floor(data52$cases / 2)

      data01 <- data53 # Half to the next week
      data01$time <- as.character(as.numeric(data01$time) + 48)
      data01$cases <- ceiling(data01$cases / 2)

      # sum (cases), average (pop), and recalculate epiweek
      dataclean <- rbind(dataclean, data52, data01)
      dataclean1 <- stats::aggregate(
        cases ~ time + space,
        data = dataclean,
        FUN = sum,
        na.action = stats::na.pass
      )
      dataclean2 <- stats::aggregate(
        pop ~ time + space,
        data = dataclean,
        FUN = mean,
        na.action = stats::na.pass
      )
      dataclean <- merge(dataclean1, dataclean2, by = c("time", "space"))
      dataclean$epiweek <- as.numeric(substr(dataclean$time, 5, 6))
    }
    if (
      sum(data[[cases]], na.rm = TRUE) != sum(dataclean$cases, na.rm = TRUE)
    ) {
      stop("There has been an error in the data preprocessing in week 53.")
    }
  }

  # epi years
  dataclean$epiyear <- as.numeric(substr(dataclean$time, 1, 4))
  dataclean$epiyear <- ifelse(
    dataclean$epiweek < sweek,
    dataclean$epiyear - 1,
    dataclean$epiyear
  )

  # Order
  dataclean <- dataclean[order(dataclean$space, dataclean$time), ]

  # 2. Descriptors ----

  # Split by space and epiyear
  datasplit <- split(dataclean, ~ space + epiyear)

  # Compute descriptors
  res <- lapply(datasplit, .compute_descriptors, descriptors = descriptors)
  res <- as.data.frame(do.call(rbind, res))
  rownames(res) <- NULL
  names(res)[1] <- space # Recover name of the space column

  # 3. Return ----
  res
}

#' Helper to fit the descriptor functions
#'
#' @param df A data.frame consisting of 52 rows (1 year) for
#' a single spatial unit with columns 'time' (epiyearweek), 'space', 'cases',
#' 'epiweek' and 'epiyear'.
#' @param descriptors A list indicating the epidescriptors to compute and their
#' parameters. See [desc_year].
#'
#' @returns A data.frame with the computed descriptors
#' @noRd
.compute_descriptors <- function(df, descriptors) {
  # The year is not complete or there are NAs
  if (!nrow(df) %in% c(52, 53) || anyNA(df[["cases"]])) {
    res <- as.data.frame(matrix(NA, nrow = 1, ncol = length(descriptors)))
    names(res) <- names(descriptors)
  } else {
    # Compute descriptors
    res <- lapply(descriptors, function(desc) {
      fun <- desc$fun
      fun <- match.fun(paste0("desc_", fun))
      args <- desc[names(desc) != "fun"]
      do.call(fun, c(list(df), args))
    })
    res <- as.data.frame(as.list(res))
    names(res) <- names(descriptors)
  }

  # Add temporal and spatial IDs
  IDs <- data.frame(space = df$space[1], epiyear = df$epiyear[1])
  res <- cbind(IDs, res)

  res
}
