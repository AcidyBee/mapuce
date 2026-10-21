


## ****************************************************************************
## ----------------------------------------------------------------------------
## 2.pre Transforme la variable problématique pour revenir au codage de référence de rp indcvi 2011
## Pour 2016 seule la variable SURF montre plus de modalité en 2016 qu'en 2011.
##   On retrouve le même problème pour le millésime 2020.
## La conversion fonctionne pour les millesimes 2016 et 2020 qui montrent les mêmes modalités
# SURF: Surface en 3 classes
# !!! Attention: les modalités de la variable 'SURF' changent en 2013
# Si on souhaite utiliser le RP2013 pour projeter les modèles ayant été
# développés à partir des modalités du rp_2011, il faut donc recoder la variable selon le format 2011
## !!! ce n'est pas vrai pour 2012

#' Convert SURF variable format from rp indcvi 2016 to 2011
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi(). The dataset has a SURF variable with 7 levels, compared to 2011 millesime which has 3 modalities.
#'
#' @return A dataset with the SURF variable transformed to the 3 levels format of millesime 2011
#' @export
#'
#' @examples
#' # RP indcvi 2016 has the expected levels, except for SURF which is divided in 7 groups in 2016,
#' # compared to 3 in 2011 (when the models were developped)
#' unique(rp_indcvi_sampled_2011$SURF)
#' unique(rp_indcvi_sampled_2016$SURF)
#' convert_rp_indcvi_levels_2016_to_2011(rp_indcvi_sampled_2016)
convert_rp_indcvi_levels_2016_to_2011 <- function(data) {
  # Check if 'SURF' column exists in the data
  if (!"SURF" %in% colnames(data)) {
    stop("The 'SURF' column does not exist in the input data.")
  }
  data %>%
    dplyr::mutate(
      SURF = dplyr::case_when(
        # Recode values for SURF column
        .data$SURF %in% c("1", "2") ~ "1",  # Recode 1, 2 to 1
        .data$SURF %in% c("3", "4", "5") ~ "2",  # Recode 3, 4, 5 to 2
        .data$SURF %in% c("6", "7") ~ "3",  # Recode 6, 7 to 3
        TRUE ~ SURF  # Keep other values as they are
      )
    )
}

## ****************************************************************************
## ----------------------------------------------------------------------------
## 1.b Il faut retirer les modalités qui ne sont pas prises en compte dans les modèles
## TODO: finir la fonction
#' Drop levels of RP INDCVI not compatible with MAPUCE models
#'
#' @param data A RP INDCVI dataset of a given millesime as imported with extract_rp_indcvi()
#'
#' @return The same RP INDCVI dataset where the rows not compatible with MAPUCE models have been removed.
#' @export
#'
#' @examples
#' drop_na_levels_for_mapuce(rp_indcvi_sampled_2016)
drop_na_levels_for_mapuce <- function(data) {
  data %>%
    dplyr::filter(!.data$TYPL %in% c("3", "4", "5", "6", "Z")) %>%
    dplyr::filter(!.data$CHFL %in% c("X", "Z")) %>%
    dplyr::filter(!.data$CMBL %in% c("X", "Z")) %>%
    dplyr::filter(!.data$SURF %in% c("Z")) %>%
    dplyr::filter(!.data$NBPI %in% c("ZZ")) %>%
    dplyr::filter(!.data$NPERR %in% c("Z")) %>%
    dplyr::filter(!.data$STOCD %in% c("ZZ"))
}


## ****************************************************************************
## ----------------------------------------------------------------------------
## 2. Augmenter le dataset avec les variables supplémentaires spécifiques aux modèles

## ****************************************************************************
## TYPL: type de logement en 6 classes
## ----------------------------------------------------------------------------
# typl_ma: type de logement réduit à 2 classes:
#  - "1": "maison"
#  - "2": "appartement"
## Note 2024-12-28: dans les modèles de mapuce, on ne prend en compte que les 2 premiers types de logement
## maison ou appartement, les autres (minoritaires, environ 1%) devraient être filtrés pour éliminer les données correspondantes
## ----------------------------------------------------------------------------
# RP_spe$typl_ma <- as.character(RP$typl)
# RP_spe$typl_ma[!(RP_spe$typl_ma %in% c("1", "2"))] <- NA
#
# RP_spe$typl_ma <- factor(RP_spe$typl_ma,
#                          levels = c("1", "2"),
#                          labels = c("maison", "appartement"))
#
# # RP (France entière)
# # table(RP_spe$typl_ma, useNA = "ifany")
# #  maison appartement        <NA>
# # 4479130     4441189      105706

