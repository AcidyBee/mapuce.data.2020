#' Get Data by INSEE Zone
#'
#' @param zone_code One of: "FRA", "ZONE_A", "ZONE_B", "ZONE_C", "ZONE_D", "ZONE_E"
#' @param type Data type: "lookup", "semantic", "spatial_iris", or "spatial_atome"
#' @return Requested dataset filtered by zone
#' @export
#' @examples
#' # Get semantic data for Île-de-France
#' idf_data <- get_data_by_zone("ZONE_A", "semantic")
get_data_by_zone <- function(zone_code = c("FRA", "ZONE_A", "ZONE_B", "ZONE_C", "ZONE_D", "ZONE_E"),
                             type = c("lookup", "semantic", "spatial_iris", "spatial_atome")) {

  type <- match.arg(type)
  zone_code <- match.arg(zone_code)
  zone_code <- toupper(zone_code)

  # Validate zone code
  if (!zone_code %in% names(.zone_regions)) {
    stop("Invalid zone_code. Use: ", paste(names(.zone_regions), collapse = ", "))
  }

  # Base dataset name
  ds_name <- switch(type,
                    "lookup" = "lut_iris_atome_indcvi",
                    "semantic" = "mapuce_indcvi",
                    "spatial_iris" = "spatial_iris",
                    "spatial_atome" = "spatial_atome_indcvi")

  # ZONE suffix
  zone_suffix <- switch(zone_code,
                    "ZONE_A" = "za",
                    "ZONE_B" = "zb",
                    "ZONE_C" = "zc",
                    "ZONE_D" = "zd",
                    "ZONE_E" = "ze")

  # Load data
  if (zone_code == "FRA") {
    data(list = ds_name, envir = environment())
    dat <- get(ds_name)
  } else {
    # For regional data
    reg_ds_name <- paste0(ds_name, "_", zone_suffix)
    if (!exists(reg_ds_name)) {
      stop("Dataset not available for zone ", zone_suffix)
    }
    data(list = reg_ds_name, envir = environment())
    dat <- get(reg_ds_name)
  }

  # Apply row limits in interactive sessions
  if (interactive() && nrow(dat) > getOption("mapuce.max_rows", 50000)) {
    warning("Sampling to ", getOption("mapuce.max_rows"), " rows. Set options(mapuce.max_rows=Inf) for full data.")
    dat <- dat[sample(nrow(dat), getOption("mapuce.max_rows")), ]
  }

  return(dat)
}


#' Get Data with Automatic Year Handling
#' @param rp_year Millésime of RP data (e.g., 2020)
#' @param zone_code Zone code ("FRA", "ZONE_A", etc.)
get_data <- function(rp_year,
                     zone_code = c("FRA", "ZONE_A", "ZONE_B", "ZONE_C", "ZONE_D", "ZONE_E"),
                     type = "spatial_iris") {

  zone_code <- match.arg(zone_code)
  zone_code <- toupper(zone_code)
  # ZONE suffix
  zone_suffix <- switch(zone_code,
                        "ZONE_A" = "za",
                        "ZONE_B" = "zb",
                        "ZONE_C" = "zc",
                        "ZONE_D" = "zd",
                        "ZONE_E" = "ze")

  file_name <- sprintf("%s_%s_%s.rda", type, zone_suffix, rp_year)
  if (!file.exists(file.path("data", file_name))) {
    stop("Data not available for RP year ", rp_year)
  }
  readRDS(file.path("data", file_name))
}
