#' Multi-color text
#'
#' @importFrom magrittr %>%
#' @export
#'
#' @param txt (character) Some text to color.
#' @param colors (character) A vector of colors, defaulting to
#' c("red", "orange", "yellow", "green", "blue", "purple")
#' @param type (character) Message (default) or string
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

  if (!type %in% c("message", "string")) {
    stop("type must be one of message or string")
  }

  color_dict <-
    tibble::tibble(
      color = colors,
      num = 1:length(colors)
    )

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
    dplyr::rowwise() %>%
    dplyr::mutate(
      # Save the function in a list because we can't store a function in a col
      color_fun = crayon::make_style(color) %>% list(),
      styled = color_fun(split_chars)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(line_id) %>%
    # Re-add a newline at the end of the last character of every line
    dplyr::mutate(
      res = ifelse(rn == max(rn),
                   styled %>% paste("\n", sep = ""),
                   styled)
    )

  out <- tbl$res %>%
    stringr::str_c(collapse = "")

  switch(type,
         message = message(out),
         warning = warning(out),
         string = out)
}

