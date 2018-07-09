#' Multi-color text
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @param txt (character) Some text to color.
#' @param colors (character) A vector of colors, defaulting to
#' c("red", "orange", "yellow", "green", "blue", "purple").
#'
#' Must all be \href{https://github.com/r-lib/crayon#256-colors}{\code{crayon}}-suported
#' colors. Any colors in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#' @param type (character) Message (default), warning, or string
#' @param ... Further args.
#'
#' @details This function evenly (ish) divides up your string into
#' these colors in the order they appear in \code{colors}.
#'
#'
#' @return A string if \code{type} is "string", or colored
#' text if type is "message" or "warning"
#'
#' @examples
#' multi_color()
#'
#' multi_color("ahoy")
#'
#' multi_color(colors = c(rgb(0.1, 0.2, 0.5),
#'                        "yellow",
#'                        rgb(0.2, 0.9, 0.1)))
#'
#' multi_color(
#'   cowsay::animals[["buffalo"]],
#'   c("mediumorchid4", "dodgerblue1", "lemonchiffon1"))
#'
#' multi_color(cowsay:::rms, sample(colors(), 10))

multi_color <- function(txt = "hello world!",
                        colors = c(
                          "red", "orange", "yellow",
                          "green", "blue", "purple"
                        ),
                        type = "message",
                        ...) {
  if (!is.character(txt)) stop("txt must be of class character.")

  if (!any(is.character(colors))) {
    stop("All multi colors must be of class character.")
  }

  if (!type %in% c("message", "warning", "string")) {
    stop("type must be one of message or string")
  }

  if (length(colors) <= 1) stop("colors must be a vector of length > 1")

  color_validity <-
    purrr::map_lgl(colors, crayon:::is_r_color) # Checks whether a color
  # is color string or a valid hex string (with crayon:::hash_color_regex)

  if (!all(color_validity)) {
    bad_colors <-
      colors[which(color_validity == FALSE)]

    stop(glue::glue("All colors must be R color strings or hex values. \\
        {bad_colors} cannot be used."))
  }

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
      dig.lab = 0
    ) %>%
    as.numeric() %>%
    round()

  # Assign a color for every possible character index based on the longest line
  dict <-
    tibble::tibble(num = max_assigned) %>%
    dplyr::left_join(color_dict, by = "num") %>%
    dplyr::mutate(
      char = max_char %>%
        stringr::str_split("") %>%
        .[[1]],
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
      by = c("color", "tag_type")
    ) %>%
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

  if (type == "warning") {
    if (nchar(out) < 100) {
      wl <- 100
    } else if (nchar(out) > 8170) {
      wl <- 8170
    } else {
      wl <- nchar(out) + 1
    }
    warn_op <- options(warning.length = wl)
    on.exit(options(warn_op))
  }

  switch(type,
    message = message(out),
    warning = warning(out),
    string = out
  )
}
