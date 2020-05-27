#' Perform various operations before splitting
#'
#' @param .data A data frame.
#' @param ... Expressions to be evaluated.
#'
#' @export
#' @rdname split-ops
#' @export
filter_split <- function(.data, ...) {
  iterate_expressions(.data, "filter", ...)
}

#' @rdname split-ops
#' @export
select_split <- function(.data, ...) {
  iterate_expressions(.data, "select", ...)
}

#' @rdname split-ops
#' @export
distinct_split <- function(.data, ...) {
  out <- iterate_expressions(.data, "distinct", ...)
  purrr::map(out, unlist)
}

#' @rdname split-ops
#' @export
transmute_split <- function(.data, ...) {
  iterate_expressions(.data, "transmute", ...)
}

#' @rdname split-ops
#' @export
slice_split <- function(.data, ...) {
  iterate_expressions(.data, "slice", ...)
}

iterate_expressions <- function(.data, verb, ...) {
  exprs <- rlang::enquos(...)
  expr_list <- list(exprs)
  f <- utils::getFromNamespace(verb, "dplyr")
  purrr::map(expr_list[[1]], function(expr) f(.data, !!expr))
}
