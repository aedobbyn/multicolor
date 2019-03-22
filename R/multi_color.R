#' Multi-color text
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @param txt (character) Some text to color.
#' @param colors (character) A vector of colors, defaulting to
#' "rainbow", i.e. c("red", "orange", "yellow", "green", "blue", "purple").
#'
#' Must all be \href{https://github.com/r-lib/crayon#256-colors}{\code{crayon}}-supported
#' colors. Any colors in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#' @param type (character) "message" (the default), "warning", "string", or "rmd". If "rmd" is used, the type of the RMarkdown document should be \code{html_document} the chunk option \code{results = "asis"} should be used.
#' @param direction (character) How should the colors be spread? One of
#' "horizontal" or "vertical".
#' @param recycle_chars (logical) Should the vector of colors supplied apply to the entire string or
#' should it apply to each individual character (if \code{direction} is vertical)
#' or line (if \code{direction} is horizontal), and be recycled?
#' @param add_leading_newline Should a newline be added at the beginning of the text? Useful for \code{cowsay} animals when \code{type = "rmd"}.
#' @param ... Further args.
#'
#' @details This function evenly (ish) divides up your string into
#' these colors in the order they appear in \code{colors}.
#'
#' It cannot be used with RGUI (R.app on some systems).
#'
#' @return A string if \code{type} is "string", or colored
#' text if type is "message" or "warning"
#'
#' @examples \dontrun{
#' multi_color()
#'
#' multi_color("ahoy")
#'
# multi_color("taste the rainbow",
#             c("rainbow", "cyan", "cyan", "rainbow"))
#' multi_color("taste the rainbow",
#'             c("mediumpurple",
#'               "rainbow",
#'              "cyan3"))
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
#'
#' # Mystery Bulgarian animal
#' multi_color(things[[sample(length(things), 1)]],
#'             c("white", "darkgreen", "darkred"),
#'             direction = "horizontal")
#'
#' # Mystery Italian animal
#' multi_color(things[[sample(length(things), 1)]],
#'             c("darkgreen", "white", "darkred"),
#'             direction = "vertical")
#' }

multi_color <- function(txt = "hello world!",
                        colors = "rainbow",
                        type = "message",
                        direction = "vertical",
                        recycle_chars = FALSE,
                        add_leading_newline = TRUE,
                        ...) {
  if (!type %in% c("message", "warning", "string", "rmd", "crawl")) {
    stop("type must be one of message, or string")
  }

  if (use_color() == FALSE && type != "rmd") {
    message("Auto-setting type to string.")
    type <- "string"
  }

  if (!is.character(txt) || length(txt) < 1) stop("txt must be of class character and >= length 1.")

  if (!any(is.character(colors))) {
    stop("All multi colors must be of class character.")
  }

  direction <- match.arg(direction, c("vertical", "horizontal"))
  if (is.na(direction)) stop("direction must be 'horizontal' or 'vertical'.")

  colors <- insert_rainbow(colors)
  n_colors_base <- length(colors)

  if (n_colors_base <= 1) stop("colors must be a vector of length > 1")

  color_validity <-
    purrr::map_lgl(colors, crayon_is_r_color) # Checks whether a color
  # is color string or a valid hex string (with crayon:::hash_color_regex)

  if (!all(color_validity)) {
    bad_colors <-
      colors[which(color_validity == FALSE)] %>%
      stringr::str_c(collapse = " ")

    stop(glue::glue("All colors must be R color strings or hex values.
        The input(s) {bad_colors} cannot be used."))
  }

  # Get tibble with one row per line and their n characters
  by_line <-
    tibble::tibble(
      full = txt
    ) %>%
    dplyr::mutate(
      line = txt %>% stringr::str_split("\\n")
    ) %>%
    tidyr::unnest(line) %>%
    dplyr::mutate(
      n_char = nchar(line)
    )

  # If the first line is an empty string, nix it
  if (by_line$line[1] == "") {
    by_line <-
      by_line[2:nrow(by_line), ]
  }

  by_line <- by_line %>%
    dplyr::mutate(
      line_id = dplyr::row_number() # Add UUID
    ) %>%
    dplyr::select(-full)

  # Find the line with the max number of characters
  max_char <-
    by_line %>%
    dplyr::filter(n_char == max(n_char)) %>%
    dplyr::pull(line) %>%
    dplyr::first()

  if (recycle_chars) {
    if (direction == "horizontal") {
      colors <- rep(colors, length.out = nrow(by_line))
    } else if (direction == "vertical") {
      colors <- rep(colors, length.out = nchar(max_char))
    }
  }

  n_colors <- length(colors)

  # Number each color in the order they're given
  color_dict <-
    tibble::tibble(
      color = colors,
      color_num = 1:n_colors
    )

  color_df <- color_dict %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      tag = get_open_close(color) %>% list()
    ) %>%
    tidyr::unnest(tag) %>%
    dplyr::group_by(color_num) %>%
    dplyr::mutate(
      tag_num = dplyr::row_number()
    ) %>%
    dplyr::mutate(
      tag_type = dplyr::case_when(
        tag_num == 1 ~ "open",
        tag_num == 2 ~ "close",
        TRUE ~ NA_character_
      )
    ) %>%
    dplyr::select(-tag_num)

  if (direction == "horizontal") {
    out <-
      by_line %>%
      dplyr::mutate(
        color_num = line_id %>%
          cut_into_colors(n_colors)
      ) %>%
      dplyr::left_join(color_df, by = "color_num") %>%
      add_clr_tags() %>%
      add_newlines() %>%
      dplyr::distinct(line_id, .keep_all = TRUE)

    if (type == "crawl") {
      out <- out %>%
        dplyr::pull("res")
      return(out)
    }
  } else if (direction == "vertical") {

    # Cut the longest line into roughly equal buckets
    max_assigned <-
      seq(nchar(max_char)) %>%
      cut_into_colors(n_colors)

    # Assign a color for every possible character index based on the longest line
    color_char_dict <-
      tibble::tibble(color_num = max_assigned) %>%
      dplyr::left_join(color_dict, by = "color_num") %>%
      dplyr::mutate(
        char = max_char %>%
          stringr::str_split("") %>%
          .[[1]],
        char_num = dplyr::row_number()
      ) %>%
      dplyr::select(-char)

    tbl_1 <-
      by_line %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        # Split into individual characters
        split_chars = line %>% stringr::str_split("")
      ) %>%
      tidyr::unnest(split_chars) %>%
      dplyr::group_by(line_id) %>%
      dplyr::mutate(
        char_num = dplyr::row_number()
      )

    tbl_2 <-
      tbl_1 %>%
      # Assign colors by char position
      dplyr::left_join(color_char_dict, by = "char_num") %>%
      dplyr::group_by(color_num, line_id) %>%
      # Add a new column for putting the open and close tags in the right spot
      # based on the min and max character for each color, for each line
      dplyr::mutate(
        char_color_num = dplyr::row_number(),
        tag_type = dplyr::case_when(
          char_color_num == 1 ~ "open",
          char_color_num == max(char_color_num) ~ "close",
          TRUE ~ NA_character_
        )
      )

    out <-
      tbl_2 %>%
      # Add in the color tags
      dplyr::left_join(color_df,
        by = c("color", "color_num", "tag_type")
      ) %>%
      dplyr::ungroup() %>%
      dplyr::rowwise() %>%
      # Put open tags before the character and close tags after
      dplyr::mutate(
        tagged = dplyr::case_when(
          tag_type == "open" ~
          stringr::str_c(tag, split_chars, collapse = ""),
          tag_type == "close" ~
          stringr::str_c(split_chars, tag, collapse = ""),
          TRUE ~ split_chars
        )
      ) %>%
      dplyr::ungroup() %>%
      dplyr::group_by(line_id) %>%
      # Add a close tag and newline after every line
      # (Newline esp important when following text is not colored)
      dplyr::mutate(
        res = dplyr::case_when(
          char_num == max(char_num) ~ tagged %>% paste(close_tag, "\n", sep = ""),
          TRUE ~ tagged
        )
      )

    if (type == "crawl") {
      out <- out %>%
        dplyr::pull("res")
      return(out)
    }
  }

  out <- out$res %>%
    stringr::str_c(collapse = "")

  if (max(by_line$line_id) == 1) {
    out <- out %>% nix_first_newline()
  }

  # Set warning length so it's not truncated
  if (type == "warning") { # nocov start
    if (nchar(out) < 100) {
      wl <- 100
    } else if (nchar(out) > 8170) {
      wl <- 8170
    } else {
      wl <- nchar(out) + 1
    }
    warn_op <- options(warning.length = wl)
    on.exit(options(warn_op))
  } # nocov end

  if (add_leading_newline) {
    out <- stringr::str_c("\n", out, collapse = "")
  }

  if (type == "rmd") {
    out <- out %>%
      stringr:::str_replace_all('  '," &nbsp; ") %>%
      stringr::str_replace_all('\n',"<br>")

    rmd <- noquote(out) %>%

      fansi::sgr_to_html()
  }

  switch(type,
    message = message(out), # nocov
    warning = warning(out), # nocov
    rmd = rmd,
    string = out
  )
}