#' Augment the rp indcvi dataset with typl_ma variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with typl_ma variable.
#' @export
#'
#' @examples
#' augment_rp_indcvi_typl_ma(rp_indcvi_sampled_2011) %>%
#'   with(table(TYPL, typl_ma, useNA = "ifany"))
augment_rp_indcvi_typl_ma <- function(data) {
  if (!"TYPL" %in% names(data)) {
    stop("TYPL variable needs to be included in order to compute typl_ma")
  }
  # le test de correspondance des modalités a été déplacé:
  # il est réalisé en bloc après l'importation du dataset
  data %>%
    dplyr::mutate(typl_ma = dplyr::case_when(
      .data$TYPL %in% c("1", "2") ~ TYPL, # on ne conserve que les modalités correspondant à maison ou appartement
      # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset
      .data$TYPL %in% c("3", "4", "5", "6", "Z") ~ NA_character_, # Transformation explicite des modalités éliminées
      TRUE ~ NA_character_
    ) %>%
      factor(levels = c("1", "2"), labels = c("maison", "appartement"))
    )
}

## ****************************************************************************
## CHFL: Chauffage central du logement (France métropolitaine): en 4 classes
## ----------------------------------------------------------------------------
# chfl_3g: type de chauffage réduit à 2 classes:
#  - "collectif"
#  - "electricite"
#  - "autres"
## ----------------------------------------------------------------------------
# rp2011_def %>%
#   dplyr::filter(var_code == "CHFL")
#
# RP_spe$chfl_3g <- as.character(RP$chfl)
#
# RP_spe$chfl_3g[!(RP_spe$chfl_3g %in% c("1", "2", "3", "4"))] <- NA
# RP_spe$chfl_3g[RP_spe$chfl_3g %in% c("2")] <- "4"
#
# # RP_spe$chfl_3g[RP_spe$chfl_3g %in% c("1")] <- "collectif"
# # RP_spe$chfl_3g[RP_spe$chfl_3g %in% c("3")] <- "electrique"
# # RP_spe$chfl_3g[RP_spe$chfl_3g %in% c("2", "4")] <- "autres"
#
#
# RP_spe$chfl_3g <- factor(RP_spe$chfl_3g,
#                          levels = c("1", "3", "4"),
#                          labels = c("collectif", "electrique", "autres"))
#
# # table(RP_spe$chfl_3g, RP$chfl, useNA = "ifany")
# #                  1       2       3       4       Z
# # collectif  1890022       0       0       0       0
# # electrique       0       0 2525426       0       0
# # autres           0 3489721       0  861367       0
# # <NA>             0       0       0       0  259489



#' Augment the rp indcvi dataset with chfl_3g variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with chfl_3g variable.
#' @export
#'
#' @examples
#' augment_rp_indcvi_chfl_3g(rp_indcvi_sampled_2011) %>%
#'   with(table(CHFL, chfl_3g, useNA = "ifany"))
augment_rp_indcvi_chfl_3g <- function(data) {
  if (!"CHFL" %in% names(data)) {
    stop("CHFL variable needs to be included in order to compute chfl_3g.")
  }
  data %>%
    dplyr::mutate(chfl_3g = dplyr::case_when(
      .data$CHFL == "1" ~ "collectif",
      .data$CHFL == "3" ~ "electrique",
      .data$CHFL %in% c("2", "4") ~ "autres",
      .data$CHFL %in% c("X", "Z") ~ NA_character_,
      TRUE ~ NA_character_    # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset (mais se sont les X et les Z)
    ) %>%
      factor(levels = c("collectif", "electrique", "autres"))
    )
}

## ****************************************************************************
## CMBL: Combustible principal du logement (France métropolitaine):
## ----------------------------------------------------------------------------
# cmbl_cre: type de chauffage réduit à 3 classes:
#  - "electricite"
#  - "gaz bouteille ou citerne"
#  - "autres"
## ----------------------------------------------------------------------------

