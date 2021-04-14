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


usethis::use_data(municipalities_sp, overwrite = TRUE)
