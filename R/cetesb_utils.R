## Get cookie from session
get_session_cookie <- function(url) {

  res <- httr::GET(url)

  httr::cookies(res)$value %>%
    purrr::set_names(httr::cookies(res)$name)

}

## Log in the system
login_qualar <- function(url, login, password, cookie) {

  res <- httr::POST(
    url,
    body = list(
      cetesb_login = login,
      cetesb_password = password,
      enviar = "OK"
    ),
    encode = "form",
    httr::set_cookies(cookie)
  )
}

## Get data
get_data <- function(url, station, parameter, start, end, cookie) {

  pars <- list(
    dataInicialStr  = start,
    dataFinalStr = end,
    estacaoVO.nestcaMonto = station,
    nparmtsSelecionados = parameter
  )

  httr::POST(
    url,
    query = list(method = "exportar"),
    body = pars,
    encode = "form",
    httr::set_cookies(cookie),
    httr::accept("text/csv")
  )
}


## Extract data
extract_data <- function(res, station, parameter) {

  cetesb_param_ids <- Rpollution::cetesb_param_ids
  cetesb_station_ids <- Rpollution::cetesb_station_ids

  station_name <- cetesb_station_ids$stationname[cetesb_station_ids$id == station]
  par_name <- cetesb_param_ids$param_abbrev[cetesb_param_ids$id == parameter]

  suppressMessages({
    httr::content(res, "text") %>%
      readr::read_csv2(skip = 8, col_names = FALSE, col_types = c("ccn"))
  }) %>%
    dplyr::rename(date = X1, hour = X2, conc = X3) %>%
    dplyr::mutate(
      date = lubridate::dmy(date),
      conc = as.numeric(conc),
      hour = stringr::str_extract(hour, "[0-9]{2}") %>% as.numeric,
      stationname = station_name,
      parameter = par_name
    ) %>%
    dplyr::select(stationname, parameter, date, hour, conc)
}

## Safe extract data
safe_extract_data <- purrr::possibly(extract_data, otherwise = NULL)