# RP_spe$cmbl_cre <- as.character(RP$cmbl)
#
# RP_spe$cmbl_cre[!(RP_spe$cmbl_cre %in% c("1", "2", "3", "4", "5", "6"))] <- NA
# RP_spe$cmbl_cre[RP_spe$cmbl_cre %in% c("1", "2", "3")] <- "6"
#
# # RP_spe$cmbl_cre[RP_spe$cmbl_cre %in% c("4")] <- "electricite"
# # RP_spe$cmbl_cre[RP_spe$cmbl_cre %in% c("5")] <- "gaz bouteilles ou citerne"
# # RP_spe$cmbl_cre[RP_spe$cmbl_cre %in% c("1", "2", "3", "6")] <- "autres"
#
# RP_spe$cmbl_cre <- factor(RP_spe$cmbl_cre,
#                           levels = c("4", "5", "6"),
#                           labels = c("electricite", "gaz bouteilles ou citerne", "autres"))
#
# # table(RP_spe$cmbl_cre, RP$cmbl, useNA = "ifany")
# #                                 1       2       3       4       5       6       Z
# # electricite                     0       0       0 2907878       0       0       0
# # gaz bouteilles ou citerne       0       0       0       0  152668       0       0
# # autres                     567897 3247966 1043341       0       0  846786       0
# # <NA>                            0       0       0       0       0       0  259489

#' Augment the rp indcvi dataset with chfl_3g variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with chfl_3g variable.
#' @export
#'
#' @examples
#' augment_rp_indcvi_cmbl_cre(rp_indcvi_sampled_2011) %>%
#'   with(table(CMBL, cmbl_cre, useNA = "ifany"))
augment_rp_indcvi_cmbl_cre <- function(data) {
  if (!"CMBL" %in% names(data)) {
    stop("CMBL variable needs to be included in order to compute cmbl_cre.")
  }
  data %>%
    dplyr::mutate(cmbl_cre = dplyr::case_when(
      .data$CMBL == "4" ~ "electricite",
      .data$CMBL == "5" ~ "gaz bouteilles ou citerne",
      .data$CMBL %in% c("1", "2", "3", "6") ~ "autres",
      .data$CMBL %in% c("X", "Z") ~ NA_character_,
      TRUE ~ NA_character_    # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset (mais se sont les X et les Z)
    ) %>%
      factor(levels = c("electricite", "gaz bouteilles ou citerne", "autres"))
    )
}

## ****************************************************************************
# NBPI: Nombre de pieces en 20 classes
## ----------------------------------------------------------------------------
# NBPI_cont: Nombre de pieces en continu:
# la modalité 20 et + est transformée en 20

# RP_spe$nbpi_cont <- as.integer(as.character(RP$nbpi))
#
# ## RP pour Toulouse
# # sort(unique(RP_spe$nbpi_cont))
# # [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 17 19 20
#
# # sort(unique(RP$nbpi))
# # [1] 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 17 19 20
# # Levels: 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 ZZ

#' Augment the rp indcvi dataset with nbpi_cont variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with nbpi_cont variable.
#' @export
#'
#' @examples
#' augment_rp_indcvi_nbpi_cont(rp_indcvi_sampled_2011) %>%
#'   with(table(NBPI, nbpi_cont, useNA = "ifany"))
augment_rp_indcvi_nbpi_cont <- function(data) {
  if (!"NBPI" %in% names(data)) {
    stop("NBPI variable needs to be included in order to compute nbpi_cont")
  }
  data %>%
    dplyr::mutate(nbpi_cont = as.integer(.data$NBPI))
}


## ----------------------------------------------------------------------------
## Séparation de surf en 6g:

# RP_spe$surf_6g_cont <- NA
# RP_spe$surf_6g_cont[(RP_spe$surf == "1") & (RP_spe$nbpi_cont < 2)] <- "1"
# RP_spe$surf_6g_cont[(RP_spe$surf == "1") & (RP_spe$nbpi_cont >= 2)] <- "2"
# RP_spe$surf_6g_cont[(RP_spe$surf == "2") & (RP_spe$nbpi_cont < 4)] <- "3"
# RP_spe$surf_6g_cont[(RP_spe$surf == "2") & (RP_spe$nbpi_cont >= 4)] <- "4"
# RP_spe$surf_6g_cont[(RP_spe$surf == "3") & (RP_spe$nbpi_cont < 6)] <- "5"
# RP_spe$surf_6g_cont[(RP_spe$surf == "3") & (RP_spe$nbpi_cont >= 6)] <- "6"
#
# ## Variable en continu:
# RP_spe$surf_6g_cont <- as.integer(RP_spe$surf_6g)


