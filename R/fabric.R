#' Fabric Canvas
#'
#' Fabric gives you a way to add a canvas on top of your slide to draw on.
#'   Just press **D** at any point in your slideshow and a transparent
#'   drawing canvas will be added to your slide. Drawing tools will appear in
#'   the top right corner of the slide to control stroke color and thickness.
#'
#' @details Drawings will persist when changing slides as long as the canvas
#'   isn't removed. The canvas can be removed at any time by pressing **D**.
#'   You may also keep a permanent copy of the slides with the drawings by
#'   saving your presentation (e.g. using Chrome > File > Print).
#'
#' @return An `htmltools::tagList()` with the fabric dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add a drawing canvas to your xaringan presentation,
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

#' @describeIn fabric Adds a drawing canvas to your xaringan slides.
#' @export
use_fabric <- function() {
	htmltools::tagList(
		html_dependency_fabric()
	)
}

#' @describeIn fabric Returns an [htmltools::htmlDependency()] with the fabric
#'   dependencies. Most users will want to use `use_fabric()`.
#' @export
html_dependency_fabric <- function() {
	htmltools::htmlDependency(
		name = "fabric",
		version = utils::packageVersion("xaringanExtra"),
		package = "xaringanExtra",
		src = "fabric",
		script = c("fabric.min.js", "fabric.js"),
		stylesheet = "fabric.css"
	)
}

