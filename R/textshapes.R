#' Turn strings into triangle-shaped strings
#'
#' @export
#' @details Use positive step argument for upward pointing triangle
#' and negative step and wider maxlen for downward pointing triangle.
#' @param string (character) Some text to reshape into a triangle.
#' @param maxlen (integer) width of top of triangle, defaults to 1, set larger than 1 for downward-pointing triangle
#' @param step (integer) Number of characters to expand or contract triangle width per line (set to negative for downward-pointing triangle)
#' @param display (logical) Returns string invisibly if FALSE (default), set to TRUE to display returned string
#'
#' @return A string
#'

triangle_string <- function(string, maxlen=1, step=+1, display=FALSE) {
  # if maxlen == 0 then stop, no more lines left
  if (maxlen == 0) return('\n')

  # string shorter than maxlen, return full string
  if (stringr::str_length(string) <= maxlen) return(string)

  # recursively print maxlen characters and start new line
  output <- rev(stringr::str_c(stringr::str_sub(string, 1, maxlen),'\n',
                      triangle_string(stringr::str_sub(string, maxlen+1, stringr::str_length(string)), maxlen=maxlen+step, step=step)))

  ifelse(display, return(output), return(invisible(output)) )
}


#' Center all lines of a string relative to console width.
#'
#' @export
#' @details To removes last line break set \code{removelastbreak} to TRUE.
#'
#' @param string (character) Some text to center within console.
#' @param removelastbreak (logical) Set to TRUE to removes last line break, defaults to FALSE.
#' @param display (logical) Returns string invisibly if FALSE (default), set to TRUE to display returned string
#'
#' @return A string
#'

center_string <- function(string, removelastbreak=TRUE, display=FALSE) {
  width <- getOption("width")
  output <- ''

  strings <- stringr::str_split(string, "\n")
  strings <- unlist(strings)
  for (string in strings) {
    spaces <- stringr::str_flatten(rep(" ", floor((width - stringr::str_length(string))/2)))
    output <- stringr::str_c(output, spaces, string, spaces,'\n') }

  if (removelastbreak==T) {
    output <- stringi::stri_replace_last(output,fixed='\n','')
    output <- stringi::stri_replace_last(output,fixed='\n','')
    output <- stringi::stri_replace_last(output,regex ='\\s+','')
    output <- stringi::stri_replace_last(output,regex ='\\s+','')
  }

  ifelse(display, return(output), return(invisible(output)))   }
