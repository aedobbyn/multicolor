#' Multi-color crawling text (works on single lines of text only)
#'
#' @export
#'
#' @param txt (character) Some text to color, stripped of line breaks
#' @param colors (character) A vector of colors, defaulting to
#' the Viridis Plasma palette.
#'
#' Must all be \href{https://github.com/r-lib/crayon#256-colors}{\code{crayon}}-supported
#' colors. Any colors in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#' @param dir (numeric: -1 or 1) direction of colors, defaults to brighter to darker
#' @param pause (numeric) Pause between characters in seconds, default=0
#' @param ... Further args.
#'
#' @details This function requires as many colors as there are characters in your string and
#' prints them one at a time. Provided colors will be recycled if needed.
#'
#' It cannot be used with RGUI (R.app on some systems).
#'
#' @return A string
#'
#' @examples \dontrun{
#' mc_crawl()
#'
#' mc_crawl("It was a dark and stormy night")
#'
#' options("keep.source=F")
#' cat("\014")
#' mc_crawl('A long time ago in a galaxy far, far away...')
#' cat('\n')
#' cat('\n')
#' mc_crawl("It is a period of civil war. Rebel spaceships, striking from a hidden base,")
#' cat('\n')
#' mc_crawl('have won their first victory against the evil Galactic Empire.',dir=1)
#'
#'
#' }

mc_crawl <- function(txt='hello world!', colors=NA, dir= -1, pause=0,...) {

  if (use_color() == FALSE) stop("Colors cannot be applied in this environment. Please use another application, such as RStudio or a color-enabled terminal.")

  if (anyNA(colors)) colors <- viridisLite::plasma(stringr::str_length(txt)+1, direction = dir,begin=0.3)

  colors <- rep(colors,length.out=stringr::str_length(txt)+1)

  for (i in 1:(stringr::str_length(txt))) {
    multi_color(stringr::str_sub(txt,i,i), colors=colors[ (1+((i-1) %% (length(colors)))):(2+((i-1) %% (length(colors))))],
                type='crawl',...)
    Sys.sleep(pause)
  }
}
