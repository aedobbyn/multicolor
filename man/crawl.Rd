% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crawl.R
\name{crawl}
\alias{crawl}
\title{Multi-color crawling text}
\usage{
crawl(
  txt = "hello world!",
  colors = NULL,
  recycle_chars = FALSE,
  direction = "vertical",
  pause = 0.05,
  ...
)
}
\arguments{
\item{txt}{(character) Some text to color, stripped of line breaks}

\item{colors}{(character) A vector of colors to color each individual character, if
\code{recycle_chars} is TRUE, or the whole string if FALSE, defaulting to
the Viridis Plasma palette.
Must all be \href{https://github.com/r-lib/crayon#256-colors}{\code{crayon}}-supported
colors. Any colors in \code{colors()} or hex values (see \code{?rgb})
are fair game.}

\item{recycle_chars}{(logical) Should the vector of colors supplied apply to the entire string or
should it apply to each individual character (if \code{direction} is vertical)
or line (if \code{direction} is horizontal), and be recycled?}

\item{direction}{(character) How should the colors be spread? One of
"horizontal" or "vertical".}

\item{pause}{(numeric) Seconds to pause between characters in seconds.}

\item{...}{Further args passed to \code{\link{multi_color}}.}
}
\value{
A string, printed in \code{colors} with \code{pause} seconds between printing each character.
}
\description{
This function crawls over \code{txt} producing an animated gif-like
representation of the text unfolding from left to right or top to bottom,
depending on \code{direction}, colored according to \code{colors}.
}
\details{
This function requires as many colors as there are characters in your string and
prints them one at a time.
\code{colors} will be recycled in single-color equal-sized chunks if \code{recycle_char} is FALSE and
character-by-character if \code{recycle_char} is TRUE.

Colors cannot be applied in RGUI (R.app on some systems) or other environments that do not support
colored text. In these cases, the \code{txt} will simply be crawled over without applying colors.
}
\examples{
\dontrun{
crawl()

crawl("It was a dark and stormy night")

crawl("Taste the rainbow", colors = "rainbow")

crawl(things[["hypnotoad"]],
  colors = c("purple", "blue", "cyan"),
  direction = "horizontal", recycle_chars = TRUE, pause = 0.01
)

options("keep.source = FALSE")
crawl("\014A long time ago in a galaxy far, far away...
It is a period of civil war. Rebel spaceships, striking from a hidden base,
have won their first victory against the evil Galactic Empire.")
}
}
