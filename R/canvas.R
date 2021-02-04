#' @title Canvas
#'
#' @description Canvas provides a simple set of tools to allow you to mark up
#'   your `xaringan` slides. A toolbox will appear in the top-right corner once
#'   you begin navigating your slides. Click the edit icon to begin. Use the
#'   eraser to remove select markup, or the trash can to clear the entire
#'   canvas. When you are done, click the green "✓" to keep the markup, or the
#'   red "X" to hide the canvas.
#'
#' @details You may toggle the visibility of the canvas toolbox by pressing
#'   **D** at any time. Markup will persist when changing slides as long as the
#'   canvas isn't cleared. You may save a permanent copy of the slides with the
#'   markup by saving your presentation (e.g. using Chrome > File > Print).
#'
#' @param default_color Pen color (default is "#000000"). Users may choose any
#'   valid CSS hex color.
#' @param pen_size Pen size (default is 2).
#' @param eraser_size Eraser size (default is 10 times `pen_size`).
#'
#' @return An `htmltools::tagList()` with the fabric dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add a drawing canvas to your xaringan presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-canvas, echo=FALSE}
#'   xaringanExtra::use_canvas()
#'   ```
#'   ````
#'
#' @name canvas
NULL

#' @describeIn canvas Adds a markup canvas to your xaringan slides.
#' @export
use_canvas <- function(
	default_color = "#000000",
	pen_size = 2,
	eraser_size = pen_size * 10
) {
	stopifnot(is.numeric(pen_size))
	stopifnot(is.numeric(eraser_size))
	opts <- list(
		default_color = default_color,
		pen_size = pen_size,
		eraser_size = eraser_size
	)
	opts <- jsonlite::toJSON(opts)

	htmltools::tagList(
		html_dependency_fontawesome(),
		html_dependency_canvas(),
		htmltools::htmlDependency(
			name = uuid::UUIDgenerate(),
			version = "9.9.9",
			package = "xaringanExtra",
			src = "",
			head = sprintf(
				"<script>window.xaringanExtraCanvas(%s)</script>", opts
			),
			all_files = FALSE
		)
	)
}

#' @describeIn canvas Returns an [htmltools::htmlDependency()] with the
#'   canvas dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_canvas()` instead.
#' @export
html_dependency_canvas <- function() {
	htmltools::htmlDependency(
		name = "xaringanExtra-canvas",
		version = utils::packageVersion("xaringanExtra"),
		package = "xaringanExtra",
		src = "canvas",
		script = "canvas.js",
		stylesheet = "canvas.css"
	)
}

#' @describeIn canvas Returns an [htmltools::htmlDependency()] with the
#'   fontawesome dependencies for use in xaringan and R Markdown documents.
#'   Most users will want to use `use_canvas()` instead.
#' @export
html_dependency_fontawesome <- function() {
	htmltools::htmlDependency(
		name = "fontawesome",
		version = "5.15.2",
		package = "xaringanExtra",
		src = "",
		head = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css" integrity="sha512-HK5fgLBL+xu6dm/Ii3z4xhlSUyZgTT9tuc/hSrtw6uzJOvgRr2a9jyxxT1ely+B+xFAmJKVSTbpM/CuL7qxO8w==" crossorigin="anonymous" />',
		all_files = FALSE
	)
}
