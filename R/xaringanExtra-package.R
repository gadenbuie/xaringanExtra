#' xaringanExtra: Extensions for xaringan
#'
#' `xaringanExtra` is a playground of enhancements and extensions for
#' \pkg{xaringan} slides.
#'
#' - Add an overview of your presentation with [use_tile_view()]
#' - Make your slide content editable with [use_editable()]
#' - Announce slide changes with a subtle tone: [use_slide_tone()]
#' - Animate slide transitions with [use_animate_css()]
#' - Add tabbed panels to slides with [use_panelset()]
#' - Add a logo to all of your slides with [use_logo()]
#' - Use the Tachyons CSS utility toolkit: [use_tachyons()]
#' - Create fancy poster-style text blocks with [text_poster()]
#' - Fit your slides to fill the browser window: [use_fit_screen()]
#'
#' @keywords internal
"_PACKAGE"

#' Use xaringanExtra Extensions
#'
#' Load multiple \pkg{xaringanExtra} extensions at once. All extensions can be
#' loaded with this function, except for [text_poster()] which is more easily
#' called directly as needed.
#'
#' @return An [htmltools::tagList()] with the [htmltools::htmlDependency()]s
#'   for the requested extensions.
#' @param include Character vector of extensions to include. One or more of
#'   `"tile_view"`, `"editable"`, `"slide_tone"`, `"animate_css"`, `"panelset"`
#'   `"tachyons"`, `"fit_screen"`.
#' @export
use_xaringan_extra <- function(
  include = c("tile_view", "animate_css", "tachyons", "panelset")
) {
  opts <- c("tile_view", "animate_css", "tachyons", "slide_tone", "fit_screen",
            "panelset", "editable")
  include <- match.arg(include, opts, TRUE)
  includes <- function(x) x %in% include
  htmltools::tagList(
    if (includes("tile_view")) html_dependency_tile_view(),
    if (includes("animate_css")) html_dependency_animate_css(),
    if (includes("tachyons")) html_dependency_tachyons(),
    if (includes("slide_tone")) html_dependency_slide_tone(),
    if (includes("fit_screen")) html_dependency_fit_screen(),
    if (includes("panelset")) html_dependency_panelset(),
    if (includes("editable")) html_dependency_editable()
  )
}

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
