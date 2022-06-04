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
#' @includeRmd man/fragments/panelset_sideways.Rmd
#'
#' @includeRmd man/fragments/panelset_custom-styles.Rmd
#'
#' @includeRmd man/fragments/panelset_other-rmd.Rmd
#'
#' @includeRmd man/fragments/panelset_chunks.Rmd
#'
#' @examples
#' use_panelset()
#'
#' @name panelset
NULL

#' @describeIn panelset Adds panelset to your xaringan slides.
#' @param in_xaringan Set to `TRUE` if rendering in xaringan slides or `FALSE`
#'   if using panelset elsewhere. This determines the style of knitr hook that
#'   is registered to enable the `panelset` chunk option.
#' @export
use_panelset <- function(in_xaringan = NULL) {
  register_panelset_knitr_hooks(in_xaringan)
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
#' @param tabs_sideways_max_width The maximum width of the tabs in sideways
#'   mode. The default value is `25%`. A value between 25% and 33% is
#'   recommended. The tabs can only ever be at most 50% of the container width.
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
  tabs_sideways_max_width = NULL,
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

  if ("--panel-tab-font-family" %in% names(args) &&
    identical(args["--panel-tab-font-family"], "monospace")) {
    args["--panel-tab-font-family"] <- "Menlo, Consolas, Monaco, Liberation Mono, Lucida Console, monospace"
  }

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
  vars <- c(
    foreground = "--panel-tab-foreground",
    background = "--panel-tab-background",
    active_foreground = "--panel-tab-active-foreground",
    active_background = "--panel-tab-active-background",
    active_border_color = "--panel-tab-active-border-color",
    hover_background = "--panel-tab-hover-background",
    hover_foreground = "--panel-tab-hover-foreground",
    hover_border_color = "--panel-tab-hover-border-color",
    tabs_border_bottom = "--panel-tabs-border-bottom",
    inactive_opacity = "--panel-tab-inactive-opacity",
    font_family = "--panel-tab-font-family",
    tabs_sideways_max_width = "--panel-tabs-sideways-max-width"
  )

  if (is.null(x)) {
    return(vars)
  }
  vars[x]
}

#' @describeIn panelset Returns an [htmltools::htmlDependency()] with the tile
#'   view dependencies. Most users will want to use `use_panelset()`.
#' @export
html_dependency_panelset <- function() {
  htmltools::htmlDependency(
    name = "panelset",
    version = "0.2.6",
    package = "xaringanExtra",
    src = "panelset",
    script = "panelset.js",
    stylesheet = "panelset.css"
  )
}

# package env to hold original knitr hooks
.hooks <- new.env(parent = emptyenv())

register_panelset_knitr_hooks <- function(in_xaringan = NULL) {
  if (!knitr::is_html_output()) {
    return()
  }

  .hooks$source <- knitr::knit_hooks$get("source")
  .hooks$output <- knitr::knit_hooks$get("output")

  in_xaringan <- output_is_xaringan(in_xaringan)

  # ::: start-code-panel   <- panelset source hook
  # source code            <- original source hook
  # ::: end-code-panel     <- panelset source hook
  # ::: start-output-panel <- panelset source hook
  # output
  # ::: end-output-panel   <- panelset knit hook, !before

  knitr::knit_hooks$set(source = function(x, options) {
    if (is.null(options$panelset) || identical(options$panelset, FALSE)) {
      return(.hooks$source(x, options))
    }

    if (isTRUE(in_xaringan)) {
      panelset_chunk_before_xaringan(x, options)
    } else {
      panelset_chunk_before_html(x, options)
    }
  })

  knitr::knit_hooks$set(panelset = function(before, options, ...) {
    if (before) {
      return()
    }
    if (isTRUE(in_xaringan)) "\n\n]" else "\n\n</div>"
  })

  knitr::opts_hooks$set(panelset = function(options) {
    # panelset chunks ignore global options and default to results="hold"
    # but can be overwritten by the local chunk options if declared explicitly
    chunk_opts <- attr(knitr::knit_code$get(options$label), "chunk_opts")
    options$results <- chunk_opts$results %||% "hold"
    options
  })
}

panelset_source_opts <- function(opt) {
  if (is.null(opt)) {
    return(NULL)
  }

  default <- c(source = "Code", output = "Output")
  opt <- unlist(opt)
  if (isTRUE(opt) || length(opt) < 1 || !is.character(opt)) {
    return(default)
  }

  if (!is.null(names(opt))) {
    opt <- opt[intersect(names(default), names(opt))]
  }

  if (length(opt) > 2) {
    warning("`panelset` chunk option expects at most two values")
    opt <- opt[1:2]
  }

  if (is.null(names(opt))) {
    names(opt) <- names(default)[seq_along(opt)]
  }

  if (!length(opt) == 2) {
    opt <- c(
      opt[intersect(names(default), names(opt))],
      default[setdiff(names(default), names(opt))]
    )
  }

  opt[names(default)]
}

panelset_chunk_before_xaringan <- function(x, options) {
  panel_names <- panelset_source_opts(options$panelset)

  paste(
    sprintf(".panel[.panel-name[%s]", panel_names["source"]),
    "",
    .hooks$source(x, options),
    "\n]\n",
    sprintf(".panel[.panel-name[%s]", panel_names["output"]),
    "\n",
    sep = "\n"
  )
}

panelset_chunk_before_html <- function(x, options) {
  panel_names <- panelset_source_opts(options$panelset)

  paste(
    '<div class="panel">',
    sprintf('<div class="panel-name">%s</div>', panel_names["source"]),
    "",
    .hooks$source(x, options),
    "\n</div>\n",
    '<div class="panel">',
    sprintf('<div class="panel-name">%s</div>', panel_names["output"]),
    "\n",
    sep = "\n"
  )
}

output_is_xaringan <- function(in_xaringan) {
  if (isTRUE(in_xaringan)) {
    return(TRUE)
  }

  # This will probably work in most cases but I'm not sure how else to be
  # certain that the document currently being rendered is xaringan slides...
  has_xaringan_page_opt() && is_moon_reader_output()
}

has_xaringan_page_opt <- function() {
  !is.null(getOption("xaringan.page_number.offset", NULL))
}

is_moon_reader_output <- function() {
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    # Not sure how we'd get here but just in case, skip this check
    return(TRUE)
  }
  grepl(
    "moon_reader",
    rmarkdown::all_output_formats(knitr::current_input())
  )
}
