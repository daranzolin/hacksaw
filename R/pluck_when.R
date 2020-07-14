#' Pluck a value based on other criteria
#'
#' @param .x Vector from which to select value.
#' @param .p Logical expression.
#' @param .i First TRUE index to return.
#' @param .else If no matches from .p, value to return.
#'
#' @return A vector of length 1.
#' @examples
#' library(dplyr)
#' df <- tibble(
#' id = c(1, 1, 1, 2, 2, 2, 3, 3),
#' tested = c("no", "no", "yes", "no", "no", "no", "yes", "yes"),
#' year = c(2015:2017, 2010:2012, 2019:2020)
#' )
#' df %>%
#'  group_by(id) %>%
#'  mutate(year_first_tested = pluck_when(year, tested == "yes"))
#' @export
pluck_when <- function(.x, .p, .i = 1, .else = NA) {
  out <- .x[.p][.i]
  out <- out[!is.na(out)]
  if (length(out) == 0) return(.else)
  out
}
