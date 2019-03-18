
.onAttach <- function(...) {
  if (!inside_knitr()) {
    use_color()
    multicolor_logo()
  }
}
