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


on_windows <- function() {
  os <- tolower(Sys.info()[["sysname"]])

  if ("windows" %in% os) {
    TRUE
  } else {
    FALSE
  }
}

# Grab the color opening and closing tags for a given color
get_open_close <- function(c) {
  if (c == "white") {
    num_colors <- 1
  } else {
    num_colors <- 256
  }

  if (crayon:::is_r_color(c)) {
    o_c <- crayon:::style_from_r_color(c,
      bg = FALSE, num_colors = num_colors, grey = FALSE
    )
  } else {
    stop("Don't know how to handle non-R color.")
  }
  out <- tibble::as_tibble(o_c)
  return(o_c)
}


nix_newline <- function(s) {
  ncs <- nchar(s)
  if (substr(s, ncs, ncs) == "\n") {
    s <- substr(s, 1, ncs - 1)  # A \n counts as one character
  }
  s
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
