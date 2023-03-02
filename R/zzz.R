
use_color_startup <- function() {
  can_color <- invisible(crayon::has_color())
  if (!can_color) {
    packageStartupMessage("Colors cannot be applied in this environment. Please use another application, such as RStudio or a color-enabled terminal.")
  }
  can_color
}

.onAttach <- function(...) {
  if (!inside_knitr()) {
    use_color_startup()
    multicolor_logo()
  }
}
