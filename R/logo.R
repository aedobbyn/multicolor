#' The multicolor package logo
#'
#' @param ... Arguments passed to \code{multi_color}.
#' @param display_in_knitr Should the logo be displayed when \code{multicolor} is loaded in an RMarkdown document.
#'
#' @md
#' @export
#' @examples
#' multicolor_logo()

multicolor_logo <- function(display_in_knitr = FALSE, ...) {

  if (use_color() == FALSE || inside_knitr() && display_in_knitr == FALSE) {
    return(invisible)
  }

  logo_colors <- c("#C70E7B", "#FC6882", "#007BC3", "#54BCD1", "#EF7C12", "#F4B95A", "#009F3F", "#8FDA04", "#AF6125", "#F4E3C7")

  mc_logo <- "                   _                   _
                  | |    o            | |
 _  _  _          | |_|_     __   __  | |  __   ,_
/ |/ |/ |  |   |  |/  |  |  /    /  \\_|/  /  \\_/  |
  |  |  |_/ \\_/|_/|__/|_/|_/\\___/\\__/ |__/\\__/    |_/"

  multi_color(mc_logo, direction = "vertical", colors = logo_colors, ...)
}
