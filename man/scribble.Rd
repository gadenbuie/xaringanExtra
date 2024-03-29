% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scribble.R
\name{scribble}
\alias{scribble}
\alias{use_scribble}
\alias{html_dependency_fabricjs}
\alias{html_dependency_scribble}
\title{Scribble}
\usage{
use_scribble(
  pen_color = "#FF0000",
  pen_size = 3,
  eraser_size = pen_size * 10,
  palette = NULL
)

html_dependency_fabricjs(minimized = TRUE)

html_dependency_scribble(pen_color, pen_size, eraser_size, palette = NULL)
}
\arguments{
\item{pen_color}{Initial pen color (default is \verb{"#FF0000} (red)). Must be a
hexadecimal color, e.g. \verb{#000} or \verb{#4232ea}.}

\item{pen_size}{Pen size (default is 3).}

\item{eraser_size}{Eraser size (default is \code{pen_size * 10}).}

\item{palette}{A selection of up to 10 colors that become available when
drawing is active via the keys \code{0} through \code{9}. Press the number keys of
0-9 to quickly active each of the palette colors.}

\item{minimized}{Use the minimized \code{fabric.js} dependency?}
}
\value{
An \code{htmltools::tagList()} with the scribble dependencies, or an
\code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}}.
}
\description{
Scribble lets you draw on your \pkg{xaringan} slides. Click the pencil icon
to begin drawing. Use the eraser to remove lines from your drawing, or the
trash to clear the entire canvas. Note that in order to minimize confusion,
you will not be able to navigate slides while in draw or erase mode.

You may toggle the visibility of the scribble toolbox by pressing \code{S} at
any time. Your drawings will persist when changing slides. You may save a
permanent copy of the slides with the markup by printing your presentation
(e.g. using Chrome > File > Print).
}
\section{Functions}{
\itemize{
\item \code{use_scribble()}: Adds scribble to your xaringan slides.

\item \code{html_dependency_fabricjs()}: Returns an \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}} with the
\code{fabric.js} dependencies for use in xaringan and R Markdown documents.
Most users will want to use \code{use_scribble()} instead.

\item \code{html_dependency_scribble()}: Returns an \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}} with the
scribble dependencies for use in xaringan and R Markdown documents. Most
users will want to use \code{use_scribble()} instead.

}}
\section{Usage}{
 To add scribble to your \code{xaringan} presentation,
add the following code chunk to your slides' R Markdown file.

\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{```\{r xaringan-scribble, echo=FALSE\}
xaringanExtra::use_scribble()
```
}\if{html}{\out{</div>}}
}

\examples{
use_scribble()

}