#' Augment the rp indcvi dataset with surf_6g_cont variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with surf_6g_cont variable.
#' @export
#'
#' @examples
#' rp_indcvi_sampled_2011 %>%
#'   augment_rp_indcvi_nbpi_cont %>%
#'   augment_rp_indcvi_surf_6g_cont() %>%
#'   with(table(SURF, surf_6g_cont, useNA = "ifany"))
augment_rp_indcvi_surf_6g_cont <- function(data) {
  if (!all(c("SURF", "nbpi_cont") %in% names(data))) {
    stop("SURF & nbpi_cont variable needs to be included in order to compute surf_6g_cont")
  }
  data %>%
    dplyr::mutate(surf_6g_cont = dplyr::case_when(
      .data$SURF == "1" & .data$nbpi_cont < 2 ~ 1L,
      .data$SURF == "1" & .data$nbpi_cont >= 2 ~ 2L,
      .data$SURF == "2" & .data$nbpi_cont < 4 ~ 3L,
      .data$SURF == "2" & .data$nbpi_cont >= 4 ~ 4L,
      .data$SURF == "3" & .data$nbpi_cont < 6 ~ 5L,
      .data$SURF == "3" & .data$nbpi_cont >= 6 ~ 6L,
      .data$SURF == "Z" ~ NA_integer_,
      TRUE ~ NA_integer_    # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset (mais se sont les X et les Z)
    ))
}


## ----------------------------------------------------------------------------
## création de la variable surf_nbpi_4g qui réuni les groupes extrêmes de surf_6g_cont
# RP_spe$surf_nbpi_4g <- NA
# RP_spe$surf_nbpi_4g[RP_spe$surf == "1"] <- "1"
# RP_spe$surf_nbpi_4g[(RP_spe$surf == "2") & (RP_spe$nbpi_cont < 4)] <- "2"
# RP_spe$surf_nbpi_4g[(RP_spe$surf == "2") & (RP_spe$nbpi_cont >= 4)] <- "3"
# RP_spe$surf_nbpi_4g[RP_spe$surf == "3"] <- "4"
#
# RP_spe$surf_nbpi_4g <- factor(RP_spe$surf_nbpi_4g)
#
# # with(RP_spe, table(surf_6g_cont, surf_nbpi_4g, useNA = "ifany"))
# #             surf_nbpi_4g
# # surf_6g_cont       1       2       3       4
# #            1  648230       0       0       0
# #            2  531086       0       0       0
# #            3       0 2760459       0       0
# #            4       0       0 2738661       0
# #            5       0       0       0 1291211
# #            6       0       0       0 1056378


#' Augment the rp indcvi dataset with surf_nbpi_4g variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with surf_nbpi_4g variable.
#' @export
#'
#' @examples
#' rp_indcvi_sampled_2011 %>%
#'   augment_rp_indcvi_nbpi_cont %>%
#'   augment_rp_indcvi_surf_nbpi_4g() %>%
#'   with(table(SURF, surf_nbpi_4g, useNA = "ifany"))
augment_rp_indcvi_surf_nbpi_4g <- function(data) {
  if (!all(c("SURF", "nbpi_cont") %in% names(data))) {
    stop("SURF & nbpi_cont variables need to be included in order to compute surf_nbpi_4g")
  }
  data %>%
    dplyr::mutate(surf_nbpi_4g = dplyr::case_when(
      .data$SURF == "1" ~ "1",
      .data$SURF == "2" & .data$nbpi_cont < 4 ~ "2",
      .data$SURF == "2" & .data$nbpi_cont >= 4 ~ "3",
      .data$SURF == "3" ~ "4",
      .data$SURF == "Z" ~ NA_character_,
      TRUE ~ NA_character_    # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset (mais se sont les X et les Z)
    ) %>%
      factor(levels = c("1", "2", "3", "4"))
    )
}

