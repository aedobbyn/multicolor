#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

# Grab the color opening and closing tags for a given color
get_open_close <- function(c) {
  if (crayon:::is_r_color(c)) {
    o_c <- crayon:::style_from_r_color(c,
      bg = FALSE, num_colors = 256, grey = FALSE
    )
  } else if (!crayon:::is_r_color(c)) {
    o_c <- crayon:::style_from_rgb(c,
      bg = FALSE, num_colors = 256, grey = FALSE
    )
  }
  out <- tibble::as_tibble(o_c)
  return(o_c)
}


#' Insert Rainbow
#'
#' Take the string "rainbow" and replace it with c("red", "orange", "yellow", "green", "blue", "purple")
#'
#' @param clr (character) A vector of one or more colors.
#'
#' @return A character vector of color names.
#' @export
#'
#' @examples
#'
#' insert_rainbow("rainbow")
#' insert_rainbow(c("lightsteelblue", "rainbow", "lightsalmon"))

insert_rainbow <- function(clr) {
  if (inherits(clr, "crayon")) {
    return(clr)
  } else if (any(clr == "rainbow")) {
    rb_idx <- which(clr == "rainbow")
    clr[rb_idx] <- list(c("red", "orange", "yellow", "green", "blue", "purple"))
    clr <- unlist(clr)
  }
  return(clr)
}
