#' Panelset
#'
#' A panelset designed for showing off code, but useful for anything really.
#'
#' @return An `htmltools::tagList()` with the panelset dependencies, or an
#'   [htmltools::htmlDependency()].
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
#' @includeRmd man/fragments/panelset_custom-styles.Rmd
#'
#' @includeRmd man/fragments/panelset_other-rmd.Rmd
#'
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
#' @param foreground The text color of a non-active panel tab, default is
#'   `currentColor`.
#' @param active_foreground The text color of an active, as in selected, panel
#'   tab. Default is `currentColor`.
#' @param hover_foreground The text color of a hovered panel tab. Default is
#'   `currentColor`.
#' @param tabs_border_bottom The border color between the tabs and content.
#'   Default is `#ddd`.
#' @param inactive_opacity The opacity of inactive panel tabs, default is `0.5`.
#' @param font_family The font family to be used for the panel tabs text.
#'   Default is a monospace system font stack.
#' @param background,active_background,hover_background Background colors for
#'   panel tabs; in-active tabs, active tab, hovered tab. The default values are
#'   all `unset`.
#' @param active_border_color,hover_border_color The color of the top border of
#'   a tab when it is active or the color of the bottom border of a tab when it
#'   is hovered or focused. Defaults are `currentColor`.
#' @param selector The CSS selector used to choose which panelset is being
#'   styled. In most cases, you can use the default selector and style all
#'   panelsets on the page.
#' @export
style_panelset_tabs <- function(
  foreground = NULL,
  background = NULL,
  ...,
  active_foreground = NULL,
  active_background = NULL,
  active_border_color = NULL,
  hover_background = NULL,
  hover_foreground = NULL,
  hover_border_color = NULL,
  tabs_border_bottom = NULL,
  inactive_opacity = NULL,
  font_family = NULL,
  selector = ".panelset"
) {
  if (length(list(...))) {
    warning(
      "The arguments to `syle_panelset()` changed in xaringanExtra 0.1.0. ",
      "Please refer to the documentation to update your slides.",
      immediate. = TRUE
    )
  }

  fn_args <- setdiff(names(formals()), c("...", "selector"))
  names(fn_args) <- fn_args
  args <- lapply(fn_args, function(x) get(x))
  args <- args[vapply(args, function(x) !is.null(x), TRUE)]
  if (!length(args)) {
    return(invisible(NULL))
  }

  names(args) <- panelset_match_vars(names(args))

  style <- ""
  for (var in names(args)) {
    style <- paste0(style, var, ": ", args[var], ";")
  }
  style <- paste0("<style>", selector, "{", style, "}</style>")
  htmltools::HTML(style)
}

#' @describeIn panelset Deprecated, renamed `style_panelset_tabs()`.
#' @param ... Ignored or passed from `style_panelset()` to `style_panelset_tabs()`.
#' @export
style_panelset <- function(...) {
  .Deprecated("style_panelset_tabs")
  style_panelset_tabs(...)
}

panelset_match_vars <- function(x = NULL) {
  vars <-  c(
    foreground          = "--panel-tab-foreground",
    background          = "--panel-tab-background",
    active_foreground   = "--panel-tab-active-foreground",
    active_background   = "--panel-tab-active-background",
    active_border_color = "--panel-tab-active-border-color",
    hover_background    = "--panel-tab-hover-background",
    hover_foreground    = "--panel-tab-hover-foreground",
    hover_border_color  = "--panel-tab-hover-border-color",
    tabs_border_bottom  = "--panel-tabs-border-bottom",
    inactive_opacity    = "--panel-tab-inactive-opacity",
    font_family         = "--panel-tab-font-family"
  )

  if (is.null(x)) return(vars)
  vars[x]
}

#' @describeIn panelset Returns an [htmltools::htmlDependency()] with the tile
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
