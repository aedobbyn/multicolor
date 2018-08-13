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


# adapted from https://stackoverflow.com/questions/12389158/check-if-r-is-running-in-rstudio
is_r_gui <- Sys.getenv("R_GUI_APP_VERSION") != ""
# is_r_gui <- .Platform$GUI == "AQUA"

use_color <- function() {
  can_color <- TRUE
  if (is_r_gui) {
    can_color <- FALSE
    message("Envoronment is RGUI, so colors cannot be applied. Please use another application, such as RStudio or a terminal.")
  }
  invisible(can_color)
}

on_windows <- function() {
  os <- tolower(Sys.info()[["sysname"]])

  if ("windows" %in% os) {
    TRUE
  } else {
    FALSE
  }
}

# Internal crayon functions
crayon_style_from_r_color <- get("style_from_r_color", asNamespace("crayon"))

crayon_is_r_color <- get("is_r_color", asNamespace("crayon"))

# Grab the color opening and closing tags for a given color
get_open_close <- function(c) {
  if (c == "white") {
    num_colors <- 1
  } else {
    num_colors <- 256
  }

  if (crayon_is_r_color(c)) {
    o_c <- crayon_style_from_r_color(c,
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

  out <- stringr::str_c(s_nixed,
            substr(s, newline_ix + 1, nchar(s)))
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
