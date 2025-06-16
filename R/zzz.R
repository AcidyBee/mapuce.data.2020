.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "This package contains large datasets (~160.1MB). ",
    "Use data('dataset_name') to load selectively."
  )
}
