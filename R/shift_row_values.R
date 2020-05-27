#' Shift row values left or right
#'
#' @param data a table of data.
#' @param .dir the shift direction as a string, one of "left" or "right"
#' @param at the row indices at which to shift
#'
#' @return a tibble
#' @export
shift_row_values <- function(data, .dir = "left", at = NULL) {
  nc <- ncol(data)
  nm <- names(data)
  if (is.null(at)) at <- 1:nrow(data)
  rts <- data[at,]
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

  if (max(at) == nrow(data)) {
    return(rsh)
  }
  data[at,] <- rsh
  data
}
