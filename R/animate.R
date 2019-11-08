#' Animate.css
#'
#' Animate.css is a popular collection of CSS animations. It contains "a
#' bunch of cool, fun, and cross-browser animations for you to use in your
#' projects. Great for emphasis, home pages, sliders, and general
#' just-add-water-awesomeness."
#'
#' @return An [htmltools::tagList] with the tile view dependencies, or an
#'   [htmltools::htmlDependency].
#' @section Usage: To add animate.css to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-animate, echo=FALSE}
#'   xaringanExtra::use_animate_css()
#'   ```
#'
#'   ---
#'   class: animated fadeInLeft
#'
#'   This slide fades in from the left!
#'   ````
#'
#' @references See [animate.css](http://daneden.github.io/animate.css) for a
#'   full list of animations.
#'
#' @param minified Should the minified or full CSS source be used?
#' @param xaringan When `TRUE`, the `.animated` selector is modified so that the
#'   animation is only applied when the slide is visible. Without this,
#'   presentations with many animated slides may have poor performance,
#'   especially on page load. Set to `FALSE` to use animate.css in other
#'   HTML-based documents.
#' @name animate_css
NULL

#' @describeIn animate_css Use animate.css in your xaringan slides.
#' @export
use_animate_css <- function(minified = FALSE, xaringan = TRUE) {
	htmltools::tagList(
		html_dependency_animate_css(minified, xaringan)
	)
}

#' @describeIn animate_css Returns an [htmltools::htmlDependency] with the tile
#'   view dependencies. Most users will want to use `use_tile_view()`.
#' @export
html_dependency_animate_css <- function(minified = FALSE, xaringan = TRUE) {
	if (xaringan) {
		css_file <- add_remark_visible_class(minified)
	}
	htmltools::htmlDependency(
		name = "animate.css",
		version = "3.7.2",
		src = dirname(css_file),
		stylesheet = basename(css_file),
		all_files = FALSE
	)
}

add_remark_visible_class <- function(minified) {
	css_file <- if (minified) "animate.min.css" else "animate.css"
	css <- readLines(
		xe_file("animate-css", css_file)
	)
	if (!minified) {
		css <- sub("^([.]animated [{])", ".remark-visible \\1", css)
	} else {
		css <- sub("[}][.]animated[{]", "}.remark-visible .animated{", css)
	}
	tmp <- file.path(tempdir(), css_file)
	writeLines(css, tmp)
	tmp
}
