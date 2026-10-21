## ****************************************************************************
## CREATION DU FICHIER DE DONNEES CONTENANT L'INFORMATION SEMANTIQUE
## QUE L'ON SOUHAITE CARTOGRAPHIER
## DANS CE CAS LE RP2013 INDCVI AVEC LES RECODAGES NECESSAIRES (base + spéciaux utilisés par les modèles)
## ****************************************************************************
## ETAPES:
## 0. recenser les variables nécessaires à l'utilisation de chaque modèle, ainsi que leur type et les modalités existantes !!
##   Elles ont pu varier d'un millésime à un autre !
##   Il faut bien identifier les modalités du rp indcvi 2011: c'est avec elles qu'ont été développés les modèles
## 1. Importer les variables d'intérêt
## 2. Augmenter le dataset avec les variables supplémentaires spécifiques au modèles
##    Recoder le dataset pour les variables qui ne sont pas encore recodées
## 3. Comparer au dataset de référence `semantic_ref`

# dput(names(mapuce::semantic_ref))
# # c("atome_indcvi", "iris_code", "arm_code", "cv_code", "ipondi",
# #   "agerev", "couple", "inper", "typl_ma", "chfl_3g", "cmbl_cre",
# #   "surf_6g_cont", "surf_nbpi_4g", "nperr_123", "stocd_2g")

## TODO
## - Vérifier que le dataset en sortie du pipeline possède bien toutes les variables
## d'entrée pour "spatialxplorer": `spatialxplorer::semantic_start`
## - rp_indcvi_2011 montre ipondi = NA lors de la conversion en numeric.
## Ce n'est pas le cas pour le millesime 2016 (qui est un csv plutôt qu'un txt)


## ****************************************************************************
## Pipeline spécifique pour les millésimes qui ont les mêmes propriétés que 2016 (notamment pour le découpage de SURF)
## Pipeline à partir du chemin du fichier rp indcvi 2016, avec transformation de la SURF pour coller au format des modèles mapuce 2011
## Le millésime 2011 semble être une singularité pour le découpage de SURF
#' Pipeline de preparation des variables mapuce
#'
#' Pipeline de preparation des variables mapuce a partir du rp indcvi 2016. Inclue l'étape de conversion de la variable SURF vers la forme utilisee par les modeles en 3 modalites comme pour le millesime 2011.
#' @param file_indcvi Either a path to a file, a connection, or literal data (either a single string or a raw vector).
#' Files ending in .gz, .bz2, .xz, or .zip will be automatically uncompressed. Files starting with ⁠http://⁠, ⁠https://⁠,  ⁠ftp://⁠, or ⁠ftps://⁠ will be automatically downloaded. Remote gz files can also be automatically downloaded and decompressed.
#' Literal data is most useful for examples and tests. To be recognised as literal data, the input must be either wrapped with I(), be a string containing at least one new line, or be a vector containing at least one string with a new line.
#'
#' @return A dataset with all necessary variables to compute mapuce models, as well as the intermediate variables used to compute them.
#' @export
#'
#' @examples
#' # Exemple with zone A of RP INDCVI 2016
#' pipeline_rp_indcvi_2016_to_mapuce(
#'   insee.rp.data.2020::path_to_extdata("RP-detail/INDCVI/FD_INDCVIZA_2020.csv")
#' )
pipeline_rp_indcvi_2016_to_mapuce <- function(file_indcvi) { # , file_decoupage_IRIS
  extract_rp_indcvi_for_mapuce(file = file_indcvi) %>%
    convert_rp_indcvi_levels_2016_to_2011() %>%
    transform_rp_indcvi_to_mapuce()
}



# semantic_2016_ref_levels <- semantic_2016_ref %>%
#   describe_data_modalities()
# semantic_2016_pipeline_levels <- semantic_2016_pipeline %>%
#   describe_data_modalities()
# ## Dans les factor, seul typl_ma montre des NA
# TODO Il faudrait vérifier les catégories d'iris retenues dans les fichiers d'entrée, mais ce n'est pas possible car l'information a disparu du semantic ref


# pipeline_spatial_to_mapuce <- function(file) { # , file_decoupage_IRIS
#   extract_rp_indcvi_for_mapuce(file = file_indcvi) %>%
#     convert_rp_indcvi_levels_2016_to_2011() %>%
#     transform_rp_indcvi_to_mapuce()
# }
