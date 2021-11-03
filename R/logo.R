#' The multicolor package logo
#'
#' @param colors Vector of colors for the logo. Defaults to "random" which randomly selects one of the \code{palette}s.
#' @param ... Arguments passed to \code{multi_color}.
#'
#' @md
#' @export
#' @details This function displays the multicolor package logo
#' in a randomly selected color palette from a pre-selected list of colors.
#'
#' @examples
#' multicolor_logo()
#' multicolor_logo(recycle_chars = TRUE)
#' multicolor_logo(colors = c("red", "blue"))
multicolor_logo <- function(colors = "random", ...) {
  if (use_color() == FALSE || inside_knitr()) {
    return(invisible)
  }

  mc_logo <- "                   _                   _
                  | |    o            | |
 _  _  _          | |_|_     __   __  | |  __   ,_
/ |/ |/ |  |   |  |/  |  |  /    /  \\_|/  /  \\_/  |
  |  |  |_/ \\_/|_/|__/|_/|_/\\___/\\__/ |__/\\__/    |_/"

  if (length(colors) == 1 && colors == "random") {
    colors <- palettes[[sample(length(palettes), 1)]]
  }

  multi_color(
    mc_logo,
    direction = "vertical",
    colors = colors,
    ...
  )
}
