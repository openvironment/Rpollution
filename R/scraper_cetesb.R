#' Scraper CETESB
#'
#' @param station A numeric value indicating the station id from
#' where you wish to get the data.
#' See [Rpollution::cetesb_station_ids].
#' @param parameters A numeric vector of maximum length equal to 3 indicating
#' the ids of the parameters you want to get the data from.
#' See [Rpollution::cetesb_station_ids].
#' @param start A string in the format "dd/mm/aaaa" representing
#' the initial day for the data selection.
#' @param end A string in the format "dd/mm/aaaa" representing  the
#' final day for the data selection.
#' @param login A string with your login on Qualar system.
#' @param password A string with your passoword on Qualar system.
#' @param safe If FALSE (default) the function will return a error if it can't
#' extract the requested data.
#' @param file A string containing a path to a .rds file where the data will be
#' written. If NULL (default) the data will be return.
#'
#' @return A tibble with the data returned by the Qualar system.
#' @importFrom dplyr %>%
#' @examples
#' \dontrun{
#'
#' # Ozone for 'Dom Pedro II' station for January 2018.
#'
#' scraper_cetesb(station = 72, parameter = 63,
#'                start = "01/01/2018", end = "31/01/2018",
#'                login = "login", password = "password")
#' }
#' @export
scraper_cetesb <- function(station, parameter, start, end, login, password,
                           safe = FALSE, file = NULL) {

  if(!is.null(file))
    if(fs::path_ext(file) != "rds")
      stop("`file` must be a path to a rds file")

  cookie <- get_session_cookie(
    url = "https://qualar.cetesb.sp.gov.br/qualar/home.do"
  )

  res <- login_qualar(
    url = "https://qualar.cetesb.sp.gov.br/qualar/autenticador",
    login = login,
    password = password,
    cookie = cookie
  )

  res <- get_data(
    url = "https://qualar.cetesb.sp.gov.br/qualar/exportaDadosAvanc.do?method=exportar",
    station = station,
    parameter = parameter,
    start = start,
    end = end,
    cookie = cookie
  )

  if(stringr::str_detect(res$headers$`content-type`, "text/csv")) {
    data <- safe_extract_data(res, station, parameter)
  } else {
    data <- NULL
  }

  if(is.null(data) & !safe) {
    stop("An error ocurred when extracting data.\n
         Make sure that:\n
         - you are connected to the internet;
         - the login and password are correct;
         - the selected station measures the requested parameter.")
  } else if(is.null(data) & safe) {
    message(glue::glue("Data for parameter {parameter} from station {station} was not downloaded."))
    if(is.null(file)) {
      return(NULL)
    } else {
      invisible(FALSE)
    }
  } else if(!is.null(data)) {
    message(
      glue::glue("Data for parameter {parameter} from station {station} was successfully downloaded.")
    )
    if(is.null(file)) {
      return(data)
    } else {
      readr::write_rds(data, file)
      invisible(TRUE)
    }
  }

}
