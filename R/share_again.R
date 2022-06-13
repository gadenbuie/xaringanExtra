#' Share or Embed xaringan Slides
#'
#' The _share again_ extension helps you share your xaringan slides. Adding the
#' extension to your slides with `use_share_again()` enables a "share" bar that
#' only appears when your slides are embedded in a web page in an `<iframe>`. To
#' embed your presentation in another page, like a blogdown post or a R Markdown
#' based site, use `embed_xaringan()`. This function adds your slides in a
#' responsive aspect ratio container that seamlessly includes your slides in
#' the page. Finally, for perfect looking slides, use `style_share_again()` to
#' style the share bar to match your slides' aesthetic. You can also use this
#' function to enable or disable specific social media sites and platforms from
#' the share menu.
#'
#' @examples
#' # In your slides call
#' use_share_again()
#'
#' # In the document where you want to embed the slides call
#' embed_xaringan("https://slides.yihui.org/xaringan/")
#'
#' @seealso [embed_xaringan()]
#' @name share_again
NULL

#' @describeIn share_again Add the _share again_ bar to your slides (only shown
#'   when embedded in an `<iframe>`)
#'
#' @return An `htmltools::tagList()` with the HTML dependencies required for
#'   **share again**.
#'
#' @export
use_share_again <- function() {
  htmltools::tagList(
    html_dependency_clipboardjs(),
    html_dependency_shareon(),
    html_dependency_shareagain()
  )
}

#' @describeIn share_again Style the _share again_ bar to match your slides, or
#'   choose the social media sites included in the share menu
#'
#' @param foreground The foreground color of the buttons and text in the share bar
#' @param background The background color of the share bar
#' @param share_buttons A vector of social media platforms to be included in the
#'   share menu of the share bar. You can include `"all"` sites or `"none"` of
#'   buttons, and if either are included in `share_buttons`, then the rest of
#'   the vector is ignored. (And `"all"` takes precedence over `"none"`.) The
#'   _copy link_ option is always included.
#'
#' @export
style_share_again <- function(
  foreground = "rgb(255, 255, 255)",
  background = "rgba(0, 0, 0, 0.5)",
  share_buttons = c("all", "none", "twitter", "facebook", "linkedin", "pinterest", "pocket", "reddit")
) {
  social_sites <- share_button_social_options()

  share_buttons <- match.arg(share_buttons, several.ok = TRUE)

  if ("all" %in% share_buttons && length(share_buttons) > 1) {
    share_buttons <- "all"
  }

  if ("none" %in% share_buttons && length(share_buttons) > 1) {
    share_buttons <- "none"
  }

  share_buttons_hide <- if (identical(share_buttons, "none")) {
    social_sites
  } else if (!identical(share_buttons, "all")) {
    setdiff(social_sites, share_buttons)
  }

  vars_buttons <- if (!is.null(share_buttons_hide) && length(share_buttons_hide)) {
    sprintf("--shareagain-%s: none;", share_buttons_hide)
  }

  css_vars <- c(
    if (!is.null(foreground)) sprintf("--shareagain-foreground: %s;", foreground),
    if (!is.null(background)) sprintf("--shareagain-background: %s;", background),
    vars_buttons
  )

  if (!length(css_vars)) {
    return()
  }

  css_vars <- paste(".shareagain-bar {", paste(css_vars, collapse = "\n"), "}", sep = "\n")

  htmltools::tags$style(css_vars)
}

share_button_social_options <- function() {
  full_share_options <- eval(formals("style_share_again")[["share_buttons"]])
  setdiff(full_share_options, c("all", "none"))
}

#' Embed a xaringan presentation in a web page
#'
#' Embed xaringan slides in any HTML web page, such as a blogdown page or an
#' R Markdown website. The presentation is embedded in a responsive aspect ratio
#' container for seamless integration with your web page. This feature works
#' best when combined with [use_share_again()], but `embed_xaringan()` can be
#' used for any xaringan presentation.
#'
#' @examples
#' # In your slides call
#' use_share_again()
#'
#' @param url The URL or path to the presentation to embed.
#' @param ratio The ratio of the presentation, either as `"width:height"` or
#'   `width/height`, e.g. `"16:9"` or `1.7777`.
#' @param border The border style of the embedded `<iframe>`. For no border, use
#'   `"none"`.
#' @param max_width The max width of the `<iframe>`, in a valid CSS units.
#' @param margin The margin placed around the embedded `<iframe>`.
#' @param style Additional CSS `style` property value pairs, e.g.
#'   `c("padding-left: 1em", "padding-right: 1em")`.
#'
#' @return An `htmltools::tagList()` with the HTML dependencies required for
#'   **share again**.
#'
#' @seealso [use_share_again()]
#' @export
embed_xaringan <- function(
  url,
  ratio = "16:9",
  border = "2px solid currentColor",
  max_width = NULL,
  margin = "1em auto",
  style = NULL
) {
  ratio <- parse_ratio(ratio)
  style <- paste(style, collapse = ";")
  style <- sprintf("border:%s;%s", border, style)
  style <- gsub(";;", ";", style) # just in case

  parent_style <- sprintf("min-width:300px;margin:%s;", margin)
  if (!is.null(max_width)) {
    parent_style <- sprintf(
      "%smax-width:%s;",
      parent_style,
      htmltools::validateCssUnit(max_width)
    )
  }

  htmltools::tagList(
    htmltools::div(
      class = "shareagain",
      style = parent_style,
      htmltools::tags$iframe(
        src = url,
        width = unname(ratio["width"]),
        height = unname(ratio["height"]),
        style = style,
        loading = "lazy",
        allowfullscreen = NA
      ),
      htmltools::tags$script(htmltools::HTML("fitvids('.shareagain', {players: 'iframe'});")),
      html_dependency_fitvids()
    )
  )
}

parse_ratio <- function(x) {
  x <- strsplit(as.character(x), ":")[[1]]
  x <- suppressWarnings(as.numeric(x))
  x <- x[!is.na(x)]
  if (!length(x) %in% 1:2) {
    stop("ratio must be \"w:h\" or a single number representing w/h")
  }
  if (length(x) == 1) {
    c(width = x, height = 1) * 300
  } else {
    c(width = x[1], height = x[2]) * 100
  }
}

html_dependency_shareagain <- function() {
  htmltools::htmlDependency(
    name = "xaringanExtra-shareagain",
    version = "0.2.6",
    package = "xaringanExtra",
    src = "share-again",
    script = "shareagain.js",
    stylesheet = "shareagain.css",
    all_files = FALSE
  )
}

html_dependency_fitvids <- function() {
  # https://github.com/rosszurowski/fitvids/
  htmltools::htmlDependency(
    name = "fitvids",
    version = "2.1.1",
    package = "xaringanExtra",
    src = c(
      file = "jslib/fitvids",
      href = "https://unpkg.com/fitvids@2.1.1/dist/"
    ),
    script = "fitvids.min.js",
    all_files = FALSE
  )
}

html_dependency_shareon <- function() {
  # https://github.com/NickKaramoff/shareon
  # https://shareon.js.org/
  htmltools::htmlDependency(
    name = "shareon",
    version = "1.4.1",
    package = "xaringanExtra",
    src = c(
      file = "jslib/shareon",
      href = "https://unpkg.com/shareon@1.4.1/dist/"
    ),
    script = "shareon.min.js",
    stylesheet = "shareon.min.css",
    all_files = FALSE
  )
}
