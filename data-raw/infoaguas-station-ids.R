devtools::load_all()
infoaguas_login(login = Sys.getenv("CETESB_LOGIN"),
                password = Sys.getenv("CETESB_PWD"))

u_busca <-
  "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais"

body_busca <- list(
  "TipoConsulta" = "Monitoramento",
  "FiltroTipo" = "0",
  "X-Requested-With" = "XMLHttpRequest"
)

r_search <-
  httr::POST(u_busca, body = body_busca, encode = "form")


r_monitoramento <-
  httr::GET(
    "https://sistemainfoaguas.cetesb.sp.gov.br/AguasSuperficiais/RelatorioQualidadeAguasSuperficiais/Monitoramento"
  )

id_interaguas  <- r_monitoramento %>%
  xml2::read_html() %>%
  xml2::xml_find_first("//table//tbody") %>%
  xml2::xml_find_all("//input") %>%
  xml2::xml_attr("value")


id_table <-
  r_monitoramento %>%
  httr::content() %>%
  rvest::html_table() %>%
  purrr::pluck(1) %>%
  janitor::clean_names()  %>%
  tibble::as_tibble() %>%
  tibble::add_column(id_interaguas) %>%
  dplyr::select(-x) %>%
  dplyr::mutate(
    initial_date = readr::parse_date(data_inicio, format = "%d/%m/%Y"),
    end_date = as.character(data_fim),
    end_date = readr::parse_date(end_date, format = "%d/%m/%Y"),
    municipality = abjutils::rm_accent(municipio),
    municipality = stringr::str_replace_all(municipality, "-", " "),
    municipality = dplyr::case_when(
      municipality == "SANTANA DO PARNAIBA" ~
        "SANTANA DE PARNAIBA",
      municipality == "QUEIROS" ~ "QUEIROZ",
      TRUE ~ municipality
    )
  ) %>%
  dplyr::select(-data_fim, -data_inicio, -municipio) %>%
  dplyr::rename(
    "address" = localizacao,
    "water_system" = sist_hidrico,
    "id_station" = cod_ponto
  )

municipalities_sp <-  geobr::read_municipality("SP") %>%
  sf::st_drop_geometry() %>%
  dplyr::select(code_muni, name_muni) %>%
  tibble::as_tibble() %>%
  dplyr::mutate(municipality = stringr::str_to_upper(name_muni),
                municipality = abjutils::rm_accent(municipality),
                municipality = stringr::str_replace_all(municipality, "-", " "),
                municipality = stringr::str_replace_all(municipality,  "'", " "),
                municipality = dplyr::case_when(municipality == "MOJI MIRIM" ~
                                                  "MOGI MIRIM",
                                                TRUE ~ municipality))


infoaguas_station_ids <-  id_table %>%
  dplyr::left_join(municipalities_sp, by = "municipality") %>%
  dplyr::select(-municipality) %>%
  dplyr::mutate(code_muni = as.character(code_muni))


usethis::use_data(infoaguas_station_ids, overwrite = TRUE)
