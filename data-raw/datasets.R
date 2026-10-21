## code to prepare semantic and spatial datasets goes here
devtools::load_all(".")
library(dplyr)
## Données relatives aux datasets utilisés par l'application
path_to_datasets <- "data-raw/datasets"
# ## Région Bourgogne-Franche-Comté (fichier exemple)
# semantic_start <- readRDS( file = file.path(path_to_datasets, "semantic_source_bourgogne_franchecomte_20220714.rds"))
# spatial_start <- readRDS(file = file.path(path_to_datasets, "spatial_source_bourgogne_franchecomte_20220714.rds"))
## Région IdF (fichier exemple)
semantic_ref <- readRDS( file = file.path(path_to_datasets, "semantic_source_IdF_20210201.rds")) # modification 2024-12-02: IdF fonctionne
# spatial_start <- readRDS(file = file.path(path_to_datasets, "spatial_source_IdF_WGS_84_20210201.rds"))
# ## France metro (fichier exemple): vérifier la géométrie de France entière !!!
# semantic_start <- readRDS( file = file.path(path_to_datasets, "semantic_source_France_20210201.rds")) # test 2024-12-02: Error. La France entière fait planter (plus de 15Go de RAM utilisé)
# spatial_start <- readRDS(file = file.path(path_to_datasets, "spatial_source_France_WGS_84_20210201.rds"))
usethis::use_data(semantic_ref, overwrite = TRUE)
# usethis::use_data(spatial_start, overwrite = TRUE)

# test <- dplyr::anti_join(semantic_start, spatial_start, by = "atome_indcvi")
# test2 <- dplyr::anti_join(spatial_start, semantic_start, by = "atome_indcvi")


## maj 2025-04-28: changement des noms de variables
## ****************************************************************************
## Fichier sélection des variables relatives au projet MAPUCE des fichiers RP detail
## ----------------------------------------------------------------------------
# Les variables nécessaires sont:
# var_geo <- c("IRIS", "TRIRIS", "CATIRIS", "COMMUNE", "CANTVILLE", "ARM", "DEPT", "REGION", "METRODOM") # , "IPONDI", "INPER"
vars_rp_indcvi_for_mapuce_names <- c("IRIS", "CATIRIS", "CANTVILLE", "ARM",
                                     "NUMMI", "IPONDI",
                                     "TYPL", "CHFL", "CMBL", "SURF", "NBPI",
                                     "AGEREV", "INPER", "NPERR", "COUPLE",
                                     "STOCD",
                                     "LPRM", "METRODOM")

# usethis::use_data(vars_rp_indcvi_to_import_names, overwrite = TRUE)
# Leur type respectif est:
vars_rp_indcvi_for_mapuce_types <- vroom::cols_only(
  IRIS = vroom::col_character(),
  CATIRIS = vroom::col_character(),
  CANTVILLE = vroom::col_character(),
  ARM = vroom::col_character(),
  NUMMI = vroom::col_character(),
  IPONDI = vroom::col_character(),
  TYPL = vroom::col_character(),
  CHFL = vroom::col_character(),
  CMBL = vroom::col_character(),
  SURF = vroom::col_character(),
  NBPI = vroom::col_character(),
  AGEREV = vroom::col_character(),
  INPER = vroom::col_character(),
  NPERR = vroom::col_character(),
  COUPLE = vroom::col_character(),
  STOCD = vroom::col_character(),
  LPRM = vroom::col_character(),
  METRODOM = vroom::col_character()
)
usethis::use_data(vars_rp_indcvi_for_mapuce_names, vars_rp_indcvi_for_mapuce_types, overwrite = TRUE) # , internal = TRUE
usethis::use_data(vars_rp_indcvi_for_mapuce_names, vars_rp_indcvi_for_mapuce_types, internal = TRUE, overwrite = TRUE) # , internal = TRUE


## Automatisation de la génération des datasets exemples:

## millesime 2011: seulement 1k lignes pour comparaison avec méthode manuelle
path_to_indcvi <- insee.rp.data.2011::path_to_extdata("RP-detail/INDCVI/FD_indcviza_2011.txt")
# path_to_indcvi <- system.file("extdata", "RP-detail/INDCVI/FD_indcvi_2011.txt",
#                               package = "insee.rp.data.2011")
# path_to_indcvi <- insee.rp.data.2011::path_to_extdata("RP-detail/INDCVI/FD_indcvi_2011.txt")
prepare_indcvi_datasets(path_to_indcvi, n = 1000L, seed = 1234, compress = "bzip2") # dataset_prepare.R

## millesime 2016
path_to_indcvi <- insee.rp.data.2016::path_to_extdata("RP-detail/INDCVI/FD_INDCVIZA_2016.csv")
# path_to_indcvi <- insee.rp.data.2016::path_to_extdata("RP-detail/INDCVI/FD_INDCVI_2016.csv")
prepare_indcvi_datasets(path_to_indcvi) # dataset_prepare.R

## millesime 2020
path_to_indcvi <- insee.rp.data.2020::path_to_extdata("RP-detail/INDCVI/FD_INDCVIZA_2020.csv")
# path_to_indcvi <- insee.rp.data.2020::path_to_extdata("RP-detail/INDCVI/FD_INDCVI_2020.csv")
prepare_indcvi_datasets(path_to_indcvi) # dataset_prepare.R

