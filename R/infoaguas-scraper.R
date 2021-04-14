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
