#' Shift row values left or right
#'
#' @param .data a table of data.
#' @param .dir the shift direction as a string, one of "left" or "right".
#' @param at the row indices at which to shift.
#'
#' @return a tibble
#' @export
#' @examples
#' library(dplyr)
#' df <- tibble(
#'     s = c(NA, 1, NA, NA),
#'     t = c(NA, NA, 1, NA),
#'     u = c(NA, NA, 2, 5),
#'     v = c(5, 1, 9, 2),
#'     x = c(1, 5, 6, 7),
#'     y = c(NA, NA, 8, NA),
#'     z = 1:4
#' )

#' df %>% shift_row_values()
#' df %>% shift_row_values(at = 1:3)
#' df %>% shift_row_values(at = 1:2, .dir = "right")
shift_row_values <- function(.data, .dir = "left", at = NULL) {

  out <- assert_df(.data)

  if (!.dir %in% c("right", "left")) {
    stop("'.dir' must be either 'left' or 'right'", call. = FALSE)
  }

  nc <- ncol(out)
  nm <- names(out)
  if (is.null(at)) at <- 1:nrow(out)
  rts <- out[at,]
  rws <- split(rts, seq_len(nrow(rts)))
  vl <- lapply(rws, function(x) {
    vals <- x[!is.na(x)]
    vl <- length(vals)
    na_out <- nc - vl
    if (.dir != "left") {
      return(c(rep(NA, na_out), vals))
    }
    c(vals, rep(NA, na_out))
  })
  rsh <- as.data.frame(do.call(rbind, vl))
  names(rsh) <- nm

  out[at,] <- rsh
  if (inherits(.data, "tbl")) out <- tibble::as_tibble(out)
  out
}
