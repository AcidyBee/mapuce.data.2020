## TODO:
## Add year attributes to objects:
# attr(spatial_iris, "rp_year") <- 2020
# attr(spatial_iris, "admin_year") <- 2022


#' Load Required Packages
load_packages <- function(rp_pkg, admin_pkg) {
  if (!requireNamespace(rp_pkg, quietly = TRUE)) {
    stop("Please install ", rp_pkg, ": install.packages('", rp_pkg, "')")
  }
  if (!requireNamespace(admin_pkg, quietly = TRUE)) {
    stop("Please install ", admin_pkg, ": install.packages('", admin_pkg, "')")
  }
}

#' Get INDCVI File Path
get_indcvi_path <- function(rp_pkg, indcvi_file) {
  pkg_func <- getExportedValue(rp_pkg, "path_to_extdata")
  pkg_func(indcvi_file)
}

#' Process Mapuce Data
process_mapuce_data <- function(indcvi_path, pipeline_func) {
  pipeline_func(file = indcvi_path)
}

#' Create IRIS Lookup Table
create_iris_lookup <- function(decoupage_admin, mapuce_data) {
  insee.rp::ins_create_lut_atome_indcvi(
    decoupage_admin %>% dplyr::semi_join(mapuce_data, by = "cv_code"),
    mapuce_data
  )
}

#' Process Spatial IRIS Data
process_spatial_iris <- function(spatial_data, iris_lookup, cog_nested_lut) {
  spatial_data %>%
    dplyr::semi_join(iris_lookup, by = "iris_code") %>%
    dplyr::left_join(iris_lookup, by = "iris_code") %>%
    insee.admin::augment_admin_label_from_code(cog_nested_lut,
                                               .cols = c("cv_code", "dep_code", "reg_code")) %>%
    dplyr::select(dplyr::all_of(c(
      "atome_indcvi", "atome_indcvi_type", "iris_code", "iris_type", "iris_label",
      "com_arm_code", "com_arm_label", "cv_code", "cv_label",
      "dep_code", "dep_label", "reg_code", "reg_label", "geometry"))
    )
}

#' Process Spatial Atom Data
process_spatial_atom <- function(spatial_data, iris_lookup, decoupage_admin, cog_nested_lut) {
  spatial_data %>%
    dplyr::semi_join(iris_lookup, by = "iris_code") %>%
    insee.rp::ins_sf_union_atome_indcvi(iris_lookup) %>%
    dplyr::left_join(
      dplyr::distinct(iris_lookup, atome_indcvi, atome_indcvi_type),
      by = "atome_indcvi"
    ) %>%
    dplyr::left_join(
      dplyr::select(decoupage_admin, atome_indcvi, cv_code, dep_code, reg_code),
      by = "atome_indcvi"
    ) %>%
    insee.admin::augment_admin_label_from_code(cog_nested_lut,
                                               .cols = c("cv_code", "dep_code", "reg_code")) %>%
    dplyr::select(dplyr::all_of(c(
      "atome_indcvi", "atome_indcvi_type", "cv_code", "cv_label",
      "dep_code", "dep_label", "reg_code", "reg_label", "geometry"))
    )
}



#' Create Zone-Specific Subsets
create_zone_subsets <- function(full_data, zone_def, zone_name) {
  if (zone_name == "FRA") return(full_data)

  if (inherits(full_data, "sf")) {
    full_data %>%
      dplyr::filter(.data$reg_code %in% zone_def)
  } else {
    full_data %>%
      dplyr::filter(.data$reg_code %in% zone_def |
                      .data$atome_indcvi %in% unique(full_data$atome_indcvi[full_data$reg_code %in% zone_def]))
  }
}

#' Process All Zones for a Dataset
process_all_zones <- function(full_data, zone_config, data_name) {
  purrr::imap(zone_config, ~{
    zone_data <- create_zone_subsets(full_data, .x, .y)
    # Add zone metadata
    attr(zone_data, "zone") <- .y
    attr(zone_data, "reg_codes") <- .x
    zone_data
  }) %>%
    purrr::set_names(paste0(data_name, "_", names(zone_config)))
}
