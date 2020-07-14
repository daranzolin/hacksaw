#' Grep and filter a data frame by pattern
#'
#' @param .data a table of data.
#' @param col a variable.
#' @param pattern string containing a regular expression to be matched in the given character vector.
#' @param ... additional arguments passed to grepl
#' @return a data frame.
#'
#' @export
#' @examples
#' library(dplyr)
#' starwars %>% filter_pattern(homeworld, "oo")
filter_pattern <- function(.data, col, pattern, ...) {
  .data <- assert_df(.data)
  col <- rlang::enquo(col)
  dplyr::filter(.data, grepl(pattern = pattern, x = !!col, ...))
}

#' Grep, keep or discard a list or vector by pattern
#'
#' @param x a list or vector.
#' @param pattern string containing a regular expression to be matched in the given character vector.
#' @param ... additional arguments passed to grepl.
#' @return A list.
#'
#' @rdname list-ops
#' @export
#' @examples
#' l <- list("David", "Daniel", "Damien", "Eric", "Jared", "Zach")
#' l %>% keep_pattern("^D")
keep_pattern <- function(x, pattern, ...) {
  purrr::keep(x, ~grepl(pattern = pattern, x = .x, ...))
}

#' @rdname list-ops
#' @export
#' @examples
#' l %>% discard_pattern("^D")
discard_pattern <- function(x, pattern, ...) {
  purrr::discard(x, ~grepl(pattern = pattern, x = .x, ...))
}
