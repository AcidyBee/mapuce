#' Prepare sampled INDCVI datasets for package use
#'
#' @param file Path to the raw INDCVI data file
#' @param n Sample size (default: 10000)
#' @param seed Random seed (default: 1234)
#' @param compress Compression type ("gzip", "bzip2", or "xz")
#' @return Invisibly returns the sampled data
#' @export
prepare_indcvi_datasets <- function(file, n = 10000L, seed = 1234, compress = "bzip2") {
  # Validate inputs
  if (!file.exists(file)) {
    stop("File not found: ", file)
  }

  # Extract year from filename (more robust pattern)
  millesime <- extract_millesime(file)
  if (is.na(millesime)) {
    stop("Could not extract year from filename: ", file)
  }

  set.seed(seed)

  # Process data
  data <- extract_rp_indcvi_for_mapuce(file = file) %>%
    dplyr::slice_sample(n = n)

  # Create named object in a new environment
  data_name <- paste0("rp_indcvi_sampled_", millesime)
  env <- new.env()
  env[[data_name]] <- data

  # Call usethis::use_data() through do.call
  do.call(
    usethis::use_data,
    list(
      as.name(data_name),
      overwrite = TRUE,
      compress = compress
    ),
    envir = env
  )

  message(sprintf("Successfully saved %s.rda using usethis::use_data()", data_name))
  invisible(data)
}

#' @describeIn prepare_indcvi_datasets Helper function to extract year from filename
extract_millesime <- function(file_path) {
  stringr::str_extract(basename(file_path), "(?<=_|^)\\d{4}(?=\\.|_)")
}
