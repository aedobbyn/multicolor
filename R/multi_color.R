#' Multi-color text
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @param txt (character) Some text to color.
#' @param colors (character) A vector of colors, defaulting to
#' c("red", "orange", "yellow", "green", "blue", "purple")
#' @param type (character) Message (default), warning, or string
#' @param ... Further args.
#'
#' @details This function evenly (ish) divides up your string into
#' these colors in the order they appear in \code{colors}.
#'
#' Any colors in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#'
#' @return A string if \code{type} is "string", or colored
#' text if type is "message" or "warning"
#'
#' @examples
#' multi_color("ahoy")
#'
#' multi_color( # what = "masey",
#'   cowsay::animals[["buffalo"]],
#'   c("green", "white", "orange"))
#'
#' multi_color(cowsay:::rms, sample(colors(), 10))

multi_color <- function(txt = NULL,
                        colors = c("red", "orange", "yellow",
                                   "green", "blue", "purple"),
                        type = "message",
                        ...) {

  if (!is.character(txt)) stop("txt must be of class character.")

  if (!any(is.character(colors))) {
    stop("All multi colors must be of class character.")
  }

  if (!type %in% c("message", "warning", "string")) {
    stop("type must be one of message or string")
  }

  get_open_close <- function(c) {    # Deal with grays
    if (crayon:::is_r_color(c)) {
      o_c <- crayon:::style_from_r_color(c,
                                         bg = FALSE, num_colors = 1, grey = FALSE)
    } else if (!crayon:::is_r_color(c)) {
      o_c <-crayon:::style_from_rgb(c,
                              bg = FALSE, num_colors = 1, grey = FALSE)
    }
    out <- list(o_c)
    names(out) <- c
    return(out)
  }

  color_list <-
    purrr::map(colors, get_open_close)

  color_df <-
    color_list %>%
    purrr::flatten() %>%
    tibble::as_tibble() %>%
    tidyr::gather("color", "tag") %>%
    tidyr::unnest(tag) %>%
    dplyr::group_by(color) %>%
    dplyr::mutate(
      tag_num = dplyr::row_number()
    ) %>%
    dplyr::mutate(
      tag_type = dplyr::case_when(
        tag_num == 1 ~ "open",
        tag_num == 2 ~ "close",
        TRUE ~ NA_character_
      )
    )

  color_dict <-
    tibble::tibble(
      color = colors,
      num = 1:length(colors)
    )

  # Get tibble of lines
  whose_line <-
    tibble::tibble(
      full = txt
    ) %>%
    dplyr::mutate(
      lines = txt %>% stringr::str_split("\\n")
    ) %>%
    tidyr::unnest(lines) %>%
    dplyr::mutate(
      n_char = nchar(lines)
    )

  # Find the line with the max number of characters
  max_char <-
    whose_line %>%
    dplyr::filter(n_char == max(n_char)) %>%
    dplyr::pull(lines) %>%
    dplyr::first()

  # Cut into roughly equal buckets
  max_assigned <-
    cut(seq(nchar(max_char)), length(colors),
        include.lowest = TRUE,
        dig.lab = 0) %>%
    as.numeric() %>%
    round()

  # Assign a color for every possible character index based on the longest line
  dict <-
    tibble::tibble(num = max_assigned) %>%
    dplyr::left_join(color_dict, by = "num") %>%
    dplyr::mutate(
      char = max_char %>%
        stringr::str_split("") %>% .[[1]],
      rn = dplyr::row_number()
    )

  tbl <-
    whose_line %>%
    dplyr::select(lines) %>%
    dplyr::mutate(line_id = dplyr::row_number()) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      num = seq(nchar(lines)) %>% list(),
      split_chars = lines %>% stringr::str_split("")
    ) %>%
    tidyr::unnest(split_chars) %>%
    dplyr::group_by(line_id) %>%
    dplyr::mutate(
      rn = dplyr::row_number()
    ) %>%
    # Assign colors by char position
    dplyr::left_join(dict, by = "rn") %>%
    dplyr::select(-lines) %>%
    dplyr::group_by(color, line_id) %>%
    # Add a new column for putting the open and close tags in the right spot
    dplyr::mutate(
      color_num = dplyr::row_number(),
      tag_type = dplyr::case_when(
        color_num == 1 ~ "open",
        color_num == max(color_num) ~ "close",
        TRUE ~ NA_character_
      )
    ) %>%
    dplyr::left_join(color_df,
                     by = c("color", "tag_type")) %>%
    dplyr::ungroup() %>%
    dplyr::rowwise() %>%
    # Put open tags before the character and close tags after
    dplyr::mutate(
      tagged_chr = dplyr::case_when(
        tag_type == "open" ~
          stringr::str_c(tag, split_chars, collapse = ""),
        tag_type == "close" ~
          stringr::str_c(split_chars, tag, collapse = ""),
        TRUE ~ split_chars
      )
    ) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(line_id) %>%
      dplyr::mutate(
        res = dplyr::case_when(
          rn == max(rn) ~ tagged_chr %>% paste("\n", sep = ""),
          TRUE ~ tagged_chr
        )
      )

  out <- tbl$res %>%
    stringr::str_c(collapse = "")

  switch(type,
         message = message(out),
         warning = warning(out),
         string = out)
}

