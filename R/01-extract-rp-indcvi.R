## ****************************************************************************
## ----------------------------------------------------------------------------
## 1. Importer les variables d'intérêt
## - Il semble que le fichier RP indcvi 2011 avait une particularité pour la variable SURF:
## elle avait 3 modalités plutôt que 6 ou 7 les autres années !!!!
## - Les variables d'intérêt de départ et leur type sont crées dans le fichier `data-raw/sysdata.R`,
##   puis stockées en tant que: `vars_rp_indcvi_for_mapuce_names` & `vars_rp_indcvi_for_mapuce_types`
##   dans le fichier `R/sysdata.rda`
## - Ces variables sont: c("IRIS", "CATIRIS", "CANTVILLE", "ARM", # Pour localiser la zone d'étude
## "NUMMI", "IPONDI",  # IPONDI pour gérer la pondération des indicateurs
## "TYPL", "CHFL", "CMBL", "SURF", "NBPI", "AGEREV", "INPER", "NPERR", "COUPLE", "STOCD", # pour les modèles ou la création des nouvelles variables
## "LPRM", "METRODOM") # pour la sélection de la zone métropole & uniquement la personne de référence du ménage

## Le fichier de définition des variables pourrait être obtenu automatiquement pour chaque millésime
## à partir du fichier de définition accompagnant le fichier détail, mais sa forme a changé entre les millésimes.
## Je n'ai pas approfondi, et j'ai préféré travailler directement sur les fichiers détail importés...
# ## Chargement du fichier de définition des variables
# rp2011_def <- readr::read_csv("/Users/Alexis/Documents/Travail/R/Projects/INSEE/RP/rp_def/rp2011_def.csv",
#                                col_names = TRUE, col_types = "ccccclc")
#
# # rp2016_def <- readr::read_csv2(path_to_file("RP2016_INDCVI_csv/varmod_INDCVI_2016.csv"),
# #                               col_names = TRUE, col_types = "cccccc") %>%
# #   dplyr::rename(
# #     var_code = "COD_VAR",
# #     var_lib = "LIB_VAR",
# #     mod_code = "COD_MOD",
# #     mod_lib = "LIB_MOD",
# #     var_type = "TYPE_VAR"
# #   )
# #
# # rp2011_def %>%
# #   dplyr::filter(var_code == "INPER") %>%
# #   dplyr::pull(mod_code)
# # rp2016_def %>%
# #   dplyr::filter(var_code == "INPER") %>%
# #   dplyr::pull(mod_code)
# #
# # compare_modalities <- function(data_1, data_2, var_name) {
# #
# # }

# #' Extract RP INDCVI vars mandatory to mapuce calculations
# #'
# #' @param path A path to the RP INDCVI file. A default path exists for
# #'   RP INDCVI 2016 ZONE A file stored in the mapuce package.
# #' @importFrom vroom vroom
# #' @importFrom dplyr all_of filter select mutate
# #' @importFrom stringr str_replace
# #'
# #' @return A version of the RP INDCVI dataset as required to mapuce calculations.
# #' @export
# #'
# #' @examples
# #' extract_rp_indcvi()
# extract_rp_indcvi <- function(path = path_to_file("RP_INDCVI/FD_INDCVIZA_2016.csv")) { # , n_max = Inf
#   ## Importation des variables d'intérêt
#   vroom::vroom(
#     file = path,
#     delim = ";",
#     col_types = vars_rp_indcvi_for_mapuce_types,
#     col_select = dplyr::all_of(vars_rp_indcvi_for_mapuce_names)#,
#     # n_max = n_max
#   ) %>%
#     ## filter des observations correspondant à la personne de ref du menage + metropole
#     dplyr::filter(.data$LPRM == "1", .data$METRODOM == "M") %>%
#     ## Elimination des variables LPRM & METRODOM
#     dplyr::select(!dplyr::all_of(c("LPRM", "METRODOM"))) %>%
#     ## Le fichier de 2011 sur lequel a été créé le modèle n'a pas le même format que les fichiers récents
#     ## en plus d'être au format txt, il utilise comme séparateur décimal pour ipondi la virgule `,` plutôt que le point `.`
#     ## remplacement des `,` dans ipondi, puis conversion en numeric
#     dplyr::mutate(IPONDI = stringr::str_replace(.data$IPONDI, ",", "\\.") %>%
#                     as.numeric())
# }
## maj 2025-04-03: utilisation de la la fonction du package insee.rp pour l'importation
#' Extract RP INDCVI vars mandatory to mapuce calculations
#'
#' @inheritParams vroom::vroom
#'
#' @importFrom insee.rp ins_extract_rp_col
#' @importFrom dplyr all_of filter select mutate
#' @importFrom stringr str_replace
#'
#' @return A version of the RP INDCVI dataset as required to mapuce calculations.
#' @export
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' path_to_indcvi <- insee.rp.data.2020::path_to_extdata("RP-detail/INDCVI/FD_INDCVI_2020.csv")
#' data_extracted_mapuce_2020 <- extract_rp_indcvi_for_mapuce(path_to_indcvi)
#' }
#'
extract_rp_indcvi_for_mapuce <- function(file) {     # , col_select = NULL, col_types = NULL
  ## Importation des variables d'intérêt
  insee.rp::ins_extract_rp_col(
    file = file,
    col_types = vars_rp_indcvi_for_mapuce_types,
    col_select = vars_rp_indcvi_for_mapuce_names
  ) %>%
    # vroom::vroom(
    #   file = path,
    #   delim = ";",
    #   col_types = vars_rp_indcvi_for_mapuce_types,
    #   col_select = dplyr::all_of(vars_rp_indcvi_for_mapuce_names)#,
    #   # n_max = n_max
    # ) %>%
    ## filter des observations correspondant à la personne de ref du menage + metropole
    dplyr::filter(.data$LPRM == "1", .data$METRODOM == "M") %>%
    ## Elimination des variables LPRM & METRODOM
    dplyr::select(!dplyr::all_of(c("LPRM", "METRODOM"))) %>%
    ## Le fichier de 2011 sur lequel a été créé le modèle n'a pas le même format que les fichiers récents
    ## en plus d'être au format txt, il utilise comme séparateur décimal pour ipondi la virgule `,` plutôt que le point `.`
    ## remplacement des `,` dans ipondi, puis conversion en numeric
    dplyr::mutate(IPONDI = stringr::str_replace(.data$IPONDI, ",", "\\.") %>%
                    as.numeric())
}

