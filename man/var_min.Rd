% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/splits.R
\name{var_min}
\alias{var_min}
\title{Return the indices of n min values of a variable}
\usage{
var_min(var, n = 6, value = FALSE)
}
\arguments{
\item{var}{the variable to use.}

\item{n}{number of rows to return.}

\item{value}{if FALSE, a vector containing the (integer) indices
is returned, and if TRUE, a vector containing the elements
themselves is returned.}
}
\description{
Return the indices of n min values of a variable
}
\examples{
var_min(1:10)
}
