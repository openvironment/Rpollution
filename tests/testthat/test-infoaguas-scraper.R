# test_that("infoaguas_scraper works", {
#   testthat::expect_type(infoaguas_scraper(
#     station = 146,
#     login = Sys.getenv("CETESB_LOGIN"),
#     password = Sys.getenv("CETESB_PWD")
#   )
#   ,
#   'list')
#
#   # testthat::expect_error(infoaguas_scraper(station = 146,
#   #                                          login = "",
#   #                                          password = ""))
# })
#
#
#
#