## TODO 2025-04-13
# Package mapuce: Afin d'adapter l'emprise du fichier spatial,
# il faut identifier les entités géographiques qui ne sont pas prises en compte dans le modèle mapuce.
# En effet, du fait de l'agrégation à l'atome_indcvi, on risque sinon de représenter des résultats sur des zones qui ne sont pas calculées dans les modèles
#
# 1. Créer une fonction qui élimine les observations hors modèle mapuce discard_rows_oo_models_mapuce:
#   - METRODOM
#   - LPRM == "1"
#   - TYPL %in% c("1", "2")
#  En fait on va faire le contraire: on conserve les lignes qui sont conservées dans les modèles, et on compare aux dataset total
## Toutes les lignes (distinctes) qui sont uniquement dans le dataset global doivent être éliminées
# 2. Créer une fonction qui identifie les entités géographiques qui disparaissent du fait de l'élimination précédente
#   - Comparaison des entités géographiques distinctes du dataset avant et après discard
#   - sortie list: cv_code, com_arm_code (5 premiers digits hors Z), iris_code, et atome_code (pour voir s'il est utilisable à la place des 3 autres)
# 3. Comparaison des entités éliminées aux iris hors rp logemt

muce_filter_rows_in_models <- function(data) {
  data %>%
    ## filter des observations correspondant à la personne de ref du menage + metropole
    dplyr::filter(.data[["LPRM"]] == "1", .data[["METRODOM"]] == "M", .data[["TYPL"]] %in% c("1", "2"))
}

muce_indentify_entities_oo_models <- function(data) {

  # Input validation
  if (!is.data.frame(data)) {
    stop("Input must be a data.frame or data.table")
  }

  required_cols <- c("iris_code", "iris_type", "cv_code")
  if (!all(required_cols %in% names(data))) {
    stop("Input data must contain columns: ", paste(required_cols, collapse = ", "))
  }

  data_mapuce <- data %>%
    muce_filter_rows_in_models() %>%
    dplyr::distinct(c("iris_code", "iris_type", "cv_code"))
  data <- data %>%
    dplyr::distinct(c("iris_code", "iris_type", "cv_code"))

  iris_oo_models <- setdiff(unique(data[["iris_code"]]), unique(data_mapuce[["iris_code"]]))

  data_cv <- data %>%
    dplyr::filter(.data$iris_type == "Z")
  data_mapuce_cv <- data_mapuce %>%
    dplyr::filter(.data$iris_type == "Z")
  cv_oo_mapuce <- setdiff(unique(data_cv[["cv_code"]]), unique(data_mapuce_cv[["cv_code"]]))

  data_com <- data %>%
    dplyr::filter(.data$iris_type == "X")
  data_mapuce_com <- data_mapuce %>%
    dplyr::filter(.data$iris_type == "X")
  com_oo_models <- setdiff(
    unique(stringr::str_sub(data_com[["iris_code"]], 1, 5)),
    unique(stringr::str_sub(data_mapuce_com[["iris_code"]], 1, 5))
  )

  list(
    iris_code = iris_oo_models,
    com_code = com_oo_models,
    cv_code = cv_oo_mapuce
  )
}

