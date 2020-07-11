#' Perform various operations before splitting
#'
#' Evaluate expressions over a data frame, resulting in a list.
#'
#' @param .data A data frame.
#' @param simplify Boolean, whether to unlist the returned split.
#' @param ... Expressions to be evaluated.
#' @return A list.
#' @rdname split-ops
#' @export
#' @examples
#' library(dplyr)
#' mtcars %>% filter_split(cyl == 4, cyl == 6)
filter_split <- function(.data, ...) {
  iterate_expressions(.data, "filter", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' iris %>% select_split(starts_with("Sepal"), starts_with("Petal"))
select_split <- function(.data, ...) {
  iterate_expressions(.data, "select", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% mutate_split(mpg2 = mpg^2, mpg3 = mpg^3)
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
#' @examples
#' mtcars %>% distinct_split(cyl, carb)
distinct_split <- function(.data, ..., simplify = TRUE) {
  out <- iterate_expressions(.data, "distinct", ...)
  if (simplify) return(purrr::map(out, unlist, use.names = FALSE))
  out
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% transmute_split(mpg^2, sqrt(mpg))
transmute_split <- function(.data, ..., simplify = TRUE) {
  out <- iterate_expressions(.data, "transmute", ...)
  if (simplify) return(purrr::map(out, unlist, use.names = FALSE))
  out
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% slice_split(1:10, 11:20)
slice_split <- function(.data, ...) {
  iterate_expressions(.data, "slice", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% pull_split(mpg, hp)
pull_split <- function(.data, ...) {
  iterate_expressions(.data, "pull", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% eval_split(select(mpg, hp), filter(mpg>25), mutate(mpg2 = mpg^2))
eval_split <- function(.data, ...) {
  exprs <- rlang::enquos(...)
  out <- purrr::map(exprs, ~{
    rlang::quo(.data %>% !!.x) %>%
      rlang::quo_squash() %>%
      rlang::eval_tidy()
  })
  out
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% precision_split(mpg > 25)
precision_split <- function(.data, ...) {
  on <- rlang::enquos(...)[[1]]
  out <- dplyr::mutate(.data, !!on)
  lcn <- names(dplyr::select(out, dplyr::last_col()))
  l <- split(out, out[,lcn])
  purrr::map(l, dplyr::select, -dplyr::last_col())
}

#' Return the indices of n max values of a variable
#'
#' @param var the variable to use.
#' @param n number of rows to return.
#'
#' @export
#' @examples
#' var_max(1:10)
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
#' @examples
#' var_min(1:10)
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
