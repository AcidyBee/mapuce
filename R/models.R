#' MAPUCE Project Energy Consumption Models
#'
#' Generalized Linear Models (GLMs) from the MAPUCE research project estimating
#' residential energy consumption patterns in France. Contains four models:
#' - `model_cre`: Energy regulation behavior model
#' - `model_eq`: Household equipment count model
#' - `model_eq_surf`: Surface-normalized equipment model
#' - `model_iu`: Equipment usage intensity model
#'
#' @name mapuce_models
#' @aliases model_cre model_eq model_eq_surf model_iu
#' @seealso [semantic_ref] for input data structure
#' @references
#'   MAPUCE Research Project (2018) \url{https://mapuce.planbleu.org/}
#'   Methodology DOI:10.1007/xxxxx
NULL

#' @rdname mapuce_models
#' @title Energy Consumption Regulation Behavior Model
#' @description GLM estimating energy consumption based on regulation behaviors.
#' @format `glm` object with 30 elements including:
#' \describe{
#'   \item{coefficients}{Model parameters for predictors}
#'   \item{formula}{`cre ~ agerev + couple + inper + typl_ma + chfl_3g + cmbl_cre + surf_6g_cont`}
#'   \item{family}{Gaussian with identity link}
#'   \item{data}{Processed version of [semantic_ref]}
#' }
#' @examples
#' data(model_cre)
#' summary(model_cre)
#' predict(model_cre, newdata = semantic_ref[1:5, ])
"model_cre"

#' @rdname mapuce_models
#' @title Household Equipment Count Model
#' @format `glm` object with 30 elements including:
#' \describe{
#'   \item{formula}{`eq ~ agerev + couple + inper + typl_ma + nperr_123`}
#'   \item{family}{Poisson with log link}
#' }
"model_eq"

#' @rdname mapuce_models
#' @title Surface-Normalized Equipment Model
#' @format `glm` object with 30 elements including:
#' \describe{
#'   \item{formula}{`eq_surf ~ agerev + couple + surf_nbpi_4g + stocd_2g`}
#'   \item{offset}{`log(surf_6g_cont)`}
#' }
"model_eq_surf"

#' @rdname mapuce_models
#' @title Equipment Usage Intensity Model
#' @format `glm` object with 30 elements including:
#' \describe{
#'   \item{formula}{`iu ~ chfl_3g + cmbl_cre + nperr_123 + stocd_2g`}
#'   \item{family}{Gamma with log link}
#' }
"model_iu"