## Les données sont un fichier indcvi, as obtained from
# insee.rp::ins_extract_rp_col(
#   file = file,
#   col_types = vars_rp_indcvi_for_mapuce_types,
#   col_select = vars_rp_indcvi_for_mapuce_names
# )
# muce_indentify_entities_oo_models <- function(data) {
#   data_mapuce <- data %>%
#     muce_filter_rows_in_models() %>%
#     dplyr::distinct(c("iris_code", "iris_typ", "cv_code"))
#   data <- data %>%
#     dplyr::distinct(c("iris_code", "iris_typ", "cv_code"))
#
#   iris_oo_models <- setdiff(unique(data[["iris_code"]]), unique(data_mapuce[["iris_code"]]))
#
#   data_cv <- data %>%
#     dplyr::filter(iris_typ == "Z")
#   data_mapuce_cv <- data_mapuce %>%
#     dplyr::filter(iris_typ == "Z")
#   cv_oo_mapuce <- setdiff(unique(data_cv[["cv_code"]]), unique(data_mapuce_cv[["cv_code"]]))
#
#   data_com <- data %>%
#     dplyr::filter(iris_typ == "X")
#   data_mapuce_com <- data_mapuce %>%
#     dplyr::filter(iris_typ == "X")
#   com_oo_models <- setdiff(
#     unique(stringr::str_sub(data_com[["iris_code"]], 1, 5)),
#     unique(stringr::str_sub(data_mapuce_com[["iris_code"]], 1, 5))
#   )
#
#   list(
#     iris_code = iris_oo_models,
#     com_code = com_oo_models,
#     cv_code = cv_oo_mapuce
#        )
# }

# muce_indentify_entities_oo_models_dt <- function(data) {
#   # Convert to data.table if not already
#   data_dt <- data.table::as.data.table(data)
#   data_mapuce_dt <- data.table::as.data.table(muce_filter_rows_in_models(data))
#
#   # Get distinct rows (more efficient in data.table)
#   data_dt <- unique(data_dt[, .(iris_code, iris_typ, cv_code)])
#   data_mapuce_dt <- unique(data_mapuce_dt[, .(iris_code, iris_typ, cv_code)])
#
#   # Get unique iris codes
#   iris_codes <- data_dt[, unique(iris_code)]
#   iris_codes_mapuce <- data_mapuce_dt[, unique(iris_code)]
#
#   # Helper function to process each type
#   process_type <- function(typ, dt, dt_mapuce, substr_len = NULL) {
#     # Filter by type
#     filtered <- dt[iris_typ == typ]
#     filtered_mapuce <- dt_mapuce[iris_typ == typ]
#
#     # Get the first column name (either iris_code or cv_code)
#     col_name <- names(filtered)[1]
#
#     if (!is.null(substr_len)) {
#       # Apply string substring if needed
#       filtered[, (col_name) := stringr::str_sub(get(col_name), 1, substr_len)]
#       filtered_mapuce[, (col_name) := stringr::str_sub(get(col_name), 1, substr_len)]
#     }
#
#     # Return difference
#     setdiff(filtered[, unique(get(col_name))],
#             filtered_mapuce[, unique(get(col_name))])
#   }
#
#   # Return results
#   list(
#     iris_code = setdiff(iris_codes, iris_codes_mapuce),
#     com_code = process_type("X", data_dt, data_mapuce_dt, 5),
#     cv_code = process_type("Z", data_dt[, .(cv_code, iris_typ)],
#                            data_mapuce_dt[, .(cv_code, iris_typ)])
#   )
# }


