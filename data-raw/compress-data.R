library(tools)

# Define compression rules
compress_data <- function() {
  # Small datasets (<1MB)
  tools::resaveRdaFiles("data/lut_*.rda", compress = "bzip2")

  # Medium datasets (1-10MB)
  tools::resaveRdaFiles("data/*_z[a-e](?:_\\d{4})?.rda", compress = "xz", compression_level = 6)

  # Large spatial data (>10MB)
  tools::resaveRdaFiles("data/[ms]*[is](?:_\\d{4})?.rda", compress = "xz", compression_level = 9)
}

# Verify compression
check_compression <- function() {
  print(tools::checkRdaFiles("data/"))
}




# Sys.glob(c("data/[ms]*[is].rda"))
# # Save with optimal compression:: xz for files >1MB
# # for all but lut files
# tools::resaveRdaFiles(Sys.glob(c("data/[ms]*.rda", "data/*.RData")), compress="xz")  # For >1MB files
# tools::checkRdaFiles("data/")  # Verify compression
