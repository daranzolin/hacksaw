#' Grep and filter a data frame by pattern
#'
#' @param .data a table of data.
#' @param col a variable.
#' @param pattern string containing a regular expression to be matched in the given character vector.
#' @param ... additional arguments passed to grepl
#'
#' @export
filter_pattern <- function(.data, col, pattern, ...) {
  col <- rlang::enquo(col)
  dplyr::filter(.data, grepl(pattern = pattern, x = !!col, ...))
}

#' Grep, keep or discard a list or vector by pattern
#'
#' @param x a list of vector
#' @param pattern string containing a regular expression to be matched in the given character vector.
#' @param ... additional arguments passed to grepl
#'
#' @rdname list-ops
#' @export
keep_pattern <- function(x, pattern, ...) {
  purrr::keep(x, ~grepl(pattern = pattern, x = .x, ...))
}

#' @rdname list-ops
#' @export
discard_pattern <- function(x, pattern, ...) {
  purrr::discard(x, ~grepl(pattern = pattern, x = .x, ...))
}
