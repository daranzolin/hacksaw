#' Perform various operations before splitting
#'
#' Evaluate expressions over a data frame, resulting in a list.
#'
#' @param .data A table of data.
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
#' mtcars %>% count_split(gear, carb, across(c(cyl, gear)))
count_split <- function(.data, ...) {
  iterate_expressions(.data, "count", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% rolling_count_split(gear, carb, gear)
rolling_count_split <- function(.data, ...) {
  roll_dots(.data, ..., .f = "count")
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
#' mtcars %>% group_by_split(cyl, gear, across(c(cyl, gear)))
group_by_split <- function(.data, ...) {
  iterate_expressions(.data, "group_by", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% rolling_group_by_split(cyl, gear, am)
rolling_group_by_split <- function(.data, ...) {
  roll_dots(.data, ..., .f = "group_by")
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% nest_by_split(cyl, gear, am)
nest_by_split <- function(.data, ...) {
  iterate_expressions(.data, "nest_by", ...)
}

#' @rdname split-ops
#' @export
#' @examples
#' mtcars %>% rolling_nest_by_split(cyl, gear, am)
rolling_nest_by_split <- function(.data, ...) {
  roll_dots(.data, ..., .f = "nest_by")
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
#' @param value if FALSE, a vector containing the (integer) indices
#' is returned, and if TRUE, a vector containing the elements
#' themselves is returned.
#'
#' @export
#' @examples
#' var_max(1:10)
var_max <- function(var, n = 6, value = FALSE) {
  pf <- parent.frame()
  vals <- utils::tail(sort(var), n)
  if (value) return(vals)
  eval(expr = which(var %in% vals)[1:n], envir = pf)
}

#' Return the indices of n min values of a variable
#'
#' @param var the variable to use.
#' @param n number of rows to return.
#' @param value if FALSE, a vector containing the (integer) indices
#' is returned, and if TRUE, a vector containing the elements
#' themselves is returned.
#'
#' @export
#' @examples
#' var_min(1:10)
var_min <- function(var, n = 6, value = FALSE) {
  pf <- parent.frame()
  vals <- utils::head(sort(var), n)
  if (value) return(vals)
  eval(expr = which(var %in% vals)[1:n], envir = pf)
}

iterate_expressions <- function(.data, verb, ...) {
  expr_list <- q_list(...)
  f <- utils::getFromNamespace(verb, "dplyr")
  if (verb == "count") {
    return(purrr::map(expr_list[[1]], function(expr) f(.data, !!expr, sort = TRUE)))
  }
  purrr::map(expr_list[[1]], function(expr) f(.data, !!expr))
}

q_list <- function(...) {
  exprs <- rlang::enquos(...)
  expr_list <- list(exprs)
  expr_list
}

roll_dots <- function(.data, ..., .f) {
  dots <- rlang::enquos(...)
  out <- list()
  g <- 1
  f <- utils::getFromNamespace(.f, "dplyr")
  for (i in seq_along(dots)) {
    out[[i]] <- f(.data, !!!dots[1:g])
    g <- g + 1
  }
  out
}


