% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{spatial_atome_indcvi_za}
\alias{spatial_atome_indcvi_za}
\title{Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022 for reg_code == "11"}
\format{
Data frame with 9 columns and 4307 rows
\describe{
\item{atome_indcvi}{atome_indcvi du lieu de résidence, 9 to 4 character}
\item{atome_indcvi_type}{Type de l'atome_indcvi, 1 character}
\item{cv_code}{Département, canton-ou-ville du lieu de résidence (pseudo-canton), 4 character}
\item{cv_label}{Libellé du Département, canton-ou-ville du lieu de résidence (pseudo-canton)}
\item{dep_code}{Département du lieu de résidence (pseudo-canton), 2 character}
\item{dep_label}{Libellé du Département du lieu de résidence (pseudo-canton)}
\item{reg_code}{Région du lieu de résidence (pseudo-canton), 2 character}
\item{reg_label}{Libellé du Région du lieu de résidence (pseudo-canton)}
\item{geometry}{Géométrie de l'IRIS, MULTIPOLYGON}
}
}
\source{
\url{https://data.geopf.fr/telechargement/download/CONTOURS-IRIS/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01/CONTOURS-IRIS_2-1__SHP__FRA_2022-01-01.7z}
}
\usage{
spatial_atome_indcvi_za
}
\description{
Spatial dataset (sfc_multipolygon) at the atome_indcvi granularity from union of polygons of IGN/INSEE COUTOURS-IRIS file for millesime 2022 restricted to reg_code == "11".
2 semantic columns + geometry for \code{metropole} with geodesic representation LAMB93.
Attention le fichier contours IRIS est donné dans le système Lambert 93,
mais les fichiers de découpage administratif sont donnés en WGS-84 !!!
}
\section{Versioning}{

This dataset is versioned using semantic versioning. Check attributes:
\code{attr(spatial_atome_indcvi_za, "version")}
Current version: 2020-v1.0
}

\examples{
  spatial_atome_indcvi_za
}
\keyword{datasets}
