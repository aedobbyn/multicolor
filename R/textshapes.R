#' Turn strings into triangle-shaped strings
#'
#' @export
#' @details Use positive step argument for upward pointing triangle
#' and negative step and wider maxlen for downward pointing triangle.
#' @param string (character) Some text to reshape into a triangle.
#' @param maxlen (integer) Width of top of triangle. Defaults to 1. Set larger than 1 for downward-pointing triangle.
#' @param step (integer) Number of characters to expand or contract triangle width per line (set to negative for downward-pointing triangle)
#' @param display (logical) Returns string invisibly if FALSE (default), set to TRUE to display returned string
#'
#' @return A string
#'
#' @examples
#' triangle_string("hellooooooooooooooooooooooooooooooooooooooooooooooooooo world") %>%
#'   multi_color()

triangle_string <- function(string, maxlen = 1, step = 1, display = FALSE) { #nocov start
  # if maxlen == 0 then stop, no more lines left
  if (maxlen == 0) return("\n")

  # string shorter than maxlen, return full string
  if (stringr::str_length(string) <= maxlen) return(string)

  # recursively print maxlen characters and start new line
  output <- rev(stringr::str_c(
    stringr::str_sub(string, 1, maxlen), "\n",
    triangle_string(stringr::str_sub(string, maxlen + 1, stringr::str_length(string)),
                    maxlen = maxlen + step,
                    step = step)
  ))

  ifelse(display, return(output), return(invisible(output)))
} # nocov end


#' Center all lines of a string relative to console width.
#'
#' @export
#' @details To removes last line break set \code{removelastbreak} to TRUE.
#'
#' @param string (character) Some text to center within console.
#' @param remove_last_break (logical) Set to TRUE to remove last line break. Defaults to FALSE.
#' @param display (logical) Returns string invisibly if FALSE (default), set to TRUE to display returned string
#'
#' @return A string
#'
#' @examples
#' triangle_string(starwars_intro, display = TRUE) %>%
#'   center_string() %>%
#'   multi_color(direction = "horizontal", recycle_chars = TRUE)

center_string <- function(string, remove_last_break = TRUE, display = FALSE) { #nocov start
  width <- getOption("width")
  output <- ""

  strings <- stringr::str_split(string, "\n") %>% unlist()

  for (string in strings) {
    buffer_len <- floor((width - stringr::str_length(string)) / 2)
    if (buffer_len < 0) buffer_len <- 0
    spaces <- stringr::str_flatten(rep(" ", buffer_len))
    output <- stringr::str_c(output, spaces, string, spaces, "\n")
  }

  if (remove_last_break == TRUE) {
    output <- stringi::stri_replace_last(output, fixed = "\n", "")
    output <- stringi::stri_replace_last(output, regex = "\\s+", "")
  }

  ifelse(display, return(output), return(invisible(output)))
} #nocov end
