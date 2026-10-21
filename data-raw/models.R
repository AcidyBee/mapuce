## code to prepare `models` dataset goes here
## Données relatives aux modèles utilisés par l'application
path_to_models <- "data-raw/models"
model_cre <- readRDS(file.path(path_to_models, "model_cre.rds"))
model_eq <- readRDS(file.path(path_to_models, "model_eq.rds"))
model_eq_surf <- readRDS(file.path(path_to_models, "model_eq_surf.rds"))
model_iu <- readRDS(file.path(path_to_models, "model_iu.rds"))
usethis::use_data(model_cre, overwrite = TRUE)
usethis::use_data(model_eq, overwrite = TRUE)
usethis::use_data(model_eq_surf, overwrite = TRUE)
usethis::use_data(model_iu, overwrite = TRUE)
