# adapted from https://stackoverflow.com/questions/12389158/check-if-r-is-running-in-rstudio
# is_r_gui <- Sys.getenv("R_GUI_APP_VERSION") != ""
# is_r_gui <- .Platform$GUI == "AQUA"

use_color <- function() {
  is_r_gui <- Sys.getenv("R_GUI_APP_VERSION") != ""
  can_color <- TRUE
  if (is_r_gui) {
    can_color <- FALSE
    message("Envoronment is RGUI, so colors cannot be applied. Please use another application, such as RStudio or a terminal.")
  }
  invisible(can_color)
}

.onAttach <- function(...){
  use_color()
}
