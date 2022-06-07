#' Animate.css
#'
#' Animate.css is a popular collection of CSS animations. It contains "a
#' bunch of cool, fun, and cross-browser animations for you to use in your
#' projects. Great for emphasis, home pages, sliders, and general
#' just-add-water-awesomeness."
#'
#' @section Usage: To add animate.css to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-animate, echo=FALSE}
#'   xaringanExtra::use_animate_css()
#'   ```
#'
#'   ---
#'   class: animated fadeInLeft slideOutRight
#'
#'   This slide fades in from the left and slides out to the right!
#'   ````
#'
#'   Note that when `xaringan = TRUE`, as is the default, out animations are
#'   only applied to slides that are exiting so that you can specify both in
#'   and out behavior of each slide.
#'
#'   Or use `use_animate_all()` to set default in and out animations for all
#'   slides. Animations can be disabled for individual slides by adding the
#'   class `.no-animation` to the slide.
#'
#'   ````markdown
#'   ```{r xaringan-animate, echo=FALSE}
#'   xaringanExtra::use_animate_all("slide_left")
#'   ```
#'   ````
#'
#' @examples
#' use_animate_css()
#' html_dependency_animate_css()
#'
#' @references See [animate.css](https://daneden.github.io/animate.css/) for a
#'   full list of animations.
#'
#' @param minified Should the minified or full CSS source be used?
#' @param xaringan When `TRUE`, the `.animated` selector is modified so that the
#'   animation is only applied when the slide is visible. Without this,
#'   presentations with many animated slides may have poor performance,
#'   especially on page load. Set to `FALSE` to use animate.css in other
#'   HTML-based documents.
#'
#' @return An `htmltools::tagList()` with the tile view dependencies, or an
#'   [htmltools::htmlDependency()].
#'
#' @name animate_css
NULL

#' @describeIn animate_css Use animate.css in your xaringan slides.
#' @export
use_animate_css <- function(minified = FALSE, xaringan = TRUE) {
  htmltools::tagList(
    html_dependency_animate_css(minified, xaringan)
  )
}

#' @describeIn animate_css Returns an [htmltools::htmlDependency()] with the tile
#'   view dependencies. Most users will want to use `use_animate_css()`.
#' @export
html_dependency_animate_css <- function(minified = FALSE, xaringan = TRUE) {
  css_file <- "animate"
  if (xaringan) css_file <- paste0(css_file, ".xaringan")
  if (minified) css_file <- paste0(css_file, ".min")
  css_file <- paste0(css_file, ".css")

  htmltools::htmlDependency(
    name = "animate.css",
    version = "3.7.2",
    package = "xaringanExtra",
    src = "animate-css",
    stylesheet = css_file,
    all_files = FALSE
  )
}

#' @describeIn animate_css Use a default animation for all slides. Sets coupled
#'   in an out animations for all slides that can be disabled on individual
#'   slides by adding the class `.no-animation`.
#' @param style Animation style to be used for all slides.
#'
#'   - `slide_left`: Slide in from the right and out to the left
#'   - `slide_right`: Slide in from the left and out to the right
#'   - `slide_up`: Slide in from the bottom and out to the top
#'   - `slide_down`: Slide in from the top and out to the bottom
#'   - `roll`: Roll in from the left and roll out to the right
#'   - `fade`: Fade in
#' @export
use_animate_all <- function(style = c(
    "slide_left",
    "slide_right",
    "slide_up",
    "slide_down",
    "roll",
    "fade"
  )) {
  css_file <- paste0("animate.", match.arg(style), ".css")
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "animate.css-xaringan",
      version = "3.7.2",
      package = "xaringanExtra",
      src = "animate-css",
      stylesheet = css_file,
      all_files = FALSE
    )
  )
}