## TODO: trouver la notation convenable pour datatable
# muce_identify_entities_oo_models_dt: no visible binding for global
# variable ‘iris_code’
#' Identify entities not present in MAPUCE models
#'
#' @param data A data.frame or data.table containing entity information
#' @return A list with three components:
#' \describe{
#'   \item{iris_code}{Vector of IRIS codes not in MAPUCE models}
#'   \item{com_code}{Vector of commune codes not in MAPUCE models}
#'   \item{cv_code}{Vector of CV codes not in MAPUCE models}
#' }
#' @import data.table
#' @importFrom stringr str_sub
#' @export
muce_identify_entities_oo_models_dt <- function(data) {
  # Input validation
  if (!is.data.frame(data)) {
    stop("Input must be a data.frame or data.table")
  }

  required_cols <- c("iris_code", "iris_type", "cv_code")
  if (!all(required_cols %in% names(data))) {
    stop("Input data must contain columns: ", paste(required_cols, collapse = ", "))
  }

  # Convert to data.table (no copy if already data.table)
  data_dt <- data.table::as.data.table(data)
  data_mapuce_dt <- data.table::as.data.table(muce_filter_rows_in_models(data))

  # Key operations for performance
  data.table::setkeyv(data_dt, required_cols)
  data.table::setkeyv(data_mapuce_dt, required_cols)

  # Get distinct rows using data.table's optimized unique
  data_dt <- unique(data_dt, by = required_cols)
  data_mapuce_dt <- unique(data_mapuce_dt, by = required_cols)

  # Process IRIS codes
  iris_diff <- data_dt[!data_mapuce_dt, on = "iris_code",
                       unique(iris_code), nomatch = 0]

  # Process CV codes (type Z)
  cv_diff <- data_dt[iris_type == "Z" & !data_mapuce_dt[iris_type == "Z"],
                     on = "cv_code",
                     unique(cv_code), nomatch = 0]

  # Process commune codes (type X)
  com_diff <- data_dt[iris_type == "X", .(com_code = substr(iris_code, 1, 5))]
  com_mapuce_diff <- data_mapuce_dt[iris_type == "X", .(com_code = substr(iris_code, 1, 5))]
  com_diff <- com_diff[!com_mapuce_diff, on = "com_code",
                       unique(com_code), nomatch = 0]

  # Return results
  list(
    iris_code = iris_diff,
    com_code = com_diff,
    cv_code = cv_diff
  )
}