#' Multi-colour text
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @param txt (character) Some text to colour.
#' @param colors (character) A vector of colours, defaulting to
#' "rainbow", i.e. c("red", "orange", "yellow", "green", "blue", "purple").
#'
#' Must all be \href{https://github.com/r-lib/crayon#256-colours}{\code{crayon}}-supported
#' colours. Any colours in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#' @param type (character) Message (default), warning, or string.
#' @param direction (character) How should the colours be spread? One of
#' "horizontal" or "vertical".
#' @param recycle_chars (logical) Should the vector of colours supplied apply to the entire string or
#' should it apply to each individual character (if \code{direction} is vertical)
#' or line (if \code{direction} is horizontal), and be recycled?
#' @param ... Further args.
#'
#' @details This function evenly (ish) divides up your string into
#' these colours in the order they appear in \code{colours}.
#'
#' It cannot be used with RGUI (R.app on some systems).
#'
#' @return A string if \code{type} is "string", or coloured
#' text if type is "message" or "warning"
#'
#' @examples \dontrun{
#' multi_colour()
#'
#' multi_colour("ahoy")
#'
# multi_colour("taste the rainbow",
#             c("rainbow", "cyan", "cyan", "rainbow"))
#' multi_colour("taste the rainbow",
#'             c("mediumpurple",
#'               "rainbow",
#'              "cyan3"))
#'
#' multi_colour(colours = c(rgb(0.1, 0.2, 0.5),
#'                        "yellow",
#'                        rgb(0.2, 0.9, 0.1)))
#'
#' multi_colour(
#'   cowsay::animals[["buffalo"]],
#'   c("mediumorchid4", "dodgerblue1", "lemonchiffon1"))
#'
#' multi_colour(cowsay:::rms, sample(colours(), 10))
#'
#' # Mystery Bulgarian animal
#' multi_colour(things[[sample(length(things), 1)]],
#'             c("white", "darkgreen", "darkred"),
#'             direction = "horizontal")
#'
#' # Mystery Italian animal
#' multi_colour(things[[sample(length(things), 1)]],
#'             c("darkgreen", "white", "darkred"),
#'             direction = "vertical")
#' }

multi_colour <- multi_color
