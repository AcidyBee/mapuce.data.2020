# data-raw/prepare_datasets.R
#' Prepare MAPUCE 2020 Datasets
#'
#' Automated pipeline for processing and saving zone-based datasets
#'
#' @param indcvi_path Path to INSEE RP INDCVI 2020 CSV file
#' @param output_dir Directory to save processed data (default: "data/")
#' @param compress_type Compression method (default: "xz")
#' @param overwrite Logical, overwrite existing files? (default: TRUE)

# Setup ----
library(dplyr)
library(sf)
library(mapuce) # For pipeline_rp_indcvi_2016_to_mapuce
library(insee.admin.data.2022)
library(insee.rp)
library(insee.admin)

# Configuration ----
config <- list(
  zones = list(
    ZONE_A = "11",  # Île-de-France
    ZONE_B = c("24", "27", "28", "32"),
    ZONE_C = c("44", "52", "53"),
    ZONE_D = c("75", "76"),
    ZONE_E = c("84", "93", "94", "01", "02", "03", "04")
  ),
  base_year = 2020,    # rp_year = 2020, TODO: remplacer base_year par rp_year
  spatial_year = 2022  #  TODO: remplacer spatial_year par admin_year
)

# Main Processing Function ----
process_mapuce_data <- function(indcvi_path,
                                output_dir = "data/",
                                compress_type = "xz",
                                overwrite = TRUE) {

  # 1. Load and Process Core Data ----
  message("Processing base datasets...")
  mapuce_indcvi <- mapuce::pipeline_rp_indcvi_2016_to_mapuce(file = indcvi_path)

  decoupage_admin <- insee_admin_decoupage
  cog_nested_lut <- insee.admin.data.2022::lut_code_label

  # 2. Create Lookup Tables ----
  message("Creating lookup tables...")
  lut_iris_atome_indcvi <- insee.rp::ins_create_lut_atome_indcvi(
    decoupage_admin %>% dplyr::semi_join(mapuce_indcvi, by = "cv_code"),
    mapuce_indcvi
  )

  # 3. Process Spatial Data ----
  message("Processing spatial data...")
  spatial_iris <- insee_admin_spatial %>%
    dplyr::semi_join(lut_iris_atome_indcvi, by = "iris_code") %>%
    dplyr::left_join(lut_iris_atome_indcvi, by = "iris_code") %>%
    insee.admin::augment_admin_label_from_code(cog_nested_lut,
                                               .cols = c("cv_code", "dep_code", "reg_code")) %>%
    dplyr::select(atome_indcvi, atome_indcvi_type, iris_code, iris_type, iris_label,
           com_arm_code, com_arm_label, cv_code, cv_label,
           dep_code, dep_label, reg_code, reg_label, geometry)

  spatial_atome_indcvi <- insee_admin_spatial %>%
    dplyr::semi_join(lut_iris_atome_indcvi, by = "iris_code") %>%
    insee.rp::ins_sf_union_atome_indcvi(lut_iris_atome_indcvi) %>%
    dplyr::left_join(distinct(lut_iris_atome_indcvi, atome_indcvi, atome_indcvi_type),
              by = "atome_indcvi") %>%
    dplyr::left_join(select(decoupage_admin, atome_indcvi, cv_code, dep_code, reg_code),
              by = "atome_indcvi") %>%
    insee.admin::augment_admin_label_from_code(cog_nested_lut,
                                               .cols = c("cv_code", "dep_code", "reg_code")) %>%
    dplyr::select(atome_indcvi, atome_indcvi_type, cv_code, cv_label,
           dep_code, dep_label, reg_code, reg_label, geometry)

  # 4. Create Zone-Specific Subsets ----
  message("Creating zone subsets...")
  create_zone_data <- function(zone_name, zone_codes) {
    message("Processing ", zone_name)

    zone_filter <- if (zone_name == "FRA") {
      dplyr::expr(TRUE)  # Keep all data for France
    } else {
      dplyr::expr(reg_code %in% !!zone_codes)
    }

    list(
      lut = filter(lut_iris_atome_indcvi, !!zone_filter),
      semantic = filter(mapuce_indcvi, !!zone_filter),
      spatial_iris = filter(spatial_iris, !!zone_filter),
      spatial_atome = filter(spatial_atome_indcvi, !!zone_filter)
    )
  }

  # Process all zones
  zone_data <- c(
    list(FRA = create_zone_data("FRA", NULL)),
    lapply(names(config$zones), function(z) {
      create_zone_data(z, config$zones[[z]])
    }) %>% setNames(paste0("ZONE_", LETTERS[1:5]))
  )

  # 5. Save Data ----
  message("Saving datasets...")
  save_datasets <- function(data_list, suffix = "") {
    purrr::imap(data_list, function(ds, name) {
      file_name <- paste0(output_dir, name, suffix, ".rda")
      saveRDS(ds, file = file_name, compress = compress_type)
      message("Saved ", file_name)
    })
  }

  # Save national data
  save_datasets(list(
    mapuce_indcvi = mapuce_indcvi,
    lut_iris_atome_indcvi = lut_iris_atome_indcvi,
    spatial_iris = spatial_iris,
    spatial_atome_indcvi = spatial_atome_indcvi
  ))

  # Save zone data
  purrr::iwalk(zone_data, function(zone, zone_name) {
    if (zone_name != "FRA") {
      save_datasets(zone, suffix = paste0("_", zone_name))
    }
  })

  # 6. Add Metadata ----
  add_dataset_metadata <- function() {
    metadata <- list(
      creation_date = Sys.time(),
      r_version = R.version.string,
      package_versions = list(
        mapuce = utils::packageVersion("mapuce"),
        insee.admin.data.2022 = utils::packageVersion("insee.admin.data.2022")
      ),
      config = config
    )

    saveRDS(metadata, file.path(output_dir, "dataset_metadata.rds"))
  }

  add_dataset_metadata()

  message("Data preparation complete!")
}

# Execute ----
if (sys.nframe() == 0) {
  # Only run when executed directly
  args <- commandArgs(trailingOnly = TRUE)
  indcvi_path <- if (length(args) > 0) args[1] else {
    "/path/to/default/FD_INDCVI_2020.csv"
  }

  process_mapuce_data(
    indcvi_path = indcvi_path,
    output_dir = "data/",
    compress_type = "xz",
    overwrite = TRUE
  )
}
