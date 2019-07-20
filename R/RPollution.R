#' \code{RPollution} package
#'
#' Functions for air pollution analysis
#'
#' See the README
#' on \href{https://github.com/williamorim/Rpollution#readme}{GitHub}
#'
#' @docType package
#' @name RPollution
#' @importFrom dplyr %>%
NULL

## quiets concerns of R CMD check re: the variables that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(
  c("X1", "X2", "X3", "conc", "hour", "stationname"),
  add = FALSE
)
