#' Tile View
#'
#' Tile view gives you a way to quickly jump between slides. Just press **O** at
#' any point in your slideshow and the tile view appears. Click on a slide to
#' jump to the slide, or press **O** to exit tile view.
#'
#' @section Usage: To add tile view to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-tile-view, echo=FALSE}
#'   xaringanExtra::use_tile_view()
#'   ```
#'   ````
#' @examples
#' use_tile_view()
#'
#' @return An `htmltools::tagList()` with the tile view dependencies, or an
#'   [htmltools::htmlDependency()].
#' @name tile_view
NULL

#' @describeIn tile_view Adds tile view to your xaringan slides.
#' @export
use_tile_view <- function() {
  htmltools::tagList(
    html_dependency_tile_view()
  )
}

#' @describeIn tile_view Returns an [htmltools::htmlDependency()] with the tile
#'   view dependencies. Most users will want to use `use_tile_view()`.
#' @export
html_dependency_tile_view <- function() {
  htmltools::htmlDependency(
    name = "tile-view",
    version = "0.2.6",
    package = "xaringanExtra",
    src = "tile-view",
    script = "tile-view.js",
    stylesheet = "tile-view.css"
  )
}
