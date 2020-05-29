#' Perform various operations before splitting
#'
#' @param .data A data frame.
#' @param simplify Boolean, whether to unlist the returned split.
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
mutate_split <- function(.data, ...) {
  q <- rlang::enquos(...)
  out <- purrr::map2(q, names(q),
                     ~dplyr::mutate(.data,
                                    !!.y := !!rlang::parse_quo(rlang::quo_name(.x),
                                                               env = rlang::caller_env())))
  names(out) <- NULL
  out
}

#' @rdname split-ops
#' @export
distinct_split <- function(.data, ..., simplify = TRUE) {
  out <- iterate_expressions(.data, "distinct", ...)
  if (simplify) {
    return(purrr::map(out, unlist))
  }
  out
}

#' @rdname split-ops
#' @export
transmute_split <- function(.data, ..., simplify = TRUE) {
  out <- iterate_expressions(.data, "transmute", ...)
  if (simplify) {
    return(purrr::map(out, unlist))
  }
  out
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
