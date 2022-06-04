#' Add Extra CSS Styles
#'
#' Adds CSS extras to your slides. You can select which extras you wish to add
#' to your slides.
#'
#' @examples
#' use_extra_styles()
#'
#' @name extra_styles
NULL

#' @describeIn extra_styles Add the extra CSS styles to your slides
#' @param hover_code_line Adds a hover effect for code chunks in your slides.
#'   Adds a floating pointer to the hovered line and makes the line bold.
#' @param mute_unhighlighted_code On code chunks with highlights (added with
#'   line-ending `#<<` comments or starting with `*`), non-highlighted lines
#'   are muted and the highlighted line is full opacity.
#' @param bundle_id Make the CSS bundle unique. Use this if your slides share
#'   a common resource directory and you want to include different CSS extras
#'   in different slides.
#'
#' @return An [htmltools::htmlDependency()] with the selected additional styles.
#' @export
use_extra_styles <- function(
  hover_code_line = TRUE,
  mute_unhighlighted_code = TRUE,
  bundle_id = NULL
) {
  dep <- html_dependency_extra_styles(
    hover_code_line,
    mute_unhighlighted_code,
    bundle_id
  )
  if (is.null(dep)) {
    return(invisible())
  }

  htmltools::tagList(dep)
}

#' @describeIn extra_styles Returns an [htmltools::htmlDependency()] with the
#'   extra styles dependencies. Most users will want to use `use_extra_styles()`.
#' @export
html_dependency_extra_styles <- function(
  hover_code_line = TRUE,
  mute_unhighlighted_code = TRUE,
  bundle_id = NULL
) {
  if (!any(c(hover_code_line, mute_unhighlighted_code))) {
    return(invisible())
  }

  css_file <- file.path(tempdir(), "xaringanExtra-extra-styles.css")
  if (file.exists(css_file)) unlink(css_file)

  add_to_css <- function(...) {
    new_css <- readLines(xe_file("extra-styles", ...), warn = FALSE)
    cat(new_css, file = css_file, sep = "\n", append = TRUE)
  }

  if (isTRUE(hover_code_line)) {
    add_to_css("code-line-hover.css")
  }

  if (isTRUE(mute_unhighlighted_code)) {
    add_to_css("code-mute-unhighlighted.css")
  }

  name <- paste0("xaringanExtra-extra-styles", if (!is.null(bundle_id)) {
    paste0(
      "_",
      bundle_id
    )
  })

  htmltools::htmlDependency(
    name = name,
    version = "0.2.6",
    src = dirname(css_file),
    stylesheet = basename(css_file),
    all_files = FALSE
  )
}
