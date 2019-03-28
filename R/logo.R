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

  logo_color_palettes <- list(
    lacroix = c("#C70E7B", "#FC6882", "#007BC3", "#54BCD1", "#EF7C12", "#F4B95A", "#009F3F", "#8FDA04", "#AF6125", "#F4E3C7"),
    magma = c("#FCFDBFFF", "#FDDEA0FF", "#FEBF84FF", "#FE9F6DFF", "#FA7F5EFF", "#F1605DFF", "#DE4968FF", "#C43C75FF", "#A8327DFF", "#8C2981FF"),
    grandbudapest = c("#F1BB7B", "#F59E74", "#F9816D", "#FD6467", "#C74B4C", "#913232", "#5B1A18", "#833721", "#AC542C", "#D67236")
  )

  mc_logo <- "                   _                   _
                  | |    o            | |
 _  _  _          | |_|_     __   __  | |  __   ,_
/ |/ |/ |  |   |  |/  |  |  /    /  \\_|/  /  \\_/  |
  |  |  |_/ \\_/|_/|__/|_/|_/\\___/\\__/ |__/\\__/    |_/"


  multi_color(
    mc_logo,
    direction = "vertical",
    colors = logo_color_palettes[[sample(length(logo_color_palettes), 1)]]
  )
}
