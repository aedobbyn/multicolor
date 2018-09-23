#' Multi-color crawling text
#'
#' @description This function crawls over \code{txt} producing an animated gif-like
#' representation of the text unfolding from left to right or top to bottom,
#' depending on \code{direction}, colored according to \code{colors}.
#'
#' @param txt (character) Some text to color, stripped of line breaks
#' @param colors (character) A vector of colors to color each individual character, if
#' \code{recycle_chars} is TRUE, or the whole string if FALSE, defaulting to
#' the Viridis Plasma palette.
#' Must all be \href{https://github.com/r-lib/crayon#256-colors}{\code{crayon}}-supported
#' colors. Any colors in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#' @param recycle_chars (logical) Should the vector of colors supplied apply to the entire string or
#' should it apply to each individual character (if \code{direction} is vertical)
#' or line (if \code{direction} is horizontal), and be recycled?
#' @param direction (character) How should the colors be spread? One of
#' "horizontal" or "vertical".
#' @param pause (numeric) Seconds to pause between characters in seconds.
#' @param ... Further args passed to \code{\link{multi_color}}.
#'
#' @details This function requires as many colors as there are characters in your string and
#' prints them one at a time.
#' \code{colors} will be recycled in single-color equal-sized chunks if \code{recycle_char} is FALSE and
#' character-by-character if \code{recycle_char} is TRUE.
#'
#' Colors cannot be applied in RGUI (R.app on some systems) or other environments that do not support
#' colored text. In these cases, the \code{txt} will simply be crawled over without applying colors.
#'
#' @return A string, printed in \code{colors} with \code{pause} seconds between printing each character.
#'
#' @export
#'
#' @examples \dontrun{
#' crawl()
#'
#' crawl("It was a dark and stormy night")
#'
#' crawl("Taste the rainbow", colors = "rainbow")
#'
#' crawl(things[["hypnotoad"]], colors = c("purple", "blue", "cyan"),
#'   direction = "horizontal", recycle_chars = TRUE, pause = 0.01)
#'
#' options("keep.source = FALSE")
#' crawl('\014A long time ago in a galaxy far, far away...
#' It is a period of civil war. Rebel spaceships, striking from a hidden base,
#' have won their first victory against the evil Galactic Empire.')
#' }

crawl <- function(txt = "hello world!",
                  colors = NULL,
                  recycle_chars = FALSE,
                  direction = "vertical",
                  pause = 0.05,
                  ...) {
  if (!is.character(txt) || length(txt) != 1) {
    stop("txt must be a character vector of length 1.")
  }

  if (!is.numeric(pause) || pause < 0) stop("pause must be a number > 0.")

  if (is.null(colors)) colors <- viridisLite::plasma(stringr::str_length(txt), direction = -1, begin = 0.3)

  if (use_color() == FALSE) {
    message("Colors cannot be applied in this environment. Please use another application, such as RStudio or a color-enabled terminal.")
    for (i in seq(nchar(txt))) {
      cat(substr(txt, i, i))
      Sys.sleep(pause)
    }
  } else {
    vec <- multi_color(txt,
                       colors = colors,
                       direction = direction,
                       recycle_chars = recycle_chars,
                       type = "crawl", ...)

    for (i in seq_along(vec)) {
      cat(vec[i])
      Sys.sleep(pause)
    }
  }
}
