#' Row bind a data frame inserting NAs if the column isn't present
#'
#' @param ... data.frames to be bound
#'
#' @returns A bound data.frame
#' @noRd
.rbind_fill_base <- function(...) {
  dfs <- list(...)
  cols <- unique(unlist(lapply(dfs, names)))
  dfs <- lapply(dfs, function(df) {
    missing <- setdiff(cols, names(df))
    df[missing] <- NA
    df[cols]
  })

  do.call(rbind, dfs)
}

.descriptors_list <- .rbind_fill_base(
  # Peak indicators
  data.frame(
    fun = "Ap",
    class = "Peak",
    description = "Maximum cases peak - amplitude"
  ),
  data.frame(
    fun = "Tp",
    class = "Peak",
    description = "Week where the maximum peak occurred - time"
  ),

  # Period with cases
  data.frame(
    fun = "Cnf",
    class = "Period with cases",
    description = paste0(
      "Frequency of periods of consecutive 'n' weeks ",
      "or longer with at least 'x' cases"
    ),
    param1 = "n",
    param2 = "x"
  ),
  data.frame(
    fun = "Cmax",
    class = "Period with cases",
    description = "Maximum duration in consecutive weeks with at least 'x' cases",
    param1 = "x"
  ),
  data.frame(
    fun = "Cmed",
    class = "Period with cases",
    description = "Median duration in consecutive weeks with at least 'x' cases",
    param1 = "x"
  ),
  data.frame(
    fun = "Isof",
    class = "Period with cases",
    description = "Number of weeks with isolated cases"
  ),
  data.frame(
    fun = "p",
    class = "Period with cases",
    description = "Proportion of weeks with at least 'x' cases",
    param1 = "x"
  ),

  # Period without cases
  data.frame(
    fun = "Cwf",
    class = "Period without cases",
    description = paste0(
      "Frequency of periods of consecutive weeks with ",
      "at least 'n' weeks without cases."
    ),
    param1 = "n"
  ),
  data.frame(
    fun = "Cwmax",
    class = "Period without cases",
    description = "Maximum duration in consecutive weeks without cases"
  ),
  data.frame(
    fun = "Cwmed",
    class = "Period without cases",
    description = "Median duration in consecutive weeks without cases"
  ),

  # Incidence
  data.frame(
    fun = "Inc",
    class = "Incidence",
    description = "Annual incidence rate per 'p' population",
    param1 = "p"
  )
)


#' List of epidescriptors and their parameters
#'
#' @returns A data.frame with the functions, descriptions, classes
#' and parameters of the descriptors included in the package.
#' @export
#'
#' @examples
#' desc_list()
desc_list <- function() {
  descriptors <- .descriptors_list
  descriptors <- descriptors[c(
    "class",
    "fun",
    "description",
    "param1",
    "param2"
  )]
  descriptors[is.na(descriptors)] <- ""

  descriptors
}
