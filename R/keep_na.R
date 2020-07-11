#' Keep rows containing missing values
#'
#' @param .data A data frame.
#' @param ... A selection of columns. If empty, all columns are selected.
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
keep_na <- function(.data, ...) {
  vars <- tidyselect::eval_select(rlang::expr(c(...)), .data)
  if (rlang::is_empty(vars)) {
    na_vars <- .data
  } else {
    na_vars <- dplyr::select(.data, ...)
  }
  na_inds <- purrr::map(na_vars, ~which(is.na(.)))
  common_na_inds <- purrr::reduce(na_inds, dplyr::intersect)
  dplyr::slice(.data, common_na_inds)
}
