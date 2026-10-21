library(targets)
library(tarchetypes)

# Charger les fonctions du package (si elles sont exportées)
# et activer la détection des changements dans le package
tar_option_set(
  packages = c("dplyr", "sf", "usethis", "insee.rp", "insee.admin",
               "insee.admin.data.2022", "insee.rp.data.2020", "mapuce"),
  ## A conserver tant que les packages sont en phase de développement.
  ## si les package sont stables cela peut être retiré
  imports = c("insee.rp", "insee.admin", "mapuce")
)

# Sourcing des fonctions locales au pipeline (si besoin)
tar_source("data-raw/utils.R")

## Diagnositques
# targets::tar_meta(fields = error, complete_only = TRUE)
# targets::tar_load(c(save_data, save_data_za))
# optimise_rda_compression("data/")

list(
  # --- 1. Import des données brutes ---
  tar_target(
    path_indcvi,
    insee.rp.data.2020::path_to_extdata("RP-detail/INDCVI/FD_INDCVI_2020.csv"),
    format = "file"
  ),
  tar_target(
    mapuce_indcvi,
    mapuce::pipeline_rp_indcvi_2016_to_mapuce(file = path_indcvi)
  ),

  # --- 2. Découpage administratif et LUT ---
  tar_target(
    decoupage_admin,
    insee.admin.data.2022::insee_admin_decoupage
  ),
  tar_target(
    cog_nested_lut,
    insee.admin.data.2022::lut_code_label
  ),
  tar_target(
    lut_iris_atome_indcvi,
    insee.rp::ins_create_lut_atome_indcvi(
      decoupage_admin %>% dplyr::semi_join(mapuce_indcvi, by = "cv_code"),
      mapuce_indcvi
    )
  ),
  tar_target(
    decoupage_admin_augmented,
    decoupage_admin %>%
      dplyr::left_join(
        lut_iris_atome_indcvi %>% dplyr::select(iris_code, atome_indcvi),
        by = "iris_code"
      )
  ),

  # --- 3. Données spatiales (millésime 2022) ---
  tar_target(
    spatial_iris,
    insee.admin.data.2022::insee_admin_spatial %>%
      sf::st_transform(4326) %>%
      dplyr::semi_join(lut_iris_atome_indcvi, by = "iris_code") %>%
      dplyr::left_join(lut_iris_atome_indcvi, by = "iris_code") %>%
      insee.admin::augment_admin_label_from_code(
        cog_nested_lut, .cols = c("cv_code", "dep_code", "reg_code")
      ) %>%
      dplyr::select(
        atome_indcvi, atome_indcvi_type, iris_code, iris_type, iris_label,
        com_arm_code, com_arm_label, cv_code, cv_label, dep_code, dep_label,
        reg_code, reg_label, geometry
      )
  ),
  tar_target(
    spatial_atome_indcvi,
    insee.admin.data.2022::insee_admin_spatial %>%
      sf::st_transform(4326) %>%
      dplyr::semi_join(lut_iris_atome_indcvi, by = "iris_code") %>%
      insee.rp::ins_sf_union_atome_indcvi(lut_iris_atome_indcvi) %>%
      dplyr::left_join(
        lut_iris_atome_indcvi %>%
          dplyr::distinct(atome_indcvi, atome_indcvi_type),
        by = "atome_indcvi"
      ) %>%
      dplyr::left_join(
        decoupage_admin_augmented %>%
          dplyr::distinct(atome_indcvi, cv_code, dep_code, reg_code),
        by = "atome_indcvi"
      ) %>%
      insee.admin::augment_admin_label_from_code(
        cog_nested_lut, .cols = c("cv_code", "dep_code", "reg_code")
      ) %>%
      dplyr::select(
        atome_indcvi, atome_indcvi_type, cv_code, cv_label, dep_code,
        dep_label, reg_code, reg_label, geometry
      )
  ),

  # --- 4. Sauvegarde des objets dans data/ ---
  tar_target(
    save_data,
    {
      usethis::use_data(
        mapuce_indcvi, lut_iris_atome_indcvi,
        spatial_iris, spatial_atome_indcvi,
        overwrite = TRUE, compress = "xz"
      )

      TRUE  # valeur de retour factice
    }
  ),

  # --- 5. Restriction IdF ---
  tar_target(
    lut_iris_atome_indcvi_za,
    lut_iris_atome_indcvi %>%
      dplyr::semi_join(
        insee.admin.data.2022::insee_admin_decoupage %>%
          dplyr::filter(reg_code == "11"),
        by = "iris_code"
      )
  ),
  tar_target(
    spatial_iris_za,
    spatial_iris %>% dplyr::semi_join(lut_iris_atome_indcvi_za, by = "iris_code")
  ),
  tar_target(
    spatial_atome_indcvi_za,
    spatial_atome_indcvi %>% dplyr::semi_join(lut_iris_atome_indcvi_za, by = "atome_indcvi")
  ),
  tar_target(
    mapuce_indcvi_za,
    mapuce_indcvi %>% dplyr::semi_join(lut_iris_atome_indcvi_za, by = "atome_indcvi")
  ),
  tar_target(
    save_data_za,
    {
      usethis::use_data(
        mapuce_indcvi_za, lut_iris_atome_indcvi_za,
        spatial_iris_za, spatial_atome_indcvi_za,
        overwrite = TRUE, compress = "xz"
      )

      TRUE
    }
  ),

  # --- 6. Compression finale ---
  ## Cette première méthode se réexecute à chaque fois, même si les données d'entrée n'ont pas été changée
  ## elle est abandonnée
  # tarchetypes::tar_force(
  #   compress_final,
  #   {
  #     save_data
  #     save_data_za
  #     optimise_rda_compression("data/")
  #     TRUE
  #   },
  #   force = TRUE
  # )
  tar_target(
    compress_final,
    {
      save_data      # déclare la dépendance
      save_data_za   # déclare la dépendance
      optimise_rda_compression("data/")
      TRUE
    },
    cue = tar_cue(mode = "never")
  )
)
