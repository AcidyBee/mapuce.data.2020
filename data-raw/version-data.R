library(mapuce.data.2020)
library(tools)

# Define version
DATA_VERSION <- "2020-v1.0"  # Update with each release

# List all datasets
datasets <- c(
  "lut_iris_atome_indcvi", "lut_iris_atome_indcvi_za",
  "mapuce_indcvi", "mapuce_indcvi_za",
  "spatial_iris", "spatial_iris_za",
  "spatial_atome_indcvi", "spatial_atome_indcvi_za"
)

# Apply versioning and save
for (ds in datasets) {
  data(list = ds, envir = environment())
  obj <- get(ds)

  # Set version attribute
  attr(obj, "version") <- DATA_VERSION

  # Set metadata attributes
  attr(obj, "timestamp") <- Sys.time()
  attr(obj, "geographic_scope") <- ifelse(grepl("_IdF$", ds), "Île-de-France", "France")

  # Re-save with compression
  assign(ds, obj)
  save(
    list = ds,
    file = file.path("data", paste0(ds, ".rda")),
    compress = "xz",
    version = 2
  )
}

# Verify attributes
check_versions <- function() {
  for (ds in datasets) {
    data(list = ds, envir = environment())
    cat(ds, ":", attr(get(ds), "version"), "\n")
  }
}
check_versions()
