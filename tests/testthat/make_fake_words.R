
punctuation <- c(".", ",", ";", "-", "--", "!", "?")

make_fake_word <- function(letters_range = 2:20, pool = letters) {
  n_letters <- sample(letters_range, 1)

  sample(pool, n_letters) %>%
    stringr::str_c(collapse = "")
}

make_fake_words <- function(n_words = 10, letters_range = 2:20,
                            n_punctuations = 1) {

  pool <- letters

  out <-
    purrr::map_chr(1:n_words, make_fake_word, pool = pool) %>%
    stringr::str_c(collapse = " ")

  if (n_punctuations > 0) {
    puncs <- sample(punctuation, n_punctuations)
    out <- out %>%
      c(puncs) %>%
      sample(size = length(.)) %>%
      stringr::str_c(collapse = "")
  }

  out
}


make_fake_words()
