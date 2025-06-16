source("data-raw/config.R")
source("data-raw/utils.R")

#' Prepare Data for Specific Millésime
#'
#' @param millesime Year identifier (e.g., "2020")
#' @param output_dir Directory to save processed data
#' @param compress_type Compression method ("xz", "bzip2", etc.)
prepare_millesime_data <- function(millesime = "2020",
                                   output_dir = "data/",
                                   compress_type = "xz") {

  config <- millesime_config[[millesime]]
  if (is.null(config)) stop("Unsupported millésime: ", millesime)

  message("Preparing data for millésime ", millesime)

  # Load required packages
  load_packages(config$rp_pkg, config$admin_pkg)

  # Get data paths
  indcvi_path <- get_indcvi_path(config$rp_pkg, config$indcvi_file)

  # Process data
  mapuce_data <- process_mapuce_data(indcvi_path, config$pipeline_func)
  decoupage_admin <- getExportedValue(config$admin_pkg, "insee_admin_decoupage")
  cog_nested_lut <- getExportedValue(config$admin_pkg, "lut_code_label")

  iris_lookup <- create_iris_lookup(decoupage_admin, mapuce_data)
  decoupage_augmented <- decoupage_admin %>%
    dplyr::left_join(dplyr::select(iris_lookup, iris_code, atome_indcvi),
                     by = "iris_code")

  spatial_data <- getExportedValue(config$admin_pkg, "insee_admin_spatial")
  spatial_iris <- process_spatial_iris(spatial_data, iris_lookup, cog_nested_lut)
  spatial_atom <- process_spatial_atom(spatial_data, iris_lookup, decoupage_augmented, cog_nested_lut)

  # Save data
  datasets <- list(
    mapuce_indcvi = mapuce_data,
    lut_iris_atome_indcvi = iris_lookup,
    spatial_iris = spatial_iris,
    spatial_atome_indcvi = spatial_atom
  )

  # 4. Create Zone Subsets ----
  message("\nCreating zone subsets...")
  zone_config <- config$zones

  # Process each dataset for all zones
  zone_datasets <- list(
    process_all_zones(mapuce_data, zone_config, "mapuce_indcvi"),
    process_all_zones(iris_lookup, zone_config, "lut_iris_atome_indcvi"),
    process_all_zones(spatial_iris, zone_config, "spatial_iris"),
    process_all_zones(spatial_atom, zone_config, "spatial_atome_indcvi")
  ) %>%
    purrr::flatten() # superseded
  # purrr::list_flatten()

  # 5. Save All Data ----
  all_datasets <- c(datasets, zone_datasets)


  # Create output directory if needed
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

  # Versioned save function
  save_data <- function(data, name) {
    file_name <- file.path(output_dir, paste0(name, "_", millesime, ".rda"))
    saveRDS(data, file = file_name, compress = compress_type)
    message("Saved ", file_name)
  }

  # Save all datasets
  purrr::iwalk(all_datasets, save_data)

  # Add metadata
  metadata <- list(
    creation_date = Sys.time(),
    millesime = millesime,
    r_version = R.version.string,
    packages = list(
      rp_pkg = paste0(config$rp_pkg, "@", packageVersion(config$rp_pkg)),
      admin_pkg = paste0(config$admin_pkg, "@", packageVersion(config$admin_pkg))
    )
  )

  saveRDS(metadata, file.path(output_dir, paste0("metadata_", millesime, ".rds")))

  message("Completed processing for millésime ", millesime)
}

# Example usage:
# prepare_millesime_data("2020")
