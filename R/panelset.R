#' Panelset
#'
#' A panelset designed for showing off code, but useful for anything really.
#'
#' @return An [htmltools::tagList] with the panelset dependencies, or an
#'   [htmltools::htmlDependency].
#' @section Usage: To add panelset to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-panelset, echo=FALSE}
#'   xaringanExtra::use_panelset()
#'   ```
#'
#'   .panelset[
#'   .panel[.panel-name[app.R]
#'
#'   ```r
#'   hist(runif(100))
#'   ```
#'   ]
#'
#'   .panel[.panel-name[About]
#'
#'   Take a look at the R code in that other panel.
#'   ]
#'   ]
#'   ````
#'
#' @section Customizing styles: The panelset uses custom CSS properties to make
#'   it easier to change the styles of the panel tabs. The default values are
#'   shown in the CSS code below. You can copy the whole CSS block to your
#'   slides and modify the values to customize the style to fit your
#'   presentation.
#'
#'   ````markdown
#'   ```{css echo=FALSE}
#'   .panelset {
#'     --panel-tabs-color: currentColor;
#'     --panel-tabs-color-active: currentColor;
#'     --panel-tabs-color-hover: currentColor;
#'     --panel-tabs-border-bottom: #ddd;
#'     --panel-tabs-inactive-opacity: 0.5;
#'     --panel-tabs-font-family: Menlo, Consolas, Monaco, Liberation Mono, Lucida Console, monospace;
#'   }
#'   ```
#'   ````
#' @name panelset
NULL

#' @describeIn panelset Adds panelset to your xaringan slides.
#' @export
use_panelset <- function() {
  htmltools::tagList(
    html_dependency_panelset()
  )
}

#' @describeIn panelset Returns an [htmltools::htmlDependency] with the tile
#'   view dependencies. Most users will want to use `use_panelset()`.
#' @export
html_dependency_panelset <- function() {
  htmltools::htmlDependency(
    name = "panelset",
    version = utils::packageVersion("xaringanExtra"),
    package = "xaringanExtra",
    src = "panelset",
    script = "panelset.js",
    stylesheet = "panelset.css"
  )
}
