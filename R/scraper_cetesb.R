#' Scraper CETESB
#'
#' @param station The station id for which you wish get the data.
#' See [Rpollution::cetesb_station_ids].
#' @param parameter The variable id you want the data for. See
#' [Rpollution::cetesb_station_ids].
#' @param start The initial day for the data.
#' @param end The final day for the data.
#' @param type Type of data: "P" for hourly mean or "M" for moving
#' average.
#' @param login Your login on Qualar system.
#' @param password Your passoword on Qualar system.
#' @param invalidData If TRUE, the system will return rows with
#' invalid data.
#' @param network Network type: "A" for automatic or "M" for manual.
#'
#' @export

scraper_CETESB <- function(station, parameter, start,
                           end, type = "P", login,
                           password, invalidData = "on",
                           network = "A") {


  res <- httr::GET("http://qualar.cetesb.sp.gov.br/qualar/home.do")

  my_cookie <- httr::cookies(res)$value %>%
    purrr::set_names(cookies(res)$name)

  url_login <- "http://qualar.cetesb.sp.gov.br/qualar/autenticador"

  res <- httr::POST(
    url_login,
    body = list(
      cetesb_login = login,
      cetesb_password = password,
      enviar = "OK"
    ),
    encode = "form",
    httr::set_cookies(my_cookie)
  )

  url_dados <- "http://qualar.cetesb.sp.gov.br/qualar/exportaDados.do"

  res <- httr::POST(
    url_dados,
    query = list(method = "pesquisar"),
    body = list(
      irede = network,
      dataInicialStr  = start,
      dataFinalStr = end,
      cDadosInvalidos = invalidData,
      iTipoDado = type,
      estacaoVO.nestcaMonto = station,
      parametroVO.nparmt = parameter
    ),
    encode = "form",
    set_cookies(my_cookie)
  )

  httr::content(res) %>%
    rvest::html_table(fill = TRUE) %>%
    magrittr::extract2(2)

}
