## code to prepare rp_indcvi_2016_sampled datasets goes here
## Ce code n'est pas exécuté, mais la commande ci-dessous est une sécurité sup.
if (FALSE) {
  devtools::load_all(".")
  # Données relatives aux datasets utilisés par l'application: package de données `insee.data.rp.2016`
  path_to_indcvi <- "/Users/Alexis/Documents/Travail/R/Packages/insee.data.rp.2016/inst/extdata/RP-detail/INDCVI/FD_INDCVI_2016.csv"
  set.seed(1234)
  rp_indcvi_2016_sampled <- extract_rp_indcvi_for_mapuce(file = path_to_indcvi) %>%
    dplyr::slice_sample(n = 1000L)
  usethis::use_data(rp_indcvi_2016_sampled, overwrite = TRUE)
  # ✔ Saving 'rp_indcvi_2016_sampled' to 'data/rp_indcvi_2016_sampled.rda'
  # • Document your data (see 'https://r-pkgs.org/data.html')


}
