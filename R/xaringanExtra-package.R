#' xaringanExtra: Extensions for xaringan
#'
#' `xaringanExtra` is a playground of enhancements and extensions for
#' \pkg{xaringan} slides.
#'
#' - Add an overview of your presentation with [use_tile_view()]
#' - Make your slide content editable with [use_editable()]
#' - Share your slides in style with [use_share_again()]
#' - Broadcast your slides in real time to viewers with [use_broadcast()]
#' - Scribble on your slides during your presentation with [use_scribble()]
#' - Announce slide changes with a subtle tone: [use_slide_tone()]
#' - Animate slide transitions with [use_animate_css()]
#' - Add tabbed panels to slides with [use_panelset()]
#' - Add a logo to all of your slides with [use_logo()]
#' - Add a top or bottom banner to all of your slides with [use_banner()]
#' - Add a search box to search through your slides with [use_search()]
#' - Use the Tachyons CSS utility toolkit: [use_tachyons()]
#' - Add a live video feed to you slides with [use_webcam()]
#' - Always play gifs from the start with [use_freezeframe()]
#' - Add one-click code copying with [use_clipboard()]
#' - Fit your slides to fill the browser window: [use_fit_screen()]
#'
#' @keywords internal
"_PACKAGE"

#' Use xaringanExtra Extensions
#'
#' Load multiple \pkg{xaringanExtra} extensions at once. All extensions can be
#' loaded with this function.
#'
#' @examples
#' use_xaringan_extra(c("tile_view", "panelset"))
#' use_xaringan_extra(c("tile_view", "scribble", "share_again"))
#'
#' @return An `htmltools::tagList()` with the [htmltools::htmlDependency()]s
#'   for the requested extensions.
#' @param include Character vector of extensions to include. One or more of
#'   `"tile_view"`, `"editable"`, `"share_again"`, `"broadcast"`, `"slide_tone"`,
#'   `"animate_css"`, `"panelset"` `"tachyons"`, `"fit_screen"`, `"webcam"`,
#'   `"clipboard"`, `"search"`, `"scribble"`, `"freezeframe"`.
#' @export
use_xaringan_extra <- function(include = c(
    "tile_view",
    "animate_css",
    "tachyons",
    "panelset",
    "broadcast",
    "share_again",
    "scribble"
  )) {
  opts <- c(
    "tile_view",
    "animate_css",
    "tachyons",
    "slide_tone",
    "fit_screen",
    "panelset",
    "editable",
    "webcam",
    "clipboard",
    "share_again",
    "broadcast",
    "search",
    "scribble",
    "freezeframe"
  )
  include <- match.arg(include, opts, TRUE)
  includes <- function(x) x %in% include
  htmltools::tagList(
    if (includes("tile_view")) html_dependency_tile_view(),
    if (includes("animate_css")) html_dependency_animate_css(),
    if (includes("tachyons")) html_dependency_tachyons(),
    if (includes("slide_tone")) html_dependency_slide_tone(),
    if (includes("fit_screen")) html_dependency_fit_screen(),
    if (includes("panelset")) use_panelset(),
    if (includes("editable")) html_dependency_editable(),
    if (includes("webcam")) html_dependency_webcam(),
    if (includes("clipboard")) use_clipboard(),
    if (includes("share_again")) use_share_again(),
    if (includes("broadcast")) use_broadcast(),
    if (includes("search")) use_search(),
    if (includes("scribble")) use_scribble(),
    if (includes("freezeframe")) use_freezeframe()
  )
}

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
