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
#'     --panel-tab-color: currentColor;
#'     --panel-tab-color-active: currentColor;
#'     --panel-tab-color-hover: currentColor;
#'     --panel-tabs-border-bottom: #ddd;
#'     --panel-tab-inactive-opacity: 0.5;
#'     --panel-tab-font-family: Menlo, Consolas, Monaco, Liberation Mono, Lucida Console, monospace;
#'   }
#'   ```
#'   ````
#'
#'   Or use [style_panelset()]:
#'
#'   ````markdown
#'   ```{r echo=FALSE}
#'   style_panelset(panel_tab_color_active = "red")
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

#' @describeIn panelset Style the panelset. Returns an \pkg{htmltools} `<style>`
#'   tag.
#' @param panel_tab_color The text color of a non-active panel tab, default is
#'   `currentColor`.
#' @param panel_tab_color_active The text color of an active, as in selected,
#'   panel tab. Default is `currentColor`
#' @param panel_tab_color_hover The text color of a hovered panel tab. Default
#'   is `currentColor`.
#' @param panel_tabs_border_bottom The border color between the tabs and
#'   content. Default is `#ddd`.
#' @param panel_tab_inactive_opacity The opacity of inactive panel tabs,
#'   default is `0.5`.
#' @param panel_tab_font_family The font family to be used for the panel tabs
#'   text. Default is a monospace system font stack.
#' @export
style_panelset <- function(
  panel_tab_color = NULL,
  panel_tab_color_active = NULL,
  panel_tab_color_hover = NULL,
  panel_tabs_border_bottom = NULL,
  panel_tab_inactive_opacity = NULL,
  panel_tab_font_family = NULL
) {
  args <- lapply(names(formals()), function(x) get(x))
  names(args) <- names(formals())
  args <- args[vapply(args, function(x) !is.null(x), TRUE)]
  if (!length(args)) return(invisible())
  style <- ""
  for (arg in names(args)) {
    style <- paste0(
      style,
      if (style != "") "\n",
      "  --", gsub("_", "-", arg), ": ", args[arg], ";"
    )
  }
  style <- paste(".panelset {", style, "}", sep = "\n")
  htmltools::tags$style(htmltools::HTML(style))
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
