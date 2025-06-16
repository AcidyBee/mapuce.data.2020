#' @title IRIS Lookup Table for France
#'
#' Mapping between IRIS codes and atomic statistical units for metropolitan France.
#' Look Up Table (lut) between iris_code and atome_indcvi, obtained by comparison
#' of administrative dataset from INSEE & RP INDCVI detail file 2020
#' @format Data frame with 3 columns and 48,510 rows
#' \describe{
#'    \item{atome_indcvi}{atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#'    \item{iris_code}{Code IRIS du lieu de résidence, 9 character}
#'    \item{atome_indcvi_typ}{Type de l'atome_indcvi du lieu de résidence s'il est défini, cv_code sinon, 9 ou 5 character}
#' }
#' @examples
#'   lut_iris_atome_indcvi
"lut_iris_atome_indcvi"
