## INDCVI Variables Documentation ----

#' INDCVI Variable Specifications for MAPUCE Project
#'
#' Documentation of INSEE RP survey variables used in MAPUCE computations.
#'
#' @name indcvi_vars
#' @aliases vars_rp_indcvi_for_mapuce_names vars_rp_indcvi_for_mapuce_types
NULL

#' @rdname indcvi_vars
#' @title INDCVI Variable Names
#' @description Original INSEE variable names (uppercase) used in MAPUCE computations.
#' @format Character vector of length 18 containing:
#' \describe{
#'   \item{IRIS}{IRIS geographic code (9 characters)}
#'   \item{CATIRIS}{IRIS category (1 character)}
#'   \item{CANTVILLE}{Canton or city code (5 characters)}
#'   \item{ARM}{Municipal arrondissement (Paris/Lyon/Marseille, 5 characters)}
#'   \item{NUMMI}{Household identifier (6 characters)}
#'   \item{IPONDI}{Individual weight (17-digit numeric stored as text)}
#'   \item{TYPL}{Housing type (1 character)}
#'   \item{CHFL}{Central heating (metropolitan France, 1 character)}
#'   \item{CMBL}{Main heating fuel (1 character)}
#'   \item{SURF}{Living area (1 character)}
#'   \item{NBPI}{Number of rooms (2 characters)}
#'   \item{AGEREV}{Reference person's age (3 characters → integer)}
#'   \item{INPER}{Household size (2 characters → integer)}
#'   \item{NPERR}{Grouped household size (1 character)}
#'   \item{COUPLE}{Couple status (1 character)}
#'   \item{STOCD}{Detailed housing tenure (2 characters)}
#'   \item{LPRM}{Relationship to reference person (1 character)}
#'   \item{METRODOM}{Metropolitan France/overseas indicator (1 character)}
#' }
#' @source INSEE RP surveys
#' @examples
#' data(vars_rp_indcvi_for_mapuce_names)
#' str(vars_rp_indcvi_for_mapuce_names)
"vars_rp_indcvi_for_mapuce_names"

#' @rdname indcvi_vars
#' @title INDCVI Variable Types
#' @description Column specifications for reading INDCVI files.
#' @format `vroom::col_spec` object matching variable names.
#' @examples
#' data(vars_rp_indcvi_for_mapuce_types)
#' print(vars_rp_indcvi_for_mapuce_types)
"vars_rp_indcvi_for_mapuce_types"

## Sample Data Documentation ----

#' @title INDCVI Sample Datasets
#' @name rp_indcvi_sampled_2011
#' @rdname indcvi_samples
#' @description Sample datasets from INSEE RP INDCVI surveys for different years.
#' @aliases rp_indcvi_sampled_2016 rp_indcvi_sampled_2020
#'
#' @section Common Structure:
#' \describe{
#'   \item{IRIS}{IRIS geographic code (9 characters)}
#'   \item{CATIRIS}{IRIS category (1 character)}
#'   \item{CANTVILLE}{Canton/city code (5 characters)}
#'   \item{ARM}{Arrondissement code (5 characters)}
#'   \item{NUMMI}{Household ID (8 characters)}
#'   \item{IPONDI}{Individual weight (17-digit numeric)}
#'   \item{TYPL}{Housing type (1 character)}
#'   \item{CHFL}{Central heating (1 character)}
#'   \item{CMBL}{Main heating fuel (1 character)}
#'   \item{NBPI}{Number of rooms (2 characters)}
#'   \item{AGEREV}{Reference person's age (3 characters → integer)}
#'   \item{INPER}{Household size (2 characters → integer)}
#'   \item{NPERR}{Grouped household size (1 character)}
#'   \item{COUPLE}{Couple status (1=yes/2=no, 1 character)}
#'   \item{STOCD}{Housing tenure (2 characters)}
#' }
#'
#' @section Year-Specific Variations:
#' \describe{
#'   \item{2011}{SURF: Living area (3 classes, 1 character)}
#'   \item{2016/2020}{SURF: Living area (7 classes, 1 character)}
#' }
#'
#' @source INSEE RP surveys:
#' \itemize{
#'   \item 2011: \url{https://www.insee.fr/fr/statistiques/2011208}
#'   \item 2016/2020: \url{https://www.insee.fr/fr/statistiques/4229118}
#' }
#'
#' @examples
#' data(rp_indcvi_sampled_2011)
#' head(rp_indcvi_sampled_2011)
NULL

