#' @title Fabric
#'
#' @description Fabric provides a set of tools to allow you to mark up
#'   your `xaringan` slides. Click the "edit" icon to begin. Use the
#'   eraser to remove select markup, or the trash can to clear the entire
#'   canvas. NOTE: You will not be able to navigate slides while in draw or
#'   erase mode.
#'
#' @details You may toggle the visibility of the canvas toolbox by pressing
#'   **D** at any time. Markup will persist when changing slides as long as the
#'   canvas isn't cleared. You may save a permanent copy of the slides with the
#'   markup by saving your presentation (e.g. using Chrome > File > Print).
#'
#' @param pen_color Pen color (default is "black"). Users may choose any
#'   valid CSS Hex, RGB, or HSL color.
#' @param pen_size Pen size (default is 3).
#' @param eraser_color Eraser color (default is "rgba(0, 0, 0, 0.1)").
#'   Users may choose any valid CSS Hex, RGB, or HSL color.
#' @param eraser_size Eraser size (default is 10 times `pen_size`).
#'
#' @return An `htmltools::tagList()` with the fabric dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add a fabric canvases to your `xaringan` presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-fabric, echo=FALSE}
#'   xaringanExtra::use_fabric()
#'   ```
#'   ````
#'
#' @name fabric
NULL

#' @describeIn fabric Adds a markup canvas to your xaringan slides.
#' @export
use_fabric <- function(
	pen_color = "rgb(0, 0, 0)",
	pen_size = 3,
	eraser_color = "rgba(0, 0, 0, 0.1)",
	eraser_size = pen_size * 10
) {
	stopifnot(is.numeric(pen_size))
	stopifnot(is.numeric(eraser_size))
	stopifnot(pen_color != eraser_color)
	opts <- list(
		pen_color = pen_color,
		pen_size = pen_size,
		eraser_color = eraser_color,
		eraser_size = eraser_size
	)
	opts <- jsonlite::toJSON(opts)

	htmltools::tagList(
		html_dependency_fabricjs(),
		html_dependency_fabric(),
		htmltools::htmlDependency(
			name = uuid::UUIDgenerate(),
			version = "9.9.9",
			package = "xaringanExtra",
			src = "",
			head = sprintf(
				"<script>window.xaringanExtraFabric(%s)</script>", opts
			),
			all_files = FALSE
		)
	)
}

#' @describeIn fabric Returns an [htmltools::htmlDependency()] with the
#'   fabric dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_fabric()` instead.
#' @export
html_dependency_fabricjs <- function() {
	htmltools::htmlDependency(
		name = "fabric",
		version = utils::packageVersion("xaringanExtra"),
		package = "xaringanExtra",
		src = "fabric",
		script = "fabric.min.js",
		all_files = FALSE
	)
}

#' @describeIn fabric Returns an [htmltools::htmlDependency()] with the
#'   fabric dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_fabric()` instead.
#' @export
html_dependency_fabric <- function() {
	htmltools::htmlDependency(
		name = "xaringanExtra-fabric",
		version = utils::packageVersion("xaringanExtra"),
		package = "xaringanExtra",
		src = "fabric",
		script = "xaringanExtra-fabric.js",
		stylesheet = "xaringanExtra-fabric.css",
		all_files = FALSE
	)
}
