#' @title Things
#'
#' @description Named vector of animals and other characters e.g. Yoda, from the \code{cowsay} package
#'
#' @details \code{things} is a named character list of ASCII animals and characters.
#' @export
#' @examples
#' things[["turkey"]]
#' things[["rms"]] %>% cat()
#' names(things)
#' multi_color(things[["stretchycat"]])  # To say something, use the cowsay package

things <-
  append(
    cowsay::animals,
    list("rms" = cowsay:::rms)
  )
