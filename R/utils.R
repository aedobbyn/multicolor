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

use_color <- function() {
  can_color <- invisible(crayon::has_color())
  if (!can_color) {
    message("Colors cannot be applied in this environment. Please use another application, such as RStudio or a color-enabled terminal.")
  }
  can_color
}

inside_knitr <- function() {
  isTRUE(getOption("knitr.in.progress"))
}

# Internal crayon functions
crayon_style_from_r_color <- get("style_from_r_color", asNamespace("crayon"))

crayon_is_r_color <- get("is_r_color", asNamespace("crayon"))

# General close tag for ends of lines
close_tag <- "\033[39m"

# Grab the color opening and closing tags for a given color
get_open_close <- function(clr) {
  if (length(clr) == 1 && clr == "white") {
    num_colors <- 1
  } else {
    num_colors <- 256
  }

  if (crayon_is_r_color(clr)) {
    o_c <- crayon_style_from_r_color(clr,
      bg = FALSE, num_colors = num_colors, grey = FALSE
    )[c("open", "close")]
  } else {
    stop("Don't know how to handle non-R color.")
  }
  out <- tibble::as_tibble(o_c)
  return(o_c)
}

wrap_character <- function(x, clr) {
  o_c <- get_open_close(clr)

  stringr::str_c(o_c$open, x, o_c$close, collapse = "")
}

nix_newline <- function(s) {
  ncs <- nchar(s)
  if (substr(s, ncs, ncs) == "\n") {
    s <- substr(s, 1, ncs - 1) # A \n counts as one character
  }
  s
}

cut_into_colors <- function(x, n_buckets) {
  x %>%
    cut(n_buckets,
      include.lowest = TRUE,
      dig.lab = 0
    ) %>%
    as.numeric() %>%
    round()
}

add_clr_tags <- function(df) {
  df %>%
    dplyr::rowwise() %>%
    # Put open tags before the character and close tags after
    dplyr::mutate(
      tagged = dplyr::case_when(
        tag_type == "open" ~
        stringr::str_c(tag, line, collapse = ""),
        tag_type == "close" ~
        stringr::str_c(line, tag, collapse = ""),
        TRUE ~ line
      )
    )
}

add_newlines <- function(tbl) {
  tbl %>%
    dplyr::ungroup() %>%
    dplyr::group_by(line_id) %>%
    # Add a newline after every line
    dplyr::mutate(
      res = tagged %>% paste("\n", sep = "")
    )
}

add_css <- function(txt, font_fam = "Monaco") {
  glue::glue("<div style='font-family: {font_fam};'> {txt} </div>")
}

#' Remove the first instance of a newline from a string
#'
#' @param s (character) A string
#'
#' @return A string with the first instance of a newline removed.
#' @export
#'
#' @examples
#' nix_first_newline("onetwo\nthree\nfour")
#'
#' # Nothing to remove
#' nix_first_newline("fivesixseven")

nix_first_newline <- function(s) {
  newline_ix <- s %>%
    stringr::str_locate("\n") %>%
    purrr::as_vector() %>%
    dplyr::first()

  if (is.na(newline_ix)) {
    return(s)
  }

  s_first <- substr(s, 1, newline_ix)
  s_nixed <- s_first %>% nix_newline()

  out <- stringr::str_c(
    s_nixed,
    substr(s, newline_ix + 1, nchar(s))
  )
  return(out)
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



#' Out-of-the-box Color Palettes
#'
#' Take the string "rainbow" and replace it with c("red", "orange", "yellow", "green", "blue", "purple")
#'
#' @return A character vector of color values.
#' @export
#'
#' @examples
#'
#' multi_color(things$cat, colors = palettes$lacroix)

palettes <- list(
  lacroix = c("#EF7C12", "#F4B95A", "#009F3F", "#8FDA04", "#AF6125", "#F4E3C7", "#B25D91", "#EFC7E6", "#EF7C12", "#F4B95A"),
  magma = c("#51127CE6", "#6B1D81E6", "#852781E6", "#A1307EE6", "#BD3977E6", "#D8456CE6", "#ED5A5FE6", "#F9785DE6", "#FD9769E6", "#FEB77EE6"),
  grandbudapest = c("#F1BB7B", "#F59E74", "#F9816D", "#FD6467", "#C74B4C", "#913232", "#5B1A18", "#833721", "#AC542C", "#D67236"),
  ghibli = c("#4D4140", "#596F7E", "#168B98", "#ED5B67", "#E27766", "#DAAD50", "#EAC3A6")
)
