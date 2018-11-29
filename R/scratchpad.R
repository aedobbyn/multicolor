foo <- function(string, top_len = 1, base_len = 20, step = 2, display = TRUE) {
  # if maxlen == 0 then stop, no more lines left
  if (top_len == 0) return("\n")

  if (step == "auto") {
    total_nchar <- nchar(string)
    # step <-
  }

  # string shorter than maxlen, return full string
  if (stringr::str_length(string) <= top_len) return(string)

  # recursively print maxlen characters and start new line
  output <- rev(stringr::str_c(
    stringr::str_sub(string, total_nchar - base_len, total_nchar), "\n",
    foo(stringr::str_sub(string, base_len - step, stringr::str_length(string)),
                    top_len = top_len - step,
                    step = step)
  ))

  ifelse(display, return(output), return(invisible(output)))
}


mpark <-
  janeaustenr::mansfieldpark[50:60] %>% stringr::str_c(collapse = " ")

mpark %>% foo() %>% cat()



cut_chars <- function(vec, longest = 20, shortest = 2, step = 3) {

  out <- NULL
  vec_len <- nchar(vec)
  lineseq <- seq(shortest:longest)

  n_numbered <- 0

  if (n_numbered == 0) {
    start <- vec_len
    n_chars <- longest
    line_num <- 1
  }

  end <- start - step

  while(n_numbered <= vec_len && n_chars > 0) {
    this <- rep(line_num, n_chars)

    n_numbered <- n_numbered + length(this)
    n_chars <- n_chars - step
    start <- start - n_chars
    line_num <- line_num + 1

    out <- c(out, this)
  }

  out
}

mpark %>% cut_chars()



library(tidyverse)
mpark <- janeaustenr::mansfieldpark[50:70]


# Cut into equal buckets
bar <- function(string, top_len = 1, base_len = 20, step = 2, display = TRUE) {

  total_nchar <- nchar(string)

  nums <- cut_chars(string, longest = base_len, shortest = top_len, step = step)

  if (length(nums) < total_nchar) {
    stop("Insufficient number of characters once cut.")
  }

  chars <- string %>% stringr::str_split("") %>%
    purrr::as_vector()


  by_char <-
    tibble::tibble(char = chars) %>%
    dplyr::filter(char != "") %>%
    mutate(char_num = row_number(),
           line_num = nums)
           # line_num = cut_into_colors(char_num, n_buckets = n_lines))

  nested <-
    by_char %>%
    tidyr::nest(-line_num, .key = "line")

  by_line <-
    nested$line %>%
    map("char") %>%
    map_chr(str_c, collapse = "")

  by_line %>%
    str_c(collapse = "\n")

}

substr(mpark, 1, 110) %>% bar() %>% cat()

mpark %>% bar() %>% cat()


nested %>%
  rowwise() %>%
  mutate(x = stringr::str_c(line[[1]]$char, collapse = ""))

nested$line %>%
  map("char") %>%
  map_chr(str_c, collapse = "")


mpark %>% str_split("")























