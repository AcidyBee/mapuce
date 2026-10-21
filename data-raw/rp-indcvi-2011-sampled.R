## code to prepare rp_indcvi_2011_sampled datasets goes here
## Ce code n'est pas exécuté, mais la commande ci-dessous est une sécurité sup.
if (FALSE) {
  devtools::load_all(".")
  ## Données relatives aux datasets utilisés par l'application: package de données `insee.data.rp.2011`
  path_to_indcvi <- "/Users/Alexis/Documents/Travail/R/Packages/insee.rp.data.2011/inst/extdata/RP-detail/INDCVI/FD_indcviza_2011.txt"
  # grep("*._(\\d{4})\\.\\w{3}", path_to_indcvi)

  # path_to_indcvi <- insee.data.rp.2011::path_to_extdata("RP-detail/INDCVI/FD_indcvi_2011.txt")
  set.seed(1234)
  rp_indcvi_2011_sampled <- extract_rp_indcvi_for_mapuce(file = path_to_indcvi) %>%
    dplyr::slice_sample(n = 1000L)
  usethis::use_data(rp_indcvi_sampled_2011, overwrite = TRUE, compress = "bzip2")
  # ✔ Setting active project to '/Users/Alexis/Documents/Travail/R/Packages/mapuce'
  # ✔ Saving 'rp_indcvi_2011_sampled' to 'data/rp_indcvi_2011_sampled.rda'
  # • Document your data (see 'https://r-pkgs.org/data.html')
}
