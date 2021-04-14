#' \code{Rpollution} package
#'
#' Functions for air pollution analysis
#'
#' See the README
#' on \href{https://github.com/openvironment/Rpollution#readme}{GitHub}
#'
#' @docType package
#' @name Rpollution
#' @importFrom dplyr %>%
NULL

## quiets concerns of R CMD check re: the variables that appear in pipelines
if (getRversion() >= "2.15.1")
  utils::globalVariables(
    c(
      "X1",
      "X2",
      "X3",
      "conc",
      "hour",
      "stationname",
      "altitude",
      "data",
      "data_coleta",
      "fim_operacao",
      "hora_coleta id",
      "infoaguas_station_ids",
      "inicio_operacao",
      "initial_date",
      "lat_graus",
      "lat_min",
      "lat_sec",
      "latitude",
      "long_graus",
      "long_min",
      "long_sec",
      "longitude",
      "periodo_ate",
      "periodo_de",
      "valor",
      "valor_numerico",
      "valor_texto",
      "hora_coleta",
      "id"
    )
    ,
    add = FALSE

  )
