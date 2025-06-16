# #' Spatial Data (2020 RP + 2022 Admin)
# #' @name spatial_iris
# #' @description IRIS boundaries for RP 2020 data with 2022 admin borders
# NULL
#
# # #' Spatial Data (2018 RP + 2020 Admin)
# # #' @name spatial_iris_2018
# # #' @description IRIS boundaries for RP 2018 data with 2020 admin borders
# # NULL
#
# #' @title Zone-Based Data Access
# #' @description Retrieve data for specific INSEE zones:
# #' @name Zone_Based_Data_Access
# #' \describe{
# #'   \item{FRA}{France entière}
# #'   \item{ZONE_A}{Île-de-France (11)}
# #'   \item{ZONE_B}{Centre-Val de Loire (24), Bourgogne-Franche-Comté (27), Normandie (28), Hauts-de-France (32)}
# #'   \item{ZONE_C}{Grand Est (44), Pays de la Loire (52), Bretagne (53)}
# #'   \item{ZONE_D}{Nouvelle-Aquitaine (75), Occitanie (76)}
# #'   \item{ZONE_E}{Auvergne-Rhône-Alpes (84), PACA (93), Corse (94), DOM (01-04)}
# #' }
# #' @seealso \code{\link{get_data_by_zone}}
# NULL

#' @title IRIS Lookup Table for France, millesime 2020
#'
#' @description Mapping between IRIS codes and atomic statistical units for metropolitan France.
#' Look Up Table (lut) between iris_code and atome_indcvi, obtained by comparison
#' of administrative dataset from INSEE & RP INDCVI detail file 2020
#' @format Data frame with 3 columns and 48,510 rows
#' \describe{
#'    \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#'    \item{atome_indcvi}{atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#'    \item{atome_indcvi_type}{Type de l'atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(lut_iris_atome_indcvi, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   lut_iris_atome_indcvi
"lut_iris_atome_indcvi"

#' @title Semantic data for mapuce project, obtained from INSEE RP INDCVI detail file 2020
#'
#' @description Transformation on INSEE RP INDCVI detail file millesime 2020,
#' limited to columns related to mapuce project,
#' and rows corresponding to `LPRM == "1"` & `METRODOM == "M"` & `TYPL %in% c("1", "2")` (logement ordinaire: maison ou appartement)
#' @format Data frame with 17 columns and 8,690,731 rows
#' \describe{
#'   \item{atome_indcvi}{atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#'   \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#'   \item{iris_type}{Type de l'IRIS du lieu de résidence, 1 character}
#'   \item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 5 character}
#'   \item{arm_code}{Arrondissement municipal de résidence (Paris, Lyon et Marseille), 5 character}
#'   \item{ipondi}{Poids de l'individu, 17 numeric}
#'   \item{agerev}{Âge en années révolues détaillé de la perssone de référence du ménage, 3 character converti en integer à l'importation pour utilisation dans les modeles}
#'   \item{inper}{Nombre de personnes du ménage, converti en integer à l'importation pour utilisation dans les modeles}
#'   \item{couple}{Vie en couple (1=oui/2=non), factor}
#'   \item{typl_ma}{Type de logement maison ou appartement, factor}
#'   \item{chfl_3g}{Chauffage central du logement (France métropolitaine), factor}
#'   \item{cmbl_cre}{Combustible principal du logement (France métropolitaine), factor}
#'   \item{surf_6g_cont}{Superficie du logement en 6 groupes continu, integer}
#'   \item{surf_nbpi_4g}{Superficie du logement en 4 groupes, factor}
#'   \item{nperr_123}{Nombre de personnes du ménage (regroupé: 1, 2, 3 ou +), factor}
#'   \item{stocd_2g}{Statut d'occupation du logement en 2 groupes: propriétaires vs autres, factor}
#'   \item{atome_indcvi_typ}{Type de l'atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(mapuce_indcvi, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   mapuce_indcvi
"mapuce_indcvi"

