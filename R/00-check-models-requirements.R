## ****************************************************************************
## ----------------------------------------------------------------------------
## 0. recenser les variables nécessaires à l'utilisation de chaque modèle
## DONE: une grande partie des variables sont des variables ingénieurées
## il faudrait trouver une méthode pour vérifier les variables d'entrée

## TODO: il manquait les variables du fichier spatial
##   qui utilise notamment les labels des niveaux geo supra-communaux
## ces variables et leur type se trouvent dans les fichiers spatiaux historiques de spatialwplorer...
## Il faudrait créer un spatial_ref

#' Create the factor tibble used in `describe_data_modalities`
#'
#' @param x The unique levels of a factor
#'
#' @return A tibble containing the unique levels of a factor
#' @export
#'
#' @examples
#' model_cre$data %>%
#'   dplyr::pull(.data[["cmbl_cre"]]) %>%
#'   unique() %>%
#'   create_data_modalities_tibble()
create_data_modalities_tibble <- function(x) {
  tibble::tibble(
    # names = rep(names(.), times = length(levels(.))),
    class = rep(class(x), times = length(x)),
    levels = x
  )
}

#' Extract factor modalities of the models developped on rp indcvi 2011
#'
#' @param data A dataset
#'
#' @return A tibble giving the levels of the variables of the dataset
#' @export
#'
#' @examples
#' describe_data_modalities(model_cre$data)
#' describe_data_modalities(model_eq$data)
#' describe_data_modalities(model_eq_surf$data)
#' describe_data_modalities(model_iu$data)
describe_data_modalities <- function(data) {
  data_factor <- data %>%
    purrr::keep(is.factor) %>%
    purrr::map(\(x) unique(x) %>%
                 create_data_modalities_tibble() %>%
                 # dplyr::select(-1L) %>%
                 dplyr::arrange(levels)) %>%
    purrr::list_rbind(names_to = "var_code")
  data_numeric <- data %>%
    purrr::keep(is.numeric) %>%
    purrr::map(\(x) tibble::tibble(
      class = class(x),
      range = range(x) %>% as.character() %>% paste(collapse = "-")
    )) %>%
    purrr::list_rbind(names_to = "var_code")
  dplyr::bind_rows(data_factor, data_numeric)
}


#' Extract factor modalities of the models developped on rp indcvi 2011
#'
#' @param model A glm model
#'
#' @return A tibble giving the variables used by the models and their associated modalities
#' @export
#'
#' @examples
#' describe_model_modalities(model_cre)
#' describe_model_modalities(model_eq)
#' describe_model_modalities(model_eq_surf)
#' describe_model_modalities(model_iu)
#' purrr::map_dfr(
#'   list(model_cre, model_eq, model_eq_surf, model_iu),
#'   describe_model_modalities) %>%
#'   dplyr::distinct(var_code, levels, range)
describe_model_modalities <- function(model) {
  describe_data_modalities(model$data)
}