# #' Identify Entities Not Present in MAPUCE Models (Optimized for Large Datasets)
# #'
# #' @description This function efficiently identifies IRIS, commune, and CV codes that are not present in MAPUCE models.
# #' It is optimized for large datasets using `data.table`, chunked processing, and parallel computation.
# #'
# #' @param data A `data.frame` or `data.table` containing columns: `iris_code`, `iris_typ`, `cv_code`.
# #' @param chunk_size Numeric. Number of rows to process at a time (for very large datasets). Default: `1e6` (1M rows).
# #' @param n_workers Numeric. Number of CPU cores for parallel processing. Default: `1` (sequential).
# #' @param show_progress Logical. Should a progress bar be shown? Default: `TRUE`.
# #'
# #' @return A list with three components:
# #' \itemize{
# #'   \item `iris_code` - Vector of IRIS codes not in MAPUCE models
# #'   \item `com_code` - Vector of commune codes not in MAPUCE models
# #'   \item `cv_code` - Vector of CV codes not in MAPUCE models
# #' }
# #'
# #' @import data.table
# #' @importFrom parallel detectCores makeCluster stopCluster
# #' @importFrom doParallel registerDoParallel
# #' @importFrom foreach foreach %dopar%
# #' @importFrom progress progress_bar
# #' @importFrom stringr str_sub
# #' @export
# muce_identify_entities_oo_models <- function(
#   data,
#   chunk_size = 1e6,
#   n_workers = 1,
#   show_progress = TRUE
# ) {
#   ### 1. Input Validation ###
#   if (!is.data.frame(data)) {
#     stop("Input must be a data.frame or data.table.")
#   }
#
#   required_cols <- c("iris_code", "iris_typ", "cv_code")
#   missing_cols <- setdiff(required_cols, names(data))
#   if (length(missing_cols) > 0) {
#     stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
#   }
#
#   ### 2. Convert to data.table ###
#   data_dt <- data.table::as.data.table(data)
#   data_mapuce_dt <- data.table::as.data.table(muce_filter_rows_in_models(data))
#
#   ### 3. Set Keys for Faster Joins ###
#   data.table::setkeyv(data_dt, required_cols)
#   data.table::setkeyv(data_mapuce_dt, required_cols)
#
#   ### 4. Define processing function ###
#   process_chunk <- function(chunk, mapuce_dt) {
#     # IRIS codes
#     iris_diff <- chunk[!mapuce_dt, on = "iris_code", unique(iris_code)]
#
#     # CV codes (type Z)
#     cv_diff <- chunk[iris_typ == "Z"][!mapuce_dt[iris_typ == "Z"],
#                                       on = "cv_code", unique(cv_code)]
#
#     # Commune codes (type X)
#     com_diff <- chunk[iris_typ == "X", .(com_code = substr(iris_code, 1, 5))]
#     com_mapuce <- mapuce_dt[iris_typ == "X", .(com_code = substr(iris_code, 1, 5))]
#     com_diff <- com_diff[!com_mapuce, on = "com_code", unique(com_code)]
#
#     list(iris_code = iris_diff, com_code = com_diff, cv_code = cv_diff)
#   }
#
#   ### 5. Chunked Processing ###
#   if (nrow(data_dt) > chunk_size) {
#     if (show_progress) {
#       pb <- progress::progress_bar$new(
#         format = "Processing chunks [:bar] :percent (~:eta remaining)",
#         total = ceiling(nrow(data_dt) / chunk_size)
#       )
#     }
#
#     ### 6. Parallel Processing ###
#     if (n_workers > 1) {
#       n_workers <- min(n_workers, parallel::detectCores() - 1)
#       cl <- parallel::makeCluster(n_workers)
#       doParallel::registerDoParallel(cl)
#       on.exit(parallel::stopCluster(cl), add = TRUE)
#
#       chunks <- split(data_dt, (seq_len(nrow(data_dt)) - 1) %/% chunk_size)
#
#       results <- foreach::foreach(
#         i = seq_along(chunks),
#         .combine = function(x, y) list(
#           iris_code = unique(c(x$iris_code, y$iris_code)),
#           com_code = unique(c(x$com_code, y$com_code)),
#           cv_code = unique(c(x$cv_code, y$cv_code))
#         ),
#         .packages = c("data.table", "stringr")
#       ) %dopar% {
#         if (show_progress) pb$tick()
#         process_chunk(chunks[[i]], data_mapuce_dt)
#       }
#
#       return(results)
#     } else {
#       ### Sequential processing ###
#       results <- list(iris_code = character(), com_code = character(), cv_code = character())
#       chunks <- split(data_dt, (seq_len(nrow(data_dt)) - 1) %/% chunk_size)
#
#       for (chunk in chunks) {
#         if (show_progress) pb$tick()
#         chunk_result <- process_chunk(chunk, data_mapuce_dt)
#         results$iris_code <- unique(c(results$iris_code, chunk_result$iris_code))
#         results$com_code <- unique(c(results$com_code, chunk_result$com_code))
#         results$cv_code <- unique(c(results$cv_code, chunk_result$cv_code))
#       }
#       return(results)
#     }
#   } else {
#     ### Single chunk processing ###
#     return(process_chunk(data_dt, data_mapuce_dt))
#   }
# }
# #' Identify Entities Not Present in MAPUCE Models (Optimized for Large Datasets)
# #'
# #' @description Efficiently identifies IRIS, commune, and CV codes missing from MAPUCE models.
# #' Uses data.table, chunked processing, parallel computation, and robust error handling.
# #'
# #' @param data A data.frame/data.table with columns: iris_code, iris_typ, cv_code
# #' @param chunk_size Number of rows to process at once (default: 1M rows)
# #' @param n_workers Number of CPU cores to use (default: 1)
# #' @param show_progress Whether to show progress bar (default: TRUE)
# #'
# #' @return List with iris_code, com_code, and cv_code vectors of missing entities
# #'
# #' @import data.table
# #' @importFrom parallel detectCores makeCluster stopCluster
# #' @importFrom doParallel registerDoParallel
# #' @importFrom foreach foreach %dopar%
# #' @importFrom progress progress_bar
# #' @export
# muce_identify_entities_oo_models <- function(
#   data,
#   chunk_size = 1e6,
#   n_workers = 1,
#   show_progress = TRUE
# ) {
#   ## 1. Enhanced Input Validation ##
#   if (!is.data.frame(data)) stop("Input must be a data.frame or data.table")
#
#   required_cols <- c("iris_code", "iris_typ", "cv_code")
#   missing_cols <- setdiff(required_cols, names(data))
#   if (length(missing_cols) > 0) {
#     stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
#   }
#
#   ## 2. Configure data.table for parallelism ##
#   data.table::setDTthreads(n_workers)
#   on.exit(data.table::setDTthreads(1), add = TRUE) # Reset on exit
#
#   ## 3. Convert to data.table with safety checks ##
#   data_dt <- data.table::as.data.table(data)[, .SD, .SDcols = required_cols]
#   data_mapuce_dt <- data.table::as.data.table(
#     tryCatch(
#       muce_filter_rows_in_models(data),
#       error = function(e) stop("Error in muce_filter_rows_in_models: ", e$message)
#     )
#   )[, .SD, .SDcols = required_cols]
#
#   ## 4. Set keys and ensure minimum chunk size ##
#   data.table::setkeyv(data_dt, required_cols)
#   data.table::setkeyv(data_mapuce_dt, required_cols)
#   chunk_size <- max(chunk_size, 1000L) # Minimum 1000 rows per chunk
#
#   ## 5. Safe unique function for empty results ##
#   safe_unique <- function(x) {
#     if (length(x) > 0) unique(x) else character(0)
#   }
#
#   ## 6. Core processing function ##
#   process_chunk <- function(chunk, mapuce_dt) {
#     list(
#       iris_code = chunk[!mapuce_dt, on = "iris_code", safe_unique(iris_code)],
#       cv_code = chunk[iris_typ == "Z"][!mapuce_dt[iris_typ == "Z"],
#                                        on = "cv_code", safe_unique(cv_code)],
#       com_code = chunk[iris_typ == "X",
#                        .(com_code = substr(iris_code, 1, 5))][
#                          !mapuce_dt[iris_typ == "X",
#                                     .(com_code = substr(iris_code, 1, 5))],
#                          on = "com_code", safe_unique(com_code)]
#     )
#   }
#
#   ## 7. Chunked processing logic ##
#   if (nrow(data_dt) > chunk_size) {
#     if (show_progress) {
#       pb <- progress::progress_bar$new(
#         format = "Processing [:bar] :percent (:eta remaining)",
#         total = ceiling(nrow(data_dt)/chunk_size)
#       )
#     }
#
#     ## Parallel execution ##
#     if (n_workers > 1) {
#       n_workers <- min(n_workers, parallel::detectCores() - 1)
#       cl <- parallel::makeCluster(n_workers)
#       doParallel::registerDoParallel(cl)
#       on.exit(parallel::stopCluster(cl), add = TRUE)
#
#       chunks <- split(data_dt, (seq_len(nrow(data_dt)) - 1L) %/% chunk_size)
#
#       results <- foreach::foreach(
#         i = seq_along(chunks),
#         .combine = function(x, y) list(
#           iris_code = safe_unique(c(x$iris_code, y$iris_code)),
#           com_code = safe_unique(c(x$com_code, y$com_code)),
#           cv_code = safe_unique(c(x$cv_code, y$cv_code))
#         ),
#         .packages = "data.table"
#       ) %dopar% {
#         if (show_progress) pb$tick()
#         process_chunk(chunks[[i]], data_mapuce_dt)
#       }
#
#       return(results)
#
#     } else {
#       ## Sequential processing ##
#       results <- list(
#         iris_code = character(),
#         com_code = character(),
#         cv_code = character()
#       )
#
#       for (i in seq(1, nrow(data_dt), by = chunk_size)) {
#         if (show_progress) pb$tick()
#         chunk <- data_dt[i:min(i + chunk_size - 1L, nrow(data_dt))]
#         chunk_res <- process_chunk(chunk, data_mapuce_dt)
#
#         results$iris_code <- safe_unique(c(results$iris_code, chunk_res$iris_code))
#         results$com_code <- safe_unique(c(results$com_code, chunk_res$com_code))
#         results$cv_code <- safe_unique(c(results$cv_code, chunk_res$cv_code))
#       }
#       return(results)
#     }
#   } else {
#     ## Single chunk processing ##
#     return(process_chunk(data_dt, data_mapuce_dt))
#   }
# }