#' @title Spatial dataset (sfc_multipolygon) at the IRIS granularity from IGN/INSEE COUTOURS-IRIS file for millesime 2022
#'
#' @description Spatial dataset (sfc_multipolygon) at the IRIS granularity from IGN/INSEE COUTOURS-IRIS file for millesime 2022.
#' 5 semantic columns + geometry for `metropole` with geodesic representation LAMB93.
#' Attention le fichier contours IRIS est donné dans le système Lambert 93,
#' mais les fichiers de découpage administratif sont donnés en WGS-84 !!!
#' @format Data frame with 14 columns and 48510 rows
#' \describe{
#'   \item{atome_indcvi}{atome_indcvi du lieu de résidence, 9 to 4 character}
#'   \item{atome_indcvi_type}{Type de l'atome_indcvi, 1 character}
#'   \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#'   \item{iris_type}{Type de l'IRIS, 1 character}
#'   \item{iris_label}{Nom de l'IRIS}
#'   \item{com_arm_code}{Code commune (concaténation DEPCOM) du lieu de résidence, ou ARM pour communes à arrondissement municipal (Lyon, Marseille et Paris), 5 character}
#'   \item{com_arm_label}{Nom de la commune ou de l'arrondissement municipal de résidence}
#'   \item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 4 character}
#'   \item{cv_label}{Libellé du Département, canton-ou-ville du lieu de résidence (pseudo-canton)}
#'   \item{dep_code}{Département du lieu de résidence (pseudo-canton), 2 character}
#'   \item{dep_label}{Libellé du Département du lieu de résidence (pseudo-canton)}
#'   \item{reg_code}{Région du lieu de résidence (pseudo-canton), 2 character}
#'   \item{reg_label}{Libellé du Région du lieu de résidence (pseudo-canton)}
#'   \item{geometry}{Géométrie de l'IRIS, MULTIPOLYGON}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(spatial_iris, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   spatial_iris
#' @source <https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z>
"spatial_iris"

#' @title Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022
#'
#' @description Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022.
#' 2 semantic columns + geometry for `metropole` with geodesic representation LAMB93.
#' Attention le fichier contours IRIS est donné dans le système Lambert 93,
#' mais les fichiers de découpage administratif sont donnés en WGS-84 !!!
#' @format Data frame with 9 columns and 16896 rows
#' \describe{
#'   \item{atome_indcvi}{atome_indcvi du lieu de résidence, 9 to 4 character}
#'   \item{atome_indcvi_type}{Type de l'atome_indcvi, 1 character}
#'   \item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 4 character}
#'   \item{cv_label}{Libellé du Département, canton-ou-ville du lieu de résidence (pseudo-canton)}
#'   \item{dep_code}{Département du lieu de résidence (pseudo-canton), 2 character}
#'   \item{dep_label}{Libellé du Département du lieu de résidence (pseudo-canton)}
#'   \item{reg_code}{Région du lieu de résidence (pseudo-canton), 2 character}
#'   \item{reg_label}{Libellé du Région du lieu de résidence (pseudo-canton)}
#'   \item{geometry}{Géométrie de l'IRIS, MULTIPOLYGON}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(spatial_atome_indcvi, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   spatial_atome_indcvi
#' @source <https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z>
"spatial_atome_indcvi"

## ZONE A: REG == "11" (Ile de France)

#' @title IRIS Lookup Table for France, millesime 2020 restricted to zone A: reg_code == "11"
#'
#' @description Look Up Table (lut) between iris_code and atome_indcvi, obtained by comparison of
#' administrative dataset from INSEE & RP INDCVI detail file 2020 for reg_code == "11".
#' @format Data frame with 3 columns and 5,238 rows
#' \describe{
#'    \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#'    \item{atome_indcvi}{atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#'    \item{atome_indcvi_type}{Type de l'atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(lut_iris_atome_indcvi_za, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   lut_iris_atome_indcvi_za
"lut_iris_atome_indcvi_za"

#' @title Semantic data for mapuce project (IdF), obtained from INSEE RP INDCVI detail file 2020 for reg_code == "11"
#'
#' @description Transformation on INSEE RP INDCVI detail file millesime 2020 restricted to reg_code == "11",
#' limited to columns related to mapuce project,
#' and rows corresponding to `LPRM == "1"` & `METRODOM == "M"` & `TYPL %in% c("1", "2")` (logement ordinaire: maison ou appartement)
#' @format Data frame with 17 columns and 1,877,194 rows
#' \describe{
#' \item{atome_indcvi}{atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#' \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#' \item{iris_type}{Type de l'IRIS du lieu de résidence, 1 character}
#' \item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 5 character}
#' \item{arm_code}{Arrondissement municipal de résidence (Paris, Lyon et Marseille), 5 character}
#' \item{ipondi}{Poids de l'individu, 17 numeric}
#' \item{agerev}{Âge en années révolues détaillé de la perssone de référence du ménage, 3 character converti en integer à l'importation pour utilisation dans les modeles}
#' \item{inper}{Nombre de personnes du ménage, converti en integer à l'importation pour utilisation dans les modeles}
#' \item{couple}{Vie en couple (1=oui/2=non), factor}
#' \item{typl_ma}{Type de logement maison ou appartement, factor}
#' \item{chfl_3g}{Chauffage central du logement (France métropolitaine), factor}
#' \item{cmbl_cre}{Combustible principal du logement (France métropolitaine), factor}
#' \item{surf_6g_cont}{Superficie du logement en 6 groupes continu, integer}
#' \item{surf_nbpi_4g}{Superficie du logement en 4 groupes, factor}
#' \item{nperr_123}{Nombre de personnes du ménage (regroupé: 1, 2, 3 ou +), factor}
#' \item{stocd_2g}{Statut d'occupation du logement en 2 groupes: propriétaires vs autres, factor}
#' \item{atome_indcvi_typ}{Type de l'atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(mapuce_indcvi_za, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   mapuce_indcvi_za
"mapuce_indcvi_za"

