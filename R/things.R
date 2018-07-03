#' @title Things
#'
#' @description Named vector of animals and other characters e.g. Yoda, from the \code{cowsay} package
#'
#' @details \code{things} is a named character list of ASCII animals and characters.
#' @export
#' @examples
#' things[["rms"]] %>% cat()
#' things[["rms"]]
#' things[["turkey"]]
#' names(things)

things <-
  append(cowsay::animals,
    list("rms" = cowsay:::rms)
  )
