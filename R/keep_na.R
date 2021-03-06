#' Keep rows containing missing values
#'
#' @param .data A table of data.
#' @param ... A selection of columns. If empty, all columns are selected.
#' @param .logic boolean, either 'AND' or 'OR'. Logic for keeping NAs.
#' @return A data frame.
#' @examples
#' library(dplyr)
#' df <- tibble(x = c(1, 2, NA, NA), y = c("a", NA, "b", NA))
#' df %>% keep_na()
#' df %>% keep_na(x)
#'
#' vars <- "y"
#' df %>% keep_na(x, any_of(vars))
#' @export
keep_na <- function(.data, ..., .logic = c("AND", "OR")) {
  .logic <- match.arg(.logic)
  .data <- assert_df(.data)
  vars <- tidyselect::eval_select(rlang::expr(c(...)), .data)
  if (rlang::is_empty(vars)) {
    na_vars <- .data
  } else {
    na_vars <- dplyr::select(.data, ...)
  }
  na_inds <- purrr::map(na_vars, ~which(is.na(.)))
  lf <- switch(.logic,
               "AND" = dplyr::intersect,
               "OR" = c)
  slice_inds <- unique(purrr::reduce(na_inds, lf))
  dplyr::slice(.data, slice_inds)
}
