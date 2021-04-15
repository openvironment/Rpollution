#' Clean the data returned by the Infoaguas system
#'
#' @param df_results tibble with the data returned by the Infoaguas system.
#'
#' @return A cleaned tibble with the data returned by the Infoaguas system.
#'
infoaguas_clean_dataset <- function(df_results) {
  clean_results <- df_results %>%
    janitor::clean_names() %>%
    dplyr::mutate(dplyr::across(
      .cols = c(
        periodo_de,
        periodo_ate,
        data_coleta,
        inicio_operacao,
        fim_operacao
      ),
      .fns = lubridate::dmy
    )) %>%
    dplyr::mutate(
      hora_coleta = lubridate::hm(hora_coleta),
      valor_numerico = suppressWarnings(readr::parse_double(
        valor, locale = readr::locale(decimal_mark = ",")
      )),
      altitude = as.double(altitude)
    ) %>%
    dplyr::mutate(valor_texto = dplyr::case_when(
      parametro %in% c(
        "Ens. Ecotoxic. C/ Ceriodaphnia dubia",
        "Colora\u00e7\u00e3o",
        "Chuvas nas \u00faltimas 24h",
        "Indu\u00e7\u00e3o de Micron\u00facleos"
      ) ~ as.character(valor),

      TRUE ~ NA_character_
    )) %>%
    dplyr::relocate(c(valor_numerico, valor_texto), .after = valor) %>%
    tidyr::separate(
      latitude,
      into = c("lat_graus", "lat_min", "lat_sec"),
      sep = " ",
      remove = FALSE
    ) %>%
    tidyr::separate(
      longitude,
      into = c("long_graus", "long_min", "long_sec"),
      sep = " ",
      remove = FALSE
    ) %>%
    dplyr::mutate(
      dplyr::across(.cols = tidyselect::starts_with(c("lat_", "long_")), as.double),
      lat = biogeo::dms2dd(
        dd = lat_graus,
        mm = lat_min,
        ss = lat_sec,
        ns = "S"
      ),
      long = biogeo::dms2dd(
        dd = long_graus,
        mm = long_min,
        ss = long_sec,
        ns = "W"
      )
    ) %>%
    dplyr::select(-tidyselect::starts_with(c("lat_", "long_")))

}
