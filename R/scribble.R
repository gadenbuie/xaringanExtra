#' @title Scribble
#'
#' @description `Scribble` provides a set of tools to allow you to mark up
#'   your `xaringan` slides. Click the "edit" icon to begin drawing. Use the
#'   eraser to remove select markup, or the trash to clear the entire
#'   canvas. NOTE: You will not be able to navigate slides while in draw or
#'   erase mode.
#'
#' @details You may toggle the visibility of the `Scribble` toolbox by pressing
#'   **S** at any time. Markup will persist when changing slides as long as the
#'   canvas isn't cleared. You may save a permanent copy of the slides with the
#'   markup by saving your presentation (e.g. using Chrome > File > Print).
#'
#' @section Usage: To add `Scribble` to your `xaringan` presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-scribble, echo=FALSE}
#'   xaringanExtra::use_scribble()
#'   ```
#'   ````
#' @param pen_color Initial pen color (default is `"#FF0000` (red)). May be any
#'   valid CSS Hex, RGB, or HSL color.
#' @param pen_size Pen size (default is 3).
#' @param eraser_size Eraser size (default is `pen_size * 10`).
#'
#' @return An `htmltools::tagList()` with the scribble dependencies, or an
#'   [htmltools::htmlDependency()].
#'
#' @name scribble
NULL

#' @describeIn scribble Adds `Scribble` to your xaringan slides.
#' @export
use_scribble <- function(
	pen_color = "#FF0000",
	pen_size = 3,
	eraser_size = pen_size * 10
) {
	htmltools::tagList(
		html_dependency_fabricjs(),
		html_dependency_scribble(
			pen_color,
			pen_size,
			eraser_size
		)
	)
}

#' @describeIn scribble Returns an [htmltools::htmlDependency()] with the
#'   `fabric.js` dependencies for use in xaringan and R Markdown documents.
#'   Most users will want to use `use_scribble()` instead.
#'
#' @param minimized Use the minimized `fabric.js` dependency?
#' @export
html_dependency_fabricjs <- function(minimized = TRUE) {
	htmltools::htmlDependency(
		name = "fabric",
		version = "4.3.1",
		package = "xaringanExtra",
		src = c(
			file = "jslib/fabric",
			href = "https://unpkg.com/fabric@4.3.1/dist"
		),
		script = if (minimized) "fabric.min.js" else "fabric.js",
		all_files = FALSE
	)
}

#' @describeIn scribble Returns an [htmltools::htmlDependency()] with the
#'   `scribble` dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_scribble()` instead.
#'
#' @export
html_dependency_scribble <- function(
	pen_color,
	pen_size,
	eraser_size
) {
	htmltools::htmlDependency(
		name = "xaringanExtra-scribble",
		version = "0.0.1",
		package = "xaringanExtra",
		src = "scribble",
		script = "scribble.js",
		stylesheet = "scribble.css",
		head = init_Scribble(pen_color, pen_size, eraser_size),
		all_files = FALSE
	)
}

init_Scribble <- function(
	pen_color,
	pen_size,
	eraser_size
) {
	# Current we expect one color, we may lift this restriction in the future
	stopifnot("single pen color" = length(pen_color) == 1)
	stopifnot(is.numeric(pen_size))
	stopifnot(is.numeric(eraser_size))
	opts <- list(
		pen_color = pen_color,
		pen_size = jsonlite::unbox(pen_size),
		eraser_size = jsonlite::unbox(eraser_size)
	)
	opts <- jsonlite::toJSON(opts)

	sprintf(
		paste0(
			"<script>document.addEventListener('DOMContentLoaded', function() {",
			" window.xeScribble = new Scribble(%s) })</script>"
		),
		opts
	)
}
