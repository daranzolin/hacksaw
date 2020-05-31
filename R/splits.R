#' Perform various operations before splitting
#'
#' Learn more in `vignette("hacksaw-splitting")`.
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
    nm <- purrr::map_chr(out, names)
    out <- purrr::map(out, unlist)
    names(out) <- nm
    return(out)
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

#' Return the indices of n max values of a variable
#'
#' @param var the variable to use.
#' @param n number of rows to return.
#'
#' @export
var_max <- function(var, n = 6) {
  pf <- parent.frame()
  vals <- utils::tail(sort(var), n)
  eval(expr = which(var %in% vals)[1:n], envir = pf)
}

#' Return the indices of n min values of a variable
#'
#' @param var the variable to use.
#' @param n number of rows to return.
#'
#' @export
var_min <- function(var, n = 6) {
  pf <- parent.frame()
  vals <- utils::head(sort(var), n)
  eval(expr = which(var %in% vals)[1:n], envir = pf)
}

iterate_expressions <- function(.data, verb, ...) {
  exprs <- rlang::enquos(...)
  expr_list <- list(exprs)
  f <- utils::getFromNamespace(verb, "dplyr")
  purrr::map(expr_list[[1]], function(expr) f(.data, !!expr))
}