#' @title Spatial dataset (sfc_multipolygon) at the IRIS granularity from IGN/INSEE COUTOURS-IRIS file for millesime 2022 for reg_code == "11"
#'
#' @description Spatial dataset (sfc_multipolygon) at the IRIS granularity from IGN/INSEE COUTOURS-IRIS file for millesime 2022 restricted to reg_code == "11".
#' 5 semantic columns + geometry for `metropole` with geodesic representation LAMB93.
#' Attention le fichier contours IRIS est donné dans le système Lambert 93,
#' mais les fichiers de découpage administratif sont donnés en WGS-84 !!!
#' @format Data frame with 14 columns and 5238 rows
#' \describe{
#'   \item{atome_indcvi}{atome_indcvi du lieu de résidence, 9 to 4 character}
#'   \item{atome_indcvi_type}{Type de l'atome_indcvi, 1 character}
#'   \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#'   \item{iris_type}{Type de l'IRIS, 1 character}
#'   \item{iris_label}{Nom de l'IRIS}
#'   \item{com_arm_code}{Code commune (concaténation DEPCOM) du lieu de résidence, ou ARM pour communes à arrondissement municipal (Lyon, Marseille et Paris), 5 character}
#'   \item{com_arm_label}{Nom de la commune ou de l'arrondissement municipal de résidence}
#'   \item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 4 character}
#'   \item{cv_label}{Libellé du Département, canton-ou-ville du lieu de résidence (pseudo-canton)}
#'   \item{dep_code}{Département du lieu de résidence (pseudo-canton), 2 character}
#'   \item{dep_label}{Libellé du Département du lieu de résidence (pseudo-canton)}
#'   \item{reg_code}{Région du lieu de résidence (pseudo-canton), 2 character}
#'   \item{reg_label}{Libellé du Région du lieu de résidence (pseudo-canton)}
#'   \item{geometry}{Géométrie de l'IRIS, MULTIPOLYGON}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(spatial_iris_za, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   spatial_iris_za
#' @source <https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z>
"spatial_iris_za"

#' @title Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022 for reg_code == "11"
#'
#' @description Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022 restricted to reg_code == "11".
#' 2 semantic columns + geometry for `metropole` with geodesic representation LAMB93.
#' Attention le fichier contours IRIS est donné dans le système Lambert 93,
#' mais les fichiers de découpage administratif sont donnés en WGS-84 !!!
#' @format Data frame with 9 columns and 4307 rows
#' \describe{
#'   \item{atome_indcvi}{atome_indcvi du lieu de résidence, 9 to 4 character}
#'   \item{atome_indcvi_type}{Type de l'atome_indcvi, 1 character}
#'   \item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 4 character}
#'   \item{cv_label}{Libellé du Département, canton-ou-ville du lieu de résidence (pseudo-canton)}
#'   \item{dep_code}{Département du lieu de résidence (pseudo-canton), 2 character}
#'   \item{dep_label}{Libellé du Département du lieu de résidence (pseudo-canton)}
#'   \item{reg_code}{Région du lieu de résidence (pseudo-canton), 2 character}
#'   \item{reg_label}{Libellé du Région du lieu de résidence (pseudo-canton)}
#'   \item{geometry}{Géométrie de l'IRIS, MULTIPOLYGON}
#' }
#' @section Versioning:
#' This dataset is versioned using semantic versioning. Check attributes:
#' \code{attr(spatial_atome_indcvi_za, "version")}
#' Current version: 2020-v1.0
#' @examples
#'   spatial_atome_indcvi_za
#' @source <https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z>
"spatial_atome_indcvi_za"
