% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/animate.R
\name{animate_css}
\alias{animate_css}
\alias{use_animate_css}
\alias{html_dependency_animate_css}
\alias{use_animate_all}
\title{Animate.css}
\usage{
use_animate_css(minified = FALSE, xaringan = TRUE)

html_dependency_animate_css(minified = FALSE, xaringan = TRUE)

use_animate_all(
  style = c("slide_left", "slide_right", "slide_up", "slide_down", "roll", "fade")
)
}
\arguments{
\item{minified}{Should the minified or full CSS source be used?}

\item{xaringan}{When \code{TRUE}, the \code{.animated} selector is modified so that the
animation is only applied when the slide is visible. Without this,
presentations with many animated slides may have poor performance,
especially on page load. Set to \code{FALSE} to use animate.css in other
HTML-based documents.}

\item{style}{Animation style to be used for all slides.
\itemize{
\item \code{slide_left}: Slide in from the right and out to the left
\item \code{slide_right}: Slide in from the left and out to the right
\item \code{slide_up}: Slide in from the bottom and out to the top
\item \code{slide_down}: Slide in from the top and out to the bottom
\item \code{roll}: Roll in from the left and roll out to the right
\item \code{fade}: Fade in
}}
}
\value{
An \code{htmltools::tagList()} with the tile view dependencies, or an
\code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}}.
}
\description{
Animate.css is a popular collection of CSS animations. It contains "a
bunch of cool, fun, and cross-browser animations for you to use in your
projects. Great for emphasis, home pages, sliders, and general
just-add-water-awesomeness."
}
\section{Functions}{
\itemize{
\item \code{use_animate_css()}: Use animate.css in your xaringan slides.

\item \code{html_dependency_animate_css()}: Returns an \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}} with the tile
view dependencies. Most users will want to use \code{use_animate_css()}.

\item \code{use_animate_all()}: Use a default animation for all slides. Sets coupled
in an out animations for all slides that can be disabled on individual
slides by adding the class \code{.no-animation}.

}}
\section{Usage}{
 To add animate.css to your xaringan presentation, add the
following code chunk to your slides' R Markdown file.

\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{```\{r xaringan-animate, echo=FALSE\}
xaringanExtra::use_animate_css()
```

---
class: animated fadeInLeft slideOutRight

This slide fades in from the left and slides out to the right!
}\if{html}{\out{</div>}}

Note that when \code{xaringan = TRUE}, as is the default, out animations are
only applied to slides that are exiting so that you can specify both in
and out behavior of each slide.

Or use \code{use_animate_all()} to set default in and out animations for all
slides. Animations can be disabled for individual slides by adding the
class \code{.no-animation} to the slide.

\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{```\{r xaringan-animate, echo=FALSE\}
xaringanExtra::use_animate_all("slide_left")
```
}\if{html}{\out{</div>}}
}

\examples{
use_animate_css()
html_dependency_animate_css()

}
\references{
See \href{https://daneden.github.io/animate.css/}{animate.css} for a
full list of animations.
}
