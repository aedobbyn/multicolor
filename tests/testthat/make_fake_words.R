
punctuation <- c(".", ",", ";", "-", "--", "!", "?")

make_fake_word <- function(letters_range = 2:20, pool = letters, ...) {
  n_letters <- sample(letters_range, 1)

  sample(pool, size = n_letters, replace = TRUE) %>%
    stringr::str_c(collapse = "")
}

make_fake_words <- function(n_words = 10, letters_range = 2:20,
                            n_punctuations = 1, pool = letters, ...) {

  wrds <- NULL

  for (i in 1:n_words) {
    this <- make_fake_word(size = letters_range, pool = pool)
    wrds <- c(wrds, this)
  }

  # wrds <-
    # purrr::map_chr(.x = 1:n_words, .f = make_fake_word, size = letters_range, pool = pool)

  if (n_punctuations > 0) {
    puncs <- sample(punctuation, n_punctuations)
    wrds <- wrds %>%
      c(puncs)

    out <- wrds %>%
      sample(size = length(wrds)) %>%
      stringr::str_c(collapse = " ")
  }

  out
}

(some_words <-
  make_fake_words(n_words = 100))


some_words %>%
  triangle_string() %>%
  cat()


