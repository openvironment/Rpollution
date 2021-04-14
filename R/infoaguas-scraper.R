#' Scraper Infoaguas CETESB
#'
#' @param station A numeric value indicating the station id from
#' where you wish to get the data.
#' See [Rpollution::infoaguas_station_ids].
#' @param start A string in the format "dd/mm/aaaa" representing
#' the initial day for the data selection. If NULL (default) the date of
#' the start of the operation of the station will be used.
#' @param end A string in the format "dd/mm/aaaa" representing  the
#' final day for the data selection. If NULL (default) the date of the
#' search will be used.
#' @param login A string with your login on Infoaguas system.
#' @param password A string with your passoword on Infoaguas system.
#' @param file A string containing a path to a .rds file where the data will be
#' written. If NULL (default) the data will only be returned.
#'
#' @return A tibble with the data returned by the Infoaguas system.
#' @examples
#' \dontrun{
#'
#' # Data from the station BILL02100, in the Billings reservoir, in 2020.
#'
#' infoaguas_scraper(
#'   station = 146,
#'   start = "01/01/2020",
#'   end = "31/12/2020",
#'   login = "login",
#'   password = "password"
#' )
#' }
#' @export
infoaguas_scraper <- function(station,
                              start = NULL,
                              end = NULL,
                              login,
                              password,
                              file = NULL) {
  infoaguas_login(login, password)

  if (is.null(start)) {
    start <-
      infoaguas_station_ids %>%
      dplyr::filter(id_interaguas == station) %>%
      dplyr::pull(initial_date) %>%
      format("%d-%m-%Y")

    if (is.na(start)) {
      start <- "01-01-1974"
    }

  }

  if (is.null(end)) {
    end <- format(Sys.Date(), "%d-%m-%Y")
  }


  u_search <-
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/MonitoramentoModal"

  body_search <- list(
    "DataInicial" = start,
    "DataFinal" = end,
    "CodigoPonto[]" = station

  )


  r_search <- httr::POST(u_search,
                         body = body_search,
                         encode = "form")

  resposta <- httr::content(r_search) %>%
    xml2::xml_text()



  if (resposta == "success") {
    temp <- tempfile()
    get <- httr::GET(
      "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Download",
      httr::write_disk(temp, overwrite = TRUE)
    )

    results <-  readxl::read_xlsx(temp)


  } else {
    warning("escrever mensagem. nao funcionou.")
  }


  if (is.null(file)) {
    return(results)
  } else {
    readr::write_rds(data, file)
    return(results)
  }

}
