## code to prepare `DATASET` dataset goes here
## Ce code n'est pas exécuté, mais la commande ci-dessous est une sécurité sup.
if (FALSE) {
  devtools::load_all(".")
  library(dplyr)
  ## Données relatives aux datasets utilisés par l'application: package de données `mapuce.data.2020`
  ## Le millésime 2020 correspond à celui des fichiers detail RP INDCVI 2020
  ## Le découpage admin associé correspond au millésime 2022 (date de l'édition des résultats de RP 2020),
  ## Le millésime associé pour les données spatiales est également 2022...
  ### INSEE RP INDCVI: mêmes modalités de variables que pour RP INDCVI 2016
  # path_to_indcvi <- "/Users/Alexis/Documents/Travail/R/Packages/insee.rp.data.2020/inst/extdata/RP-detail/INDCVI/FD_INDCVI_2020.csv"
  path_to_indcvi <- insee.rp.data.2020::path_to_extdata("RP-detail/INDCVI/FD_INDCVI_2020.csv")
  mapuce_indcvi <- mapuce::pipeline_rp_indcvi_2016_to_mapuce(file = path_to_indcvi)

  ### Découpage IRIS et admin INSEE (semantic)
  decoupage_admin <- insee.admin.data.2022::insee_admin_decoupage
  ### Création du COG nested LUT pour récupérer les libellés des cv, dep et reg, ...
  cog_nested_lut <- insee.admin.data.2022::lut_code_label

  ### Création de la lut entre iris et atome_indcvi
  ## rappel: si les domaines ne correspondent pas à la même emprise
  ##   il faut alors restreindre le domaine d'étude (cf. rp-detail-indcvi.Rmd)
  (lut_iris_atome_indcvi <- insee.rp::ins_create_lut_atome_indcvi(
    decoupage_admin %>% dplyr::semi_join(mapuce_indcvi, by = "cv_code"),  # On se cantonne à la région IdF pour les tests (cv_code en commun)
    mapuce_indcvi))
  decoupage_admin_augmented <- decoupage_admin %>%
    dplyr::left_join(lut_iris_atome_indcvi %>% dplyr::select(dplyr::all_of(c("iris_code", "atome_indcvi"))), by = "iris_code")

  ### Fichier spatial à l'IRIS pour le millésime 2022
  spatial_iris <- insee.admin.data.2022::insee_admin_spatial %>%
    ## reprojection en WGS84
    sf::st_transform(4326) %>%
    ## restriction de la zone d'étude aux iris de la lut
    dplyr::semi_join(lut_iris_atome_indcvi, by = "iris_code") %>%
    ## ajout du atome_indcvi correspondant à chaque iris
    dplyr::left_join(lut_iris_atome_indcvi, by = "iris_code") %>%
    ## ajout des label pour cv, dep et reg
    insee.admin::augment_admin_label_from_code(cog_nested_lut, .cols = c("cv_code", "dep_code", "reg_code")) %>%
    dplyr::select(dplyr::all_of(c("atome_indcvi", "atome_indcvi_type",
                                  "iris_code", "iris_type", "iris_label",
                                  "com_arm_code", "com_arm_label",
                                  "cv_code", "cv_label", "dep_code", "dep_label",
                                  "reg_code", "reg_label", "geometry")))
  ### Fichier spatial à l'atome_indcvi pour le millésime 2022
  spatial_atome_indcvi <- insee.admin.data.2022::insee_admin_spatial %>%
    ## reprojection en WGS84
    sf::st_transform(4326) %>%
    ## Fusion des polygones iris_code vers atome_indcvi. Ce sont de toute façon la plus petite entité disponible dans indcvi
    ## restriction de la zone d'étude aux iris de la lut
    dplyr::semi_join(lut_iris_atome_indcvi, by = "iris_code") %>%
    ## fusion des polygones selon la maille atome_indcvi
    insee.rp::ins_sf_union_atome_indcvi(lut_iris_atome_indcvi) %>%
    dplyr::left_join(lut_iris_atome_indcvi %>%
                       dplyr::distinct(.data[["atome_indcvi"]], .data[["atome_indcvi_type"]]),
                     by = "atome_indcvi") %>%
    ## ajout des colonnes de niveau geo supérieur à atome_indcvi cv, dep et reg
    dplyr::left_join(decoupage_admin_augmented %>%
                       ## maj 2025-06-16: Cette ligne créait des doublons: utilisation de distinct
                       # dplyr::select(dplyr::all_of(c("atome_indcvi", "cv_code", "dep_code", "reg_code"))),
                     dplyr::distinct(.data[["atome_indcvi"]], .data[["cv_code"]], .data[["dep_code"]], .data[["reg_code"]]),
                     by = "atome_indcvi") %>%
    ## ajout des label pour cv, dep et reg
    insee.admin::augment_admin_label_from_code(cog_nested_lut, .cols = c("cv_code", "dep_code", "reg_code")) %>%
    dplyr::select(dplyr::all_of(c("atome_indcvi", "atome_indcvi_type",
                                  "cv_code", "cv_label", "dep_code", "dep_label",
                                  "reg_code", "reg_label", "geometry")))
    # dplyr::relocate("geometry", .after = reg_label)
  usethis::use_data(mapuce_indcvi, lut_iris_atome_indcvi, spatial_iris, spatial_atome_indcvi, overwrite = TRUE, compress = "xz")
  # ✔ Setting active project to "/Users/Alexis/Documents/Travail/R/Packages/mapuce.data.2020".
  # ✔ Saving "mapuce_indcvi", "lut_iris_atome_indcvi", "spatial_iris", and "spatial_atome_indcvi" to "data/mapuce_indcvi.rda", "data/lut_iris_atome_indcvi.rda",
  # "data/spatial_iris.rda", and "data/spatial_atome_indcvi.rda".
  # ☐ Document your data (see <https://r-pkgs.org/data.html>).


  ## Restriction à l'IdF: ZONE_A
  lut_iris_atome_indcvi_za <- lut_iris_atome_indcvi %>%
    dplyr::semi_join(insee.admin.data.2022::insee_admin_decoupage %>%
                       dplyr::filter(.data$reg_code == "11"), by = "iris_code")
  spatial_iris_za <- spatial_iris %>%
    dplyr::semi_join(lut_iris_atome_indcvi_za, by = "iris_code")
  spatial_atome_indcvi_za <- spatial_atome_indcvi %>%
    dplyr::semi_join(lut_iris_atome_indcvi_za, by = "atome_indcvi")
  mapuce_indcvi_za <- mapuce_indcvi %>%
    dplyr::semi_join(lut_iris_atome_indcvi_za, by = "atome_indcvi")
  usethis::use_data(mapuce_indcvi_za, lut_iris_atome_indcvi_za, spatial_iris_za, spatial_atome_indcvi_za, overwrite = TRUE, compress = "xz")
  # ✔ Saving "mapuce_indcvi_IdF", "lut_iris_atome_indcvi_IdF", "spatial_iris_IdF", and "spatial_atome_indcvi_IdF" to "data/mapuce_indcvi_IdF.rda",
  # "data/lut_iris_atome_indcvi_IdF.rda", "data/spatial_iris_IdF.rda", and "data/spatial_atome_indcvi_IdF.rda".
  # ☐ Document your data (see <https://r-pkgs.org/data.html>).

  ## ==========================================================================
  ## Data compression
  # Omitting compression_level defaults to 9
  # ## tools::resaveRdaFiles() doesn't support wildcards (*) in file paths like shell commands do.
  # # Find all .rda files starting with 'm' or 's' and ending with '_za.rda'
  # files_to_resave <- list.files(
  #   path = "data/",
  #   pattern = "^[ms].*_za\\.rda$",  # Regex: starts with m/s, ends with _za.rda
  #   full.names = TRUE
  # )
  # # Check which files are matched
  # list.files("data/", pattern = "^[ms].*_za\\.rda$")
  #
  # # Check working directory (should be package root)
  # getwd()

  # # Resave with xz compression
  # tools::resaveRdaFiles(files_to_resave, compress = "xz", compression_level = 9)
  # # compress_data()
  # # check_compression()
  # # Small datasets (<1MB)
  # # tools::resaveRdaFiles("data/lut_*.rda", compress = "bzip2")
  # tools::resaveRdaFiles("data/lut_*.rda", compress = "xz")
  #
  # # Medium datasets (1-10MB)
  # tools::resaveRdaFiles("data/[ms].*_za.rda", compress = "xz", compression_level = 6)
  # tools::resaveRdaFiles("data/spatial_atome_indcvi_za.rda", compress = "xz", compression_level = 6)
  # tools::resaveRdaFiles("data/spatial_iris_za.rda", compress = "xz", compression_level = 6)
  #
  # # Large spatial data (>10MB)
  # tools::resaveRdaFiles("data/mapuce_indcvi.rda", compress = "xz", compression_level = 9)
  # tools::resaveRdaFiles("data/mapuce_indcvi_za.rda", compress = "xz", compression_level = 9)
  # tools::resaveRdaFiles("data/spatial_atome_indcvi.rda", compress = "xz", compression_level = 9)
  # tools::resaveRdaFiles("data/spatial_iris.rda", compress = "xz", compression_level = 9)
}
