% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xaringanExtra-package.R
\name{use_xaringan_extra}
\alias{use_xaringan_extra}
\title{Use xaringanExtra Extensions}
\usage{
use_xaringan_extra(
  include = c("tile_view", "animate_css", "tachyons", "panelset", "broadcast",
    "share_again", "scribble")
)
}
\arguments{
\item{include}{Character vector of extensions to include. One or more of
\code{"tile_view"}, \code{"editable"}, \code{"share_again"}, \code{"broadcast"}, \code{"slide_tone"},
\code{"animate_css"}, \code{"panelset"} \code{"tachyons"}, \code{"fit_screen"}, \code{"webcam"},
\code{"clipboard"}, \code{"search"}, \code{"scribble"}, \code{"freezeframe"}.}
}
\value{
An \code{htmltools::tagList()} with the \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}}s
for the requested extensions.
}
\description{
Load multiple \pkg{xaringanExtra} extensions at once. All extensions can be
loaded with this function.
}
\examples{
use_xaringan_extra(c("tile_view", "panelset"))
use_xaringan_extra(c("tile_view", "scribble", "share_again"))

}
