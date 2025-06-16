if (FALSE) {

# Création du package
name_package <- "mapuce.data.2020"
available::available(name_package) # OK
usethis::create_package(file.path("/Users/Alexis/Documents/Travail/R/Packages", name_package))

## Gestion du .Rbuildignore
usethis::use_build_ignore("devtools_history.R")
# usethis::use_build_ignore("output")

## Licence
# usethis::use_gpl3_license()
usethis::use_mit_license()

# Depend on R version 4.1
# usethis::use_package("R", type = "Depends", min_version = "4.1")
## La dépendance à la version 4.1 était justifiée par l'utilisation du pipe de base R `|>`
## il semble plus judicieux de retirer cette dépendance et de la substituer par l'utilisation du pipe de magritr (importé dans le package)
usethis::use_pipe()
# usethis::use_package("R", type = "Depends", min_version = "2.10")
# utils::globalVariables(".data") # A ajouter dans sysdata.R ??

## Orders and formats DESCRIPTION fields according to a fixed standard
usethis::use_tidy_description()

# Dependances
# usethis::use_package('vroom', type = "Imports")
# usethis::use_package('dplyr', type = "Imports", min_version = "1.1.1")
# usethis::use_package('purrr', type = "Imports", min_version = "1.0.0")
# usethis::use_package('tibble', type = "Imports")
# usethis::use_package('cleanser', type = "Imports")
# usethis::use_package('stringr', type = "Imports")
# usethis::use_package('insee.rp', type = "Imports")
# usethis::use_package('lubridate', type = "Imports", min_version = "1.5.0")
# usethis::use_package('forcats', type = "Imports", min_version = "1.0.0")
# usethis::use_package('rlang', type = "Imports", min_version = "1.0.0")
# usethis::use_package('time.machine', type = "Imports")

# usethis::use_package('rlang', type = "Imports", min_version = "1.0.0")
# usethis::use_package('checkupr', type = "Suggests")
# usethis::use_package("stringi", type = "Imports", min_version = "1.8.3")
# usethis::use_package('time.machine', type = "Imports")

# usethis::use_package('readxl', type = "Imports", min_version = "1.4.0")
# usethis::use_package('readr', type = "Imports", min_version = "2.0.0")

## packages dans les vignettes
usethis::use_package('dplyr', type = "Suggests")
usethis::use_package('ggplot2', type = "Suggests")
# usethis::use_package('arsenal', type = "Suggests", min_version = "3.6.3")
# usethis::use_package('arsenal.extension', type = "Suggests")
# usethis::use_package('survival', type = "Suggests")
# usethis::use_package('survminer', type = "Suggests")
#
# usethis::use_package('tidyselect', type = "Imports", min_version = "1.1.0")
# usethis::use_package('tidyr', type = "Imports", min_version = "1.0.0")
# usethis::use_package("data.table", type = "Imports")
# usethis::use_package('DT', type = "Suggests")
## DONE: compiler medikit pour l'importer
# usethis::use_package('medikit', type = "Imports")
# usethis::use_package('stats', type = "Imports")


# usethis::use_package('vroom', type = "Imports", min_version = "1.1.0")
# # usethis::use_package('tidyverse', type = "Imports", min_version = "1.3.0") # good-practices: lister les packages individuellement
#
# usethis::use_package('forcats', type = "Imports", min_version = "1.0.0")
# usethis::use_package('stringi', type = "Imports")
# usethis::use_package("janitor", type = "Imports")
# usethis::use_package('cellranger', type = "Imports", min_version = "1.1.0")
# usethis::use_package('rlang', type = "Suggests", min_version = "1.0.0")
#

## Data
usethis::use_data_raw()
# -> la création des data est réalisée dans "data-raw/DATASET.R"
# y compris la création des lazydata dans "data/"

usethis::use_package_doc()

usethis::use_readme_rmd()

## TODO: les spatial_atome_indcvi ont des polygones redondants, il faut les supprimer

## Création des vignettes
# usethis::use_vignette("check-datasets")

## Création des unit-tests
# usethis::use_testthat(3)
# devtools::test()
# usethis::use_test(name = "recode")

## Package workflow
# documente les fonctions
# roxygen2::roxygenize(clean = TRUE)
devtools::document()
# charge les fonctions dans l'environnement
devtools::load_all()
devtools::check()
# Remove existing files
# unlink("data/*_IdF.rda")

## installation locale du package :)
## en cas de bug
# remove.packages(name_package)
# .rs.restartR()
devtools::install()

## Gestion des versions
usethis::use_version()

}
