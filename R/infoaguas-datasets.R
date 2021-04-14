#' Ids for the Infoaguas CETESB stations.
#'
#' A dataset containing the ids for every Infoaguas station.
#'
#' @format A data frame with 648 rows and 8 variables:
#' \describe{
#'   \item{id}{Id of the station.}
#'   \item{stationname}{Name of the station.}
#'   \item{water_system}{Name of the water system.}
#'   \item{initial_date}{Date when the station started to operate,
#'   in format dd/mm/aaaa.}
#'   \item{end_date}{Date when the station stopped operating,
#'   in format dd/mm/aaaa.}
#'   \item{location}{Location of the station.}
#'   \item{name_muni}{Name of the municipality where the station is located.}
#'   \item{code_muni}{Code of the municipality where the station is located.
#'   See: \url{https://www.ibge.gov.br/explica/codigos-dos-municipios.php}}
#' }
#' @source \url{https://cetesb.sp.gov.br/infoaguas/}

"infoaguas_station_ids"
