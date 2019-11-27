#' xaringanExtra: Extensions for xaringan
#'
#' `xaringanExtra` is a playground of enhancements and addins for
#' \pkg{xaringan} slides.
#'
#' - Add an overview of your presentation with [use_tile_view()]
#' - Announce slide changes with a subtle tone: [use_slide_tone()]
#' - Animate slide transitions with [use_animate_css()]
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
#' @return An [htmltools::tagList()] with the [htmltools::html_dependency()]s
#'   for the requested extensions.
#' @param include Character vector of extensions to include. One or more of
#'   `"tile_view"`, `"animate_css"`, `"tachyons"`, `"slide_tone"`,
#'   `"fit_screen"`.
#' @export
use_xaringan_extra <- function(
  include = c("tile_view", "animate_css", "tachyons")
) {
  opts <- c("tile_view", "animate_css", "tachyons", "slide_tone", "fit_screen")
  include <- match.arg(include, opts, TRUE)
  includes <- function(x) x %in% include
  htmltools::tagList(
    if (includes("tile_view")) html_dependency_tile_view(),
    if (includes("animate_css")) html_dependency_animate_css(),
    if (includes("tachyons")) html_dependency_tachyons(),
    if (inlcudes("slide_tone")) html_dependency_slide_tone(),
    if (includes("fit_screen")) html_dependency_fit_screen()
  )
}

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
