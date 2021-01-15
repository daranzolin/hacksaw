#' Perform dplyr joins with incompatible types
#'
#' These joins will coerce key columns to a common atomic type.
#'
#' @param x A data frame
#' @param y A data frame
#' @param by A character vector of variables to join by. Can be NULL.
#' @param coerce_on_conflict Either 'character' or 'numeric'.
#' @param suffix If there are non-joined duplicate variables in x and y, these suffixes will be added to the output to disambiguate them. Should be a character vector of length 2.
#' @param ... Other parameters passed on to methods
#' @param keep Should the join keys from both x and y be preserved in the output?
#' @rdname coercive-joins
#' @return a data frame
#' @export
#' @examples
#' df1 <- data.frame(x = 1:10, b = 1:10, y = letters[1:10])
#' df2 <- data.frame(x = as.character(1:10), z = letters[11:20])
#' left_join2(df1, df2)
left_join2 <- function(x, y, by = NULL,
                       coerce_on_conflict = c("character", "numeric"),
                       suffix = c(".x", ".y"),
                       ...,
                       keep = FALSE) {

  coerce_to <- match.arg(coerce_on_conflict)
  coerced <- coerce_join_by(x, y, by, coerce_to)
  dplyr::left_join(coerced[["x"]], coerced[["y"]], by = by, suffix = suffix, ..., keep = FALSE)
}

#' @rdname coercive-joins
#' @export
inner_join2 <- function(x, y, by = NULL,
                       coerce_on_conflict = c("character", "numeric"),
                       suffix = c(".x", ".y"),
                       ...,
                       keep = FALSE) {

  coerce_to <- match.arg(coerce_on_conflict)
  coerced <- coerce_join_by(x, y, by, coerce_to)
  dplyr::inner_join(coerced[["x"]], coerced[["y"]], by = by, suffix = suffix, ..., keep = FALSE)
}

#' @rdname coercive-joins
#' @export
right_join2 <- function(x, y, by = NULL,
                       coerce_on_conflict = c("character", "numeric"),
                       suffix = c(".x", ".y"),
                       ...,
                       keep = FALSE) {

  coerce_to <- match.arg(coerce_on_conflict)
  coerced <- coerce_join_by(x, y, by, coerce_to)
  dplyr::right_join(coerced[["x"]], coerced[["y"]], by = by, suffix = suffix, ..., keep = FALSE)
}

#' @rdname coercive-joins
#' @export
full_join2 <- function(x, y, by = NULL,
                       coerce_on_conflict = c("character", "numeric"),
                       suffix = c(".x", ".y"),
                       ...,
                       keep = FALSE) {

  coerce_to <- match.arg(coerce_on_conflict)
  coerced <- coerce_join_by(x, y, by, coerce_to)
  dplyr::full_join(coerced[["x"]], coerced[["y"]], by = by, suffix = suffix, ..., keep = FALSE)
}

# Adapted from dplyr cf. https://github.com/tidyverse/dplyr/R/join-cols.R
coerce_join_by <- function(x, y, by, coerce_to) {
  x_names <- names(x)
  y_names <- names(y)
  f <- switch(coerce_to,
              "character" = cast_character,
              "numeric" = cast_numeric)
  if (is.null(by)) {
    by <- dplyr::intersect(x_names, y_names)
    if (length(by) == 0) {
      rlang::abort(c(
        "`by` must be supplied when `x` and `y` have no common variables.",
        i = "use by = character()` to perform a cross-join."
      ))
    }
    x_out <- f(x, !!by)
    y_out <- f(y, !!by)
    out <- list(x = x_out, y = y_out)
  } else if (is.character(by)) {
    by_x <- names(by) %||% by
    by_y <- unname(by)
    by_x[by_x == ""] <- by_y[by_x == ""]
    x_out <- f(x, !!by_x)
    y_out <- f(y, !!by_y)
    out <- list(x = x_out, y = y_out)
  } else {
    stop("'by' must be a (named) character vector or NULL.")
  }
  out
}