#' @rdname indcvi_samples
"rp_indcvi_sampled_2011"

#' @rdname indcvi_samples
"rp_indcvi_sampled_2016"

#' @rdname indcvi_samples
"rp_indcvi_sampled_2020"

# #' INDCVI Sample Datasets
# #'
# #' @description Sample datasets from INSEE RP INDCVI surveys for different years,
# #' filtered to reference persons in metropolitan France.
# #'
# #' @name indcvi_samples
# #' @aliases rp_indcvi_sampled_2011 rp_indcvi_sampled_2016 rp_indcvi_sampled_2020
# #'
# #' @section Common Dataset Structure:
# #' All datasets share this structure:
# #' \describe{
# #'   \item{IRIS}{IRIS geographic code (9 characters)}
# #'   \item{CATIRIS}{IRIS category (1 character)}
# #'   \item{CANTVILLE}{Canton/city code (5 characters)}
# #'   \item{ARM}{Arrondissement code (5 characters)}
# #'   \item{NUMMI}{Household ID (8 characters)}
# #'   \item{IPONDI}{Individual weight (17-digit numeric)}
# #'   \item{TYPL}{Housing type (1 character)}
# #'   \item{CHFL}{Central heating (1 character)}
# #'   \item{CMBL}{Main heating fuel (1 character)}
# #'   \item{NBPI}{Number of rooms (2 characters)}
# #'   \item{AGEREV}{Reference person's age (3 characters → integer)}
# #'   \item{INPER}{Household size (2 characters → integer)}
# #'   \item{NPERR}{Grouped household size (1 character)}
# #'   \item{COUPLE}{Couple status (1=yes/2=no, 1 character)}
# #'   \item{STOCD}{Housing tenure (2 characters)}
# #' }
# #'
# #' @section Year-Specific Variations:
# #' \describe{
# #'   \item{2011}{SURF: Living area (3 classes, 1 character)}
# #'   \item{2016/2020}{SURF: Living area (7 classes, 1 character)}
# #' }
# #'
# #' @source INSEE RP surveys:
# #' \itemize{
# #'   \item 2011: \url{https://www.insee.fr/fr/statistiques/2011208}
# #'   \item 2016/2020: \url{https://www.insee.fr/fr/statistiques/4229118}
# #' }
# #'
# #' @examples
# #' # Access 2011 data
# #' data(rp_indcvi_sampled_2011)
# #' head(rp_indcvi_sampled_2011)
# #'
# #' # Access 2016 data
# #' data(rp_indcvi_sampled_2016)
# #' summary(rp_indcvi_sampled_2016)
# NULL
#
# #' @rdname indcvi_samples
# #' @export
# "rp_indcvi_sampled_2011"
#
# #' @rdname indcvi_samples
# #' @export
# "rp_indcvi_sampled_2016"
#
# #' @rdname indcvi_samples
# #' @export
# "rp_indcvi_sampled_2020"

