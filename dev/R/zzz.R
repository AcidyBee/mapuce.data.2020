.zone_regions <- list(
  "FRA" = "00",  # France entière
  "ZONE_A" = "11",  # Île-de-France
  "ZONE_B" = c("24", "27", "28", "32"),
  "ZONE_C" = c("44", "52", "53"),
  "ZONE_D" = c("75", "76"),
  "ZONE_E" = c("84", "93", "94", "01", "02", "03", "04")
)

.onLoad <- function(libname, pkgname) {
  # Set package options
  options(
    mapuce.max_rows = 50000,
    # Register zone definitions
    insee.zones = list(
      ZONE_A = "Île-de-France (11)",
      ZONE_B = "Centre-Val de Loire (24), Bourgogne-Franche-Comté (27), Normandie (28), Hauts-de-France (32)",
      ZONE_C = "Grand Est (44), Pays de la Loire (52), Bretagne (53)",
      ZONE_D = "Nouvelle-Aquitaine (75), Occitanie (76)",
      ZONE_E = "Auvergne-Rhône-Alpes (84), PACA (93), Corse (94), DOM (01-04)"
    ),
    mapuce.default_zone = "ZONE_A",
    mapuce.available_zones = c("FRA", "ZONE_A", "ZONE_B", "ZONE_C", "ZONE_D", "ZONE_E")
  )

  if (interactive()) {
    packageStartupMessage(
      sprintf("mapuce.data.2020 v%s", utils::packageVersion("mapuce.data.2020")),
      "\nAvailable INSEE zones:",
      "\n- FRA: France entière",
      "\n- ZONE_A: Île-de-France (11)",
      "\n- ZONE_B: Centre-Val de Loire (24), Bourgogne-Franche-Comté (27), Normandie (28), Hauts-de-France (32)",
      "\n- ZONE_C: Grand Est (44), Pays de la Loire (52), Bretagne (53)",
      "\n- ZONE_D: Nouvelle-Aquitaine (75), Occitanie (76)",
      "\n- ZONE_E: Auvergne-Rhône-Alpes (84), PACA (93), Corse (94), DOM (01-04)"
    )
  }
}


#' Get Zone Definition
#' @export
get_zone_definition <- function(zone_code) {
  defs <- getOption("insee.zones")
  if (!zone_code %in% names(defs)) {
    stop("Invalid zone code. Use: ", paste(names(defs), collapse = ", "))
  }
  defs[[zone_code]]
}


#' Get Dataset Version
#' @param dataset_name Character name of dataset
#' @return Version string
#' @export
get_data_version <- function(dataset_name) {
  if (!exists(dataset_name)) {
    data(list = dataset_name, envir = environment())
  }
  attr(get(dataset_name), "version") %||% "unknown"
}
