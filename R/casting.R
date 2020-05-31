#' Cast columns to a specified data type
#'
#' @param .data a table of data
#' @param ... A selection of columns
#'
#' @export
#' @rdname casting
#'
#' @examples
#' df <- data.frame(x = 1:3, y = as.character(1:3), z = c(0, 0, 1))
#' df %>% cast_character(x)
#' df %>% cast_numeric(y)
#' df %>% cast_logical(z)
cast_character <- function(.data, ...) {
  dplyr::mutate_at(.data, dplyr::vars(...), as.character)
}

#' @rdname casting
#' @export
cast_numeric <- function(.data, ...) {
  dplyr::mutate_at(.data, dplyr::vars(...), as.numeric)
}

#' @rdname casting
#' @export
cast_logical <- function(.data, ...) {
  dplyr::mutate_at(.data, dplyr::vars(...), as.logical)
}