## ****************************************************************************
## nperr en 3 classes: 1, 2, 3 ou +
## -----------------------------------------------------------------
# NPERR: Nombre de personnes du ménage (regroupé):
# Les modalités 6 ou plus sont regroupées: autant garder la variable INPER
# - 1 : Une personne
# - 2 : 2 personnes
# - 3 : 3 personnes
# - 4 : 4 personnes
# - 5 : 5 personnes
# - 6 : 6 personnes ou plus
# - Z : Hors logement ordinaire

# ## -----------------------------------------------------------------
# # En 3 groupes: 1, 2, 3+
# RP_spe$nperr_123 <- as.character(RP$nperr)
# RP_spe$nperr_123[RP_spe$nperr_123 %in% c("1")] <- "1"
# RP_spe$nperr_123[RP_spe$nperr_123 %in% c("2")] <- "2"
# RP_spe$nperr_123[RP_spe$nperr_123 %in% c("3", "4", "5", "6")] <- "3 ou +"
#
# RP_spe$nperr_123 <- factor(RP_spe$nperr_123)
#
# # RP
# # table(RP_spe$nperr_123, RP$nperr, useNA = "ifany")
# #              1       2       3       4       5       6
# # 1      3267501       0       0       0       0       0
# # 2            0 2861302       0       0       0       0
# # 3 ou +       0       0 1276834 1056593  402528  161267

#' Augment the rp indcvi dataset with nperr_123 variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with nperr_123 variable.
#' @export
#'
#' @examples
#' rp_indcvi_sampled_2011 %>%
#'   augment_rp_indcvi_nperr_123() %>%
#'   with(table(NPERR, nperr_123, useNA = "ifany"))
augment_rp_indcvi_nperr_123 <- function(data) {
  if (!"NPERR" %in% names(data)) {
    stop("NPERR variable needs to be included in order to compute nperr_123")
  }
  data %>%
    dplyr::mutate(nperr_123 = dplyr::case_when(
      .data$NPERR == "1" ~ "1",
      .data$NPERR == "2" ~ "2",
      .data$NPERR %in% c("3", "4", "5", "6") ~ "3 ou +",
      .data$NPERR == "Z" ~ NA_character_,
      TRUE ~ NA_character_    # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset (mais se sont les X et les Z)
    ) %>%
      factor(levels = c("1", "2", "3 ou +"))
    )
}


## ****************************************************************************
## stocd_2g: Statut d'occupation modifié (en 2 postes)
## - propriétaire: oui/non

# RP_spe$stocd_2g <- as.character(RP$stocd)
# RP_spe$stocd_2g[RP_spe$stocd_2g %in% "10"] <- "proprietaires"
# RP_spe$stocd_2g[RP_spe$stocd_2g %in% c("00", "21", "22", "23", "30")] <- "autres"
#
# RP_spe$stocd_2g <- factor(RP_spe$stocd_2g,
#                           levels = c("proprietaires", "autres"))
#
# # table(RP_spe$stocd_2g, RP$stocd, useNA = "ifany")
# #                 10   21   22   23   30
# # proprietaires 1063    0    0    0    0
# # autres           0  449  273  101   64
#
# # table(RP_spe$stocd_2g, RP$stocd, useNA = "ifany")
# #                    10      21      22      23      30
# # proprietaires 4789332       0       0       0       0
# # autres              0 2218669 1498806  295776  223442


#' Augment the rp indcvi dataset with stocd_2g variable
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The same rp indcvi dataset augmented with stocd_2g variable.
#' @export
#'
#' @examples
#' rp_indcvi_sampled_2011 %>%
#'   augment_rp_indcvi_stocd_2g() %>%
#'   with(table(STOCD, stocd_2g, useNA = "ifany"))
augment_rp_indcvi_stocd_2g <- function(data) {
  if (!"STOCD" %in% names(data)) {
    stop("STOCD variable needs to be included in order to compute stocd_2g")
  }
  data %>%
    dplyr::mutate(stocd_2g = dplyr::case_when(
      .data$STOCD == "10" ~ "proprietaires",
      .data$STOCD %in% c("00", "21", "22", "23", "30") ~ "autres",
      .data$STOCD == "ZZ" ~ NA_character_,
      TRUE ~ NA_character_    # les autres modalités sont éliminées, il faudrait les filtrer hors du dataset (mais se sont les X et les Z)
    ) %>%
      factor(levels = c("proprietaires", "autres"))
    )
}


## ****************************************************************************
## Cumule la création de toutes les variables nécessaires aux modèles de mapuce

