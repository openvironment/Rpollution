#' Login at Infoaguas CETESB.
#'
#' Register at: https://sistemainfoaguas.cetesb.sp.gov.br/Login/Index
#'
#' @param login Character. Login email.
#' @param password Character. Password
#'
#' @return Message wheter the login succeeded or not.
#' @export
infoaguas_login <- function(login, password) {
  u <- "https://sistemainfoaguas.cetesb.sp.gov.br"

  # Get the token
  r <- httr::GET(u)

  token <- r %>%
    xml2::read_html() %>%
    xml2::xml_find_first("//*[@name='__RequestVerificationToken']") %>%
    xml2::xml_attr("value")

  # Authenticate
  body <- list(
    "Email" = login,
    "Senha" = password,
    "X-Requested-With" = "XMLHttpRequest",
    "__RequestVerificationToken" = token
  )

  r_post <- httr::POST(u, body = body, encode = "form")

  response <-
    httr::content(r_post) %>% purrr::pluck("result") # Result "ok" -> authentication worked.

  if (response == "Ok") {
    message("The authentication on Infoaguas Cetesb succeeded.")
  } else if (response == "Erro") {
    stop(
      "The authentication on Infoaguas Cetesb was NOT succeeded.
         Please check if your email and password are correct."
    )
  }

}
