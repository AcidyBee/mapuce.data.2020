# Process all configured millésimes
purrr::walk(names(millesime_config), prepare_millesime_data)

# Or process specific years:
# prepare_millesime_data("2020")
# prepare_millesime_data("2018")