#' Augment the rp indcvi dataset with all the variables required to compute mapuce models
#'
#' @param data A rp indcvi dataset with unified geogrphical colnames for
#' at least IRIS (iris_code) and CANTVILLE (cv_code)
#'
#' @importFrom insee.rp ins_augment_rp_indcvi_atome_indcvi
#'
#' @return The same rp indcvi dataset augmented with all the variables required
#'  to compute mapuce models, and to project results at atome_indcvi scale.
#' @export
#'
#' @examples
#' rp_indcvi_sampled_2011 %>%
#'   augment_rp_indcvi_for_mapuce()
augment_rp_indcvi_for_mapuce <- function(data) {
  data %>%
    augment_rp_indcvi_typl_ma() %>%
    augment_rp_indcvi_chfl_3g() %>%
    augment_rp_indcvi_cmbl_cre() %>%
    augment_rp_indcvi_nbpi_cont() %>%
    augment_rp_indcvi_surf_6g_cont() %>%
    augment_rp_indcvi_surf_nbpi_4g() %>%
    augment_rp_indcvi_nperr_123() %>%
    augment_rp_indcvi_stocd_2g() %>%
    ## adds atome_indcvi (package insee.rp): maj 2025-04-07: fonction modifiée pour n'utiliser que le dataset rp indcvi, et pas le decoupage admin...
    insee.rp::ins_augment_rp_indcvi_atome_indcvi() %>%
    ## atome_indcvi est placé en 1ere colonne
    dplyr::relocate(.data$atome_indcvi, .data$atome_indcvi_type, .before = 1L)
}

## ****************************************************************************
## ****************************************************************************
## Recode les dernières variables nécessaires pour l'application des modèles mapuce
# #' @examples
# #' describe_model_modalities(model_cre): agerev (integer)
# #' describe_model_modalities(model_eq): couple (factor oui non)
# #' describe_model_modalities(model_eq_surf): agerev (integer)
# #' describe_model_modalities(model_iu): couple, agerev (integer), inper (integer)


#' Recode rp indcvi dataset to make it fit the mapuce models standard
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The rp indcvi dataset recoded. Recode `couple` as a factor with `labels = c("oui", "non")`
#' @export
#'
#' @examples
#' rp_indcvi_sampled_2011 %>%
#'   augment_rp_indcvi_for_mapuce() %>%
#'   recode_rp_indcvi_for_mapuce()
recode_rp_indcvi_for_mapuce <- function(data) {
  data %>%
    # rename rp indcvi var to lower case
    dplyr::rename_with(tolower) %>%
    # ## rename geographic levels to the codes used in the spatialxplorer app
    # maj 2025-04-03 déjà réalisé par l'unification des codes géo dans `insee.rp::ins_extract_rp_col`
    # dplyr::rename(
    #   iris_code = "iris",
    #   arm_code = "arm",
    #   cv_code = "cantville"
    # ) %>%
    # recode couple as a factor with labels = c("oui", "non")
    dplyr::mutate(
      agerev = as.integer(.data$agerev), # maj 2025-04-29: importé en tant que character...à transformer en integer
      inper = as.integer(.data$inper),   # maj 2025-04-29: importé en tant que character...
      couple = factor(.data$couple, levels = c("1", "2"), labels = c("oui", "non"))
    ) %>%
    # discard columns not used in the models or in the app
    # maj 2025-03-04: il faut conserver "iris_type" car il est nécessaire pour créer atome_indcvi
    dplyr::select(! dplyr::all_of(
      c("nummi", "typl", "chfl", "cmbl",
        "surf", "nbpi", "nperr", "stocd", "nbpi_cont")
    ))
}


## ****************************************************************************
## Création d'un pipeline
## Pipeline général à partir d'un dataset rp indcvi

#' Augment & Recode rp indcvi dataset to make it fit the mapuce models standard
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi()
#'
#' @return The rp indcvi dataset augmented & recoded.
#' @export
#'
#' @examples
#' transform_rp_indcvi_to_mapuce(rp_indcvi_sampled_2011)
transform_rp_indcvi_to_mapuce <- function(data) {
  data %>%
    drop_na_levels_for_mapuce() %>%
    augment_rp_indcvi_for_mapuce() %>%
    recode_rp_indcvi_for_mapuce()
}

