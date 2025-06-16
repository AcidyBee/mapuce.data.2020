# Configuration for different millésimes
millesime_config <- list(
  "2020" = list(
    rp_pkg = "insee.rp.data.2020",
    admin_pkg = "insee.admin.data.2022",
    indcvi_file = "RP-detail/INDCVI/FD_INDCVI_2020.csv",
    pipeline_func = mapuce::pipeline_rp_indcvi_2016_to_mapuce
  ),
  # # Add configurations for other years following the same pattern
  # "2018" = list(
  #   rp_pkg = "insee.rp.data.2018",
  #   admin_pkg = "insee.admin.data.2020",
  #   indcvi_file = "RP-detail/INDCVI/FD_INDCVI_2018.csv",
  #   pipeline_func = mapuce::pipeline_rp_indcvi_2016_to_mapuce
  # )
)