# #' @title INDCVI Sample Data Template
# #' @description Documentation template for INDCVI sample datasets.
# #' @param dataset_name Name of the dataset (e.g., "rp_indcvi_sampled_2016")
# #' @param year Survey year
# #' @param n_rows Number of rows in sample
# #' @param source_url INSEE source URL
# #' @keywords internal
# #' @noRd
# document_indcvi_sample <- function(dataset_name, year, n_rows, source_url) {
#   list(
#     title = paste("Sample from INSEE RP INDCVI detail file", year),
#     description = paste0(
#       "Sample of ", n_rows, " rows from INSEE RP INDCVI detail file (", year, "), ",
#       "limited to MAPUCE project variables, filtered to LPRM == '1' & METRODOM == 'M'"
#     ),
#     format = list(
#       "Data frame with 16 columns and {n_rows} rows" = list(
#         IRIS = "IRIS geographic code (9 characters)",
#         CATIRIS = "IRIS category (1 character)",
#         CANTVILLE = "Canton/city code (5 characters)",
#         ARM = "Arrondissement code (5 characters)",
#         NUMMI = "Household ID (8 characters)",
#         IPONDI = "Individual weight (17-digit numeric)",
#         TYPL = "Housing type (1 character)",
#         CHFL = "Central heating (1 character)",
#         CMBL = "Main heating fuel (1 character)",
#         SURF = paste("Living area (",
#                      ifelse(year == 2011, "3 classes", "7 classes"), ", 1 character)"),
#         NBPI = "Number of rooms (2 characters)",
#         AGEREV = "Reference person's age (3 characters → integer)",
#         INPER = "Household size (2 characters → integer)",
#         NPERR = "Grouped household size (1 character)",
#         COUPLE = "Couple status (1=yes/2=no, 1 character)",
#         STOCD = "Housing tenure (2 characters)"
#       )
#     ),
#     source = source_url,
#     examples = c(
#       paste0("data(", dataset_name, ")"),
#       paste0("head(", dataset_name, ")")
#     )
#   )
# }
#
# #' @rdname indcvi_samples
# #' @title INDCVI 2011 Sample
# #' @eval document_indcvi_sample(
# #'   "rp_indcvi_sampled_2011", 2011, 1000,
# #'   "https://www.insee.fr/fr/statistiques/2011208"
# #' )
# #' @export
# "rp_indcvi_sampled_2011"
#
# #' @rdname indcvi_samples
# #' @title INDCVI 2016 Sample
# #' @eval document_indcvi_sample(
# #'   "rp_indcvi_sampled_2016", 2016, 10000,
# #'   "https://www.insee.fr/fr/statistiques/4229118"
# #' )
# #' @export
# "rp_indcvi_sampled_2016"
#
# #' @rdname indcvi_samples
# #' @title INDCVI 2020 Sample
# #' @eval document_indcvi_sample(
# #'   "rp_indcvi_sampled_2020", 2020, 10000,
# #'   "https://www.insee.fr/fr/statistiques/4229118"
# #' )
# #' @export
# "rp_indcvi_sampled_2020"

#' @title Semantic Reference Dataset
#' @description Processed INDCVI 2016 data for Île-de-France region, containing:
#' \describe{
#' \item{atome_indcvi}{Composite ID (IRIS or canton code)}
#' \item{iris_code}{IRIS code (9 characters)}
#' \item{cv_code}{Canton/ville code (5 characters)}
#' \item{arm_code}{Arrondissement code (5 characters)}
#' \item{ipondi}{Individual weight (numeric)}
#' \item{agerev}{Reference person age (integer)}
#' \item{couple}{Couple status (factor)}
#' \item{inper}{Household size (integer)}
#' \item{typl_ma}{Housing type (factor)}
#' \item{chfl_3g}{Heating type (factor)}
#' \item{cmbl_cre}{Main fuel type (factor)}
#' \item{surf_6g_cont}{Living area (6 groups, integer)}
#' \item{surf_nbpi_4g}{Area/rooms (4 groups, factor)}
#' \item{nperr_123}{Household size (3 groups, factor)}
#' \item{stocd_2g}{Tenure status (2 groups, factor)}
#' }
#' @examples
#' data(semantic_ref)
#' summary(semantic_ref)
"semantic_ref"
