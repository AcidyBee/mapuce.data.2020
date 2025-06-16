#' Spatial dataset (sfc_multipolygon) at the IRIS granularity from IGN/INSEE COUTOURS-IRIS file for millesime 2022 for reg_code == "11"
#'
#' Spatial dataset (sfc_multipolygon) at the IRIS granularity from IGN/INSEE COUTOURS-IRIS file for millesime 2022 restricted to reg_code == "11".
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
#' @examples
#'   spatial_iris_IdF
#' @source <https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z>
"spatial_iris_IdF"
