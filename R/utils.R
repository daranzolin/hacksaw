assert_df <- function(.data) {
  if (!inherits(.data, "data.frame")) {
    stop("'.data' must be a data frame", call. = FALSE)
  }
  .data
}

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}
