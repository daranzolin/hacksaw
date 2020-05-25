#' Casting functions
#'
#' @param data a table of data
#' @param ... columns
#'
#' @export
#' @rdname casting
cast_character <- function(data, ...) {
  dplyr::mutate_at(data, dplyr::vars(...), as.character)
}

#' @rdname casting
#' @export
cast_numeric <- function(data, ...) {
  dplyr::mutate_at(data, dplyr::vars(...), as.numeric)
}

#' @rdname casting
#' @export
cast_logical <- function(data, ...) {
  dplyr::mutate_at(data, dplyr::vars(...), as.logical)
}
