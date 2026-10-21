# Ce script est un point d'entrée pour exécuter le pipeline targets
targets::tar_make(script = "data-raw/_targets.R")
# targets::tar_visnetwork(script = "data-raw/_targets.R")
# targets::tar_outdated(script = "data-raw/_targets.R")
# tar_sitrep()
