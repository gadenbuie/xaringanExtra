#' Scribble
#'
#' @description
#' Scribble lets you draw on your \pkg{xaringan} slides. Click the pencil icon
#' to begin drawing. Use the eraser to remove lines from your drawing, or the
#' trash to clear the entire canvas. Note that in order to minimize confusion,
#' you will not be able to navigate slides while in draw or erase mode.
#'
#' You may toggle the visibility of the scribble toolbox by pressing `S` at
#' any time. Your drawings will persist when changing slides. You may save a
#' permanent copy of the slides with the markup by printing your presentation
#' (e.g. using Chrome > File > Print).
#'
#' @section Usage: To add scribble to your `xaringan` presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-scribble, echo=FALSE}
#'   xaringanExtra::use_scribble()
#'   ```
#'   ````
#'
#' @examples
#' use_scribble()
#'
#' @param pen_color Initial pen color (default is `"#FF0000` (red)). Must be a
#'   hexadecimal color, e.g. `#000` or `#4232ea`.
#' @param pen_size Pen size (default is 3).
#' @param eraser_size Eraser size (default is `pen_size * 10`).
#' @param palette A selection of up to 10 colors that become available when
#'   drawing is active via the keys `0` through `9`. Press the number keys of
#'   0-9 to quickly active each of the palette colors.
#'
#' @return An `htmltools::tagList()` with the scribble dependencies, or an
#'   [htmltools::htmlDependency()].
#'
#' @name scribble
NULL

#' @describeIn scribble Adds scribble to your xaringan slides.
#' @export
use_scribble <- function(
  pen_color = "#FF0000",
  pen_size = 3,
  eraser_size = pen_size * 10,
  palette = NULL
) {
  htmltools::tagList(
    html_dependency_fabricjs(),
    html_dependency_scribble(
      pen_color,
      pen_size,
      eraser_size,
      palette
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
#'   scribble dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_scribble()` instead.
#'
#' @export
html_dependency_scribble <- function(
  pen_color,
  pen_size,
  eraser_size,
  palette = NULL
) {
  htmltools::htmlDependency(
    name = "xaringanExtra-scribble",
    version = "0.0.1",
    package = "xaringanExtra",
    src = "scribble",
    script = "scribble.js",
    stylesheet = "scribble.css",
    head = init_scribble(pen_color, pen_size, eraser_size, palette),
    all_files = FALSE
  )
}

init_scribble <- function(
  pen_color = "#FF0000",
  pen_size = 3,
  eraser_size = pen_size * 10,
  palette = NULL
) {
  # Current we expect one color, we may lift this restriction in the future
  stopifnot(
    "single pen color" = length(pen_color) == 1,
    "pen_color must be character" = is.character(pen_color),
    "pen_color must be a hexadecimal color" = all(is_hex_color(pen_color))
  )
  stopifnot(is.numeric(pen_size))
  stopifnot(is.numeric(eraser_size))

  palette <- palette %||% list()
  if (length(palette) > 10) {
    warning("The scribble easy-access palette accepts at most 10 colors.")
    palette <- palette[1:10]
  }

  opts <- list(
    pen_color = pen_color,
    pen_size = jsonlite::unbox(pen_size),
    eraser_size = jsonlite::unbox(eraser_size),
    palette = palette
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

is_hex_color <- function(x) {
  x <- trimws(x)
  grepl("^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$", x)
}
