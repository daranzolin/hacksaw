#' Keep rows containing missing values
#'
#' @param .data A data frame.
#' @param ... A selection of columns.
#'
#' @export
#'
keep_na <- function(.data, ...) {
  na_vars <- dplyr::select(.data, ...)
  na_inds <- purrr::map(na_vars, ~which(is.na(.)))
  common_na_inds <- purrr::reduce(na_inds, dplyr::intersect)
  dplyr::slice(.data, common_na_inds)
}
