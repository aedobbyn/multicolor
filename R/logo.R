#' The multicolor package logo
#'
#' @param ... Arguments passed to \code{multi_color}.
#'
#' @md
#' @export
#' @details This function displays the multicolor package logo
#' in a randomly selected color palette from a pre-selected list of colors.
#'
#' @examples
#' multicolor_logo()

multicolor_logo <- function(...) {
  if (use_color() == FALSE || inside_knitr()) {
    return(invisible)
  }

  mc_logo <- "                   _                   _
                  | |    o            | |
 _  _  _          | |_|_     __   __  | |  __   ,_
/ |/ |/ |  |   |  |/  |  |  /    /  \\_|/  /  \\_/  |
  |  |  |_/ \\_/|_/|__/|_/|_/\\___/\\__/ |__/\\__/    |_/"


  multi_color(
    mc_logo,
    direction = "vertical",
    colors = palettes[[sample(length(palettes), 1)]]
  )
}
