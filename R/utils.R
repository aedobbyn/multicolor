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


insert_rainbow <- function(clr) {
  if (any(clr == "rainbow")) {
    rb_idx <- which(clr == "rainbow")
    clr[rb_idx] <- list(c("red", "orange", "yellow", "green", "blue", "purple"))
    clr <- unlist(clr)
  }
  return(clr)
}