## ----------------------------------------------------------------------------
## Vérification que le dataset importé contient bien:
## 1. toutes les variables attendues (la fonction `extract_rp_indcvi()` retournerait une erreur sinon, car seules les variables d'intérêt sont sélectionnées, par leur nom)
## 2. et que les variables importées ont bien le codage attendu: celui du rp indcvi 2011

#' Check that a dataset has all the expected column names and no more
#'
#' @param data A rp indcvi dataset as imported with extract_rp_indcvi().
#'
#' @return A warning message if the dataset doesn't fit the expected column names.
#' @export
#'
#' @examples
#' check_rp_indcvi_2011_names(rp_indcvi_sampled_2011)
#' rp_indcvi_sampled_2011 %>%
#'   dplyr::select(!SURF) %>%
#'   check_rp_indcvi_2011_names()
#' rp_indcvi_sampled_2011 %>%
#'   dplyr::mutate(SURF_2 = SURF) %>%
#'   check_rp_indcvi_2011_names()
check_rp_indcvi_2011_names <- function(data) {
  if (!setequal(
    colnames(data), # colnames of the extracted dataset
    setdiff(vars_rp_indcvi_for_mapuce_names, c("LPRM", "METRODOM")) # les variables demandées sans c("LPRM", "METRODOM") qui ont servies à la sélection
  )) {
    data_names <- colnames(data)
    expected_names <- setdiff(vars_rp_indcvi_for_mapuce_names, c("LPRM", "METRODOM"))
    ## More names in the data than expected
    if (!identical(dplyr::setdiff(data_names, expected_names), character(0))) {
      warning(paste("The dataset has more columns than expected in the rp indcvi 2011.\nAdditional colum(s):",
                    paste0(sort(dplyr::setdiff(data_names, expected_names)), collapse = ", "), "\n"))
    }
    ## Missing levels in the data compared to expected
    if (!identical(dplyr::setdiff(expected_names, data_names), character(0))) {
      warning(paste("The dataset has fewer columns than expected in the rp indcvi 2011.\nMissing colum(s):",
                    paste0(sort(dplyr::setdiff(expected_names, data_names)), collapse = ", "), "\n"))
    }
  }
}

