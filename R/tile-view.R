#' Tile View
#'
#' Tile view gives you a way to quickly jump between slides. Just press `T` at
#' any point in your slideshow and the tile view appears. Click on a slide to
#' jump to the slide, or press `T` to exit tile view.
#'
#' @return An [htmltools::tagList] with the tile view dependencies, or an
#'   [htmltools::htmlDependency].
#' @section Usage: To add tile view to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-tile-view, echo=FALSE}
#'   xaringanExtra::xaringan_tile_view()
#'   ```
#'   ````
#'
#' @name tile_view
NULL

#' @describeIn tile_view Adds tile view to your xaringan slides.
#' @export
xaringan_tile_view <- function() {
	htmltools::tagList(
		xaringan_tile_view_dependency()
	)
}

#' @describeIn tile_view Returns an [htmltools::htmlDependency] with the tile
#'   view dependencies. Most users will want to use `xaringan_tile_view()`.
#' @export
xaringan_tile_view_dependency <- function() {
	htmltools::htmlDependency(
		name = "tile-view",
		version = utils::packageVersion("xaringanExtra"),
		package = "xaringanExtra",
		src = "tile-view",
		script = "tile-view.js",
		stylesheet = "tile-view.css"
	)
}

