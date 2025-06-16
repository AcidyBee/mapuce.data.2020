#' Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022
#'
#'  Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022.
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
#' @examples
#'   spatial_atome_indcvi
#' @source <https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z>
"spatial_atome_indcvi"