#' Check that a given variable has the expected levels
#'
#' @param data the rp indcvi dataset as imported with extract_rp_indcvi() in which the variable has to be checked.
#' @param var_name name of the variable to check.
#' @param var_levels levels expected for the variable.
#'
#' @return A warning message if the variable doesn't have the expected levels.
#' @export
#'
#' @examples
#' # RP indcvi 2011 has the expected levels found in `"contenu_RP2011_INDCVI.pdf"`
#' unique(rp_indcvi_sampled_2011[["CHFL"]])
#' check_rp_indcvi_2011_levels(rp_indcvi_sampled_2011, var_name = "CHFL",
#'                             var_levels = c("1", "2", "3", "4", "X", "Z"))
#' unique(rp_indcvi_sampled_2011[["SURF"]])
#' check_rp_indcvi_2011_levels(rp_indcvi_sampled_2011, var_name = "SURF",
#'                             var_levels = c("1", "2", "3", "Z"))
#' # If the dataset contains only a subset of the expected levels: no warning is returned !
#' check_rp_indcvi_2011_levels(rp_indcvi_sampled_2011, var_name = "SURF",
#'                             var_levels = c("1", "2", "3", "4", "Z"))
#' # RP indcvi 2016 has the expected levels, except for SURF which is divided in 7 groups in 2016,
#' # compared to 3 in 2011 (when the models were developped)
#' unique(rp_indcvi_sampled_2016[["SURF"]])
#' check_rp_indcvi_2011_levels(rp_indcvi_sampled_2016, var_name = "SURF",
#'                             var_levels = c("1", "2", "3", "Z"))
check_rp_indcvi_2011_levels <- function(data, var_name, var_levels) {
  ## Vérification pour une variable donnée
  unique_data_levels <- unique(data[[var_name]])
  if (unique_data_levels %>%
      cleanser::clr_detect_levels(levels =  var_levels, negate = TRUE) %>%
      any()) {
    warning(paste(var_name, "is expected to have the same levels than in the rp indcvi 2011:",
                  paste0(var_levels, collapse = ", "), "\n"))
  }
  ## Difference between data and expected
  if (!dplyr::setequal(unique_data_levels, var_levels)) {
    ## More levels in the data than expected
    if (!identical(dplyr::setdiff(unique_data_levels, var_levels), character(0))) {
      warning(paste(var_name, "has more levels than expected in the rp indcvi 2011:",
                    paste0(sort(dplyr::setdiff(unique_data_levels, var_levels)), collapse = ", "), "\n"))
    }
    ## Missing levels in the data compared to expected
    if (!identical(dplyr::setdiff(var_levels, unique_data_levels), character(0))) {
      warning(paste(var_name, "has missing levels compared to expected in the rp indcvi 2011:",
                    paste0(sort(dplyr::setdiff(var_levels,unique_data_levels)), collapse = ", "), "\n"))
    }
  }
}


