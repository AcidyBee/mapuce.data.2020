library(targets)
library(htmltools)

# Sauvegarde le graphe dans un fichier HTML temporaire
save_html(
  html = tar_visnetwork(
    script = "data-raw/_targets.R",
    names = "compress_final",
    targets_only = TRUE
  ),
  file = "data-raw/pipeline_graph.html"
)

webshot2::webshot(
  url = "data-raw/pipeline_graph.html",
  file = "man/figures/README-pipeline.png",
  vwidth = 1200,   # largeur de la fenêtre de capture
  vheight = 800,   # hauteur
  zoom = 2         # améliore la netteté sur les écrans HiDPI
)
