#' Perform various operations before splitting
#'
#' @param .data A data frame.
#' @param ... Expressions to be evaluated.
#'
#' @export
#' @rdname split-ops
#' @export
filter_split <- function(.data, ...) {
  expr_list <- dots_to_expr(...)
  purrr::map(expr_list[[1]], function(expr) dplyr::filter(.data, !!expr))
}

#' @rdname split-ops
#' @export
select_split <- function(.data, ...) {
  expr_list <- dots_to_expr(...)
  purrr::map(expr_list[[1]], function(expr) dplyr::select(.data, !!expr))
}

#' @rdname split-ops
#' @export
distinct_split <- function(.data, ...) {
  expr_list <- dots_to_expr(...)
  out <- purrr::map(expr_list[[1]], function(expr) dplyr::distinct(.data, !!expr))
  purrr::map(out, unlist)
}

dots_to_expr <- function(...) {
  exprs <- rlang::enquos(...)
  list(exprs)
}