#' Check all mapuce variables to check the expected levels they had in rp indcvi 2011
#'
#' @param data A rp indcvi dataset of a given millesime as imported with extract_rp_indcvi()
#'
#' @return Warning message for each variable that doesn't have the expected levels (the ones of 2011).
#' @export
#'
#' @examples
#' # RP indcvi 2011 has the expected levels found in `"contenu_RP2011_INDCVI.pdf"` for all variables
#' check_rp_indcvi_2011_levels_for_mapuce(rp_indcvi_sampled_2011)
#' # RP indcvi 2016 has the expected levels, except for SURF which is divided in 7 groups in 2016,
#' # compared to 3 in 2011 (when the models were developped)
#' check_rp_indcvi_2011_levels_for_mapuce(rp_indcvi_sampled_2016)
#' unique(rp_indcvi_sampled_2016$SURF)
check_rp_indcvi_2011_levels_for_mapuce <- function(data) {
  ## Vérification de la variable TYPL
  check_rp_indcvi_2011_levels(data, var_name = "TYPL",
                              var_levels = c("1", "2", "3", "4", "5", "6", "Z"))
  ## Vérification de la variable CHFL
  check_rp_indcvi_2011_levels(data, var_name = "CHFL",
                              var_levels = c("1", "2", "3", "4", "X", "Z"))
  ## Vérification de la variable CMBL
  check_rp_indcvi_2011_levels(data, var_name = "CMBL",
                              var_levels = c("1", "2", "3", "4", "5", "6", "X", "Z"))
  ## Vérification de la variable SURF
  check_rp_indcvi_2011_levels(data, var_name = "SURF",
                              var_levels = c("1", "2", "3", "Z"))
  ## Vérification de la variable NBPI
  check_rp_indcvi_2011_levels(data, var_name = "NBPI",
                              var_levels = c("01", "02", "03", "04", "05",
                                             "06", "07", "08", "09", "10",
                                             "11", "12", "13", "14", "15",
                                             "16", "17", "18", "19", "20",
                                             "Z"))
  ## Vérification de la variable NPERR
  check_rp_indcvi_2011_levels(data, var_name = "NPERR",
                              var_levels = c("1", "2", "3", "4", "5", "6", "Z"))
  ## Vérification de la variable COUPLE
  check_rp_indcvi_2011_levels(data, var_name = "COUPLE",
                              var_levels = c("1", "2"))
  ## Vérification de la variable STOCD
  check_rp_indcvi_2011_levels(data, var_name = "STOCD",
                              var_levels = c("00", "10", "21", "22", "23", "30", "ZZ"))
}


#' Check all mapuce variables to check the expected levels they had in rp indcvi 2011, excluding X & Z modalities.
#'
#' @param data A rp indcvi dataset of a given millesime as imported with extract_rp_indcvi(),
#'   excluding X & Z modalities removed during extraction.
#'
#' @return Warning message for each variable that doesn't have the expected levels (the ones of 2011).
#' @export
#'
#' @examples
#' # RP indcvi 2011 has the expected levels found in `"contenu_RP2011_INDCVI.pdf"` for all variables
#' check_rp_indcvi_2011_levels_for_mapuce_restricted(rp_indcvi_sampled_2011)
#' # RP indcvi 2016 has the expected levels, except for SURF which is divided in 7 groups in 2016,
#' # compared to 3 in 2011 (when the models were developped)
#' check_rp_indcvi_2011_levels_for_mapuce_restricted(rp_indcvi_sampled_2016)
#' unique(rp_indcvi_sampled_2016$SURF)
check_rp_indcvi_2011_levels_for_mapuce_restricted <- function(data) {
  ## Vérification de la variable TYPL
  check_rp_indcvi_2011_levels(data, var_name = "TYPL",
                              var_levels = c("1", "2", "3", "4", "5", "6"))
  ## Vérification de la variable CHFL
  check_rp_indcvi_2011_levels(data, var_name = "CHFL",
                              var_levels = c("1", "2", "3", "4"))
  ## Vérification de la variable CMBL
  check_rp_indcvi_2011_levels(data, var_name = "CMBL",
                              var_levels = c("1", "2", "3", "4", "5", "6"))
  ## Vérification de la variable SURF
  check_rp_indcvi_2011_levels(data, var_name = "SURF",
                              var_levels = c("1", "2", "3"))
  ## Vérification de la variable NBPI
  check_rp_indcvi_2011_levels(data, var_name = "NBPI",
                              var_levels = c("01", "02", "03", "04", "05",
                                             "06", "07", "08", "09", "10",
                                             "11", "12", "13", "14", "15",
                                             "16", "17", "18", "19", "20"))
  ## Vérification de la variable NPERR
  check_rp_indcvi_2011_levels(data, var_name = "NPERR",
                              var_levels = c("1", "2", "3", "4", "5", "6"))
  ## Vérification de la variable COUPLE
  check_rp_indcvi_2011_levels(data, var_name = "COUPLE",
                              var_levels = c("1", "2"))
  ## Vérification de la variable STOCD
  check_rp_indcvi_2011_levels(data, var_name = "STOCD",
                              var_levels = c("10", "21", "22", "23", "30"))
}

