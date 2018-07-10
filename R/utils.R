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
                                       bg = FALSE, num_colors = 1, grey = FALSE
    )
  } else if (!crayon:::is_r_color(c)) {
    o_c <- crayon:::style_from_rgb(c,
                                   bg = FALSE, num_colors = 1, grey = FALSE
    )
  }
  out <- tibble::as_tibble(o_c)
  return(o_c)
}

# Change "rainbow" into c("red", "orange", "yellow", "green", "blue", "purple")
insert_rainbow <- function(clr) {
  if (any(clr == "rainbow")) {
    rb_idx <- which(clr == "rainbow")
    clr[rb_idx] <- list(c("red", "orange", "yellow", "green", "blue", "purple"))
    clr <- unlist(clr)
  }
  return(clr)
}
