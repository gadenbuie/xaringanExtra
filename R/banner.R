#' Add a banner to the top or bottom of your slides.
#'
#' Adds a banner to all the slides in your deck at the top or the bottom of the
#' slide. You can place content in the left, center, or right portion of the
#' banner.
#'
#' @examples
#' use_banner(bottom_left = "bit.ly/my-awesome-slides")
#'
#' use_banner(
#'   bottom_left = "bit.ly/my-awesome-slides",
#'   top_center = "My Presentation",
#'   exclude = c("title-slide", "inverse"),
#'   style_banner(text_color = "grey")
#' )
#'
#' @param bottom_left,top_left Text or HTML to place in the left column of the
#'   top or bottom of the slide.
#' @param bottom_right,top_right Text or HTML to place in the right column of
#'   the top or bottom of the slide.
#' @param bottom_center,top_center Text or HTML to place in the center column
#'   at the top or the bottom of the slide.
#' @param exclude A vector of slide classes where the banner should not be
#'   applied. By default all slides are included, but you might want to exclude
#'   the title and inverse slides with `exclude = c("title-slide", "inverse")`.
#' @param ... Banner styles created with [style_banner()]. Technically,
#'   additional arguments are added into the [htmltools::tagList()] with the
#'   banner dependencies, but you'll only want to use [style_banner()] calls
#'   here.
#'
#' @return An [htmltools::tagList()] with the banner dependencies, or an
#'   [htmltools::htmlDependency].
#'
#' @seealso [style_banner()]
#' @export
use_banner <- function(
  bottom_left = NULL,
  bottom_center = NULL,
  bottom_right = NULL,
  top_left = NULL,
  top_center = NULL,
  top_right = NULL,
  exclude = NULL,
  ...
) {
  top <- init_banner(top_left, top_center, top_right, "top", exclude)
  bottom <- init_banner(bottom_left, bottom_center, bottom_right, "bottom", exclude)

  htmltools::tagList(
    top,
    bottom,
    ...,
    htmltools::htmlDependency(
      name = "xaringanExtra-banner",
      version = "0.0.1",
      package = "xaringanExtra",
      src = "banner",
      script = "banner.js",
      stylesheet = "banner.css",
      all_files = FALSE
    )
  )
}

#' Style Banner
#'
#' Change the banner style properties for a specific selector. By default, the
#' changes apply to all banners, but by setting `selector` you can apply style
#' changes to the banners of specific slide styles. For example, to set the
#' styles for inverse slides, use `selector = ".inverse"`.
#'
#' @examples
#' style_banner(text_color = "red")
#' style_banner(text_color = "white", background_color = "red")
#'
#' @param text_color The color of text in the banners which may be overridden by
#'   other styles, e.g. link color, etc. The default value inherits from the
#'   primary text color of the slide.
#' @param background_color The color of the banner background. By default
#'   the background is transparent.
#' @param padding_horizontal,padding_vertical The inner padding of the banner.
#'   By default no padding is applied in the vertical direction, but `2em` of
#'   padding is applied horizontally. If anything, you probably only want to
#'   change the value of `padding_horizontal`.
#' @param height The height of the banner in a valid CSS unit.
#' @param width The maximum width of each column in the banner. You can set the
#'   width for all columns with a single valid CSS unit, or you may provide a
#'   vector of CSS units, named `"left"`, `"center"`, or `"right"` or provided
#'   in that order.
#' @param font_size,font_family The font size and family of the text in the
#'   banner. The default font size is `0.7em` and the default family inherits
#'   from the primary text of the slide.
#' @param z_index The z-index of the banner. By default this value is 0 so that
#'   all other content appears over the banner. To ensure the banner appears
#'   *above slide content*, you can set `z_index` to something greater than 0.
#' @param selector A CSS selector, e.g. `".inverse"`, where the styles set in
#'   this call should be applied. Typically, you'll either set these styles for
#'   all banners using the default `selector`, or you'll want to customize the
#'   banner appearance for particular slide classes. Note that you can call
#'   `style_banner()` as many times as you want in your slides, but you'll want
#'   to change the `selector` for each call.
#'
#' @return Returns a `<style>` tag with the banner styles for `selector` as
#'   HTML via [htmltools::HTML()].
#'
#' @seealso [use_banner()]
#' @export
style_banner <- function(
  text_color = NULL,
  background_color = NULL,
  padding_horizontal = NULL,
  padding_vertical = NULL,
  height = NULL,
  width = NULL,
  font_size = NULL,
  font_family = NULL,
  z_index = NULL,
  selector = ":root"
) {
  assert_len_1 <- function(x) {
    var <- deparse(substitute(x))

    if (is.null(x) || length(x) <= 1) {
      return(x)
    }

    stop(sprintf("`%s` must be length-1", var))
  }

  assert_len_1(selector)

  css <- list(
    fg            = assert_len_1(text_color),
    bg            = assert_len_1(background_color),
    height        = assert_len_1(height),
    "z-index"     = assert_len_1(z_index),
    "padding-x"   = assert_len_1(padding_horizontal),
    "padding-y"   = assert_len_1(padding_vertical),
    "font-size"   = assert_len_1(font_size),
    "font-family" = assert_len_1(font_family)
  )
  css <- style_banner_width(css, width)

  css <- compact(css)
  if (!length(css)) {
    return(invisible())
  }

  unit_vars <- c(
    "padding-x", "padding-y", "height", "font-size",
    "width-left", "width-right", "width-center"
  )
  unit_vars <- intersect(unit_vars, names(css))
  for (unit_var in unit_vars) {
    if (!css[[unit_var]] %in% c("inherit", "unset", "initial", "revert")) {
      css[[unit_var]] <- htmltools::validateCssUnit(css[[unit_var]])
    }
  }

  names(css) <- paste0("--xe-banner-", names(css))
  css <- paste(sprintf("  %s: %s;", names(css), unlist(css)), collapse = "\n")
  css <- sprintf("%s {\n%s\n}", selector, css)
  htmltools::tags$style(htmltools::HTML(css))
}

style_banner_width <- function(css, width) {
  if (is.null(width)) {
    return(css)
  }
  if (length(width) < 1 || length(width) > 3) {
    stop(
      "`width` must be named vector or at most length 3 ",
      "('left', 'center', 'right')"
    )
  }
  if (length(width) == 1) {
    width <- rep(width, 3)
  }
  if (is.null(names(width))) {
    names(width) <- c("left", "center", "right")[1:length(width)]
  } else {
    bad <- setdiff(names(width), c("left", "center", "right"))
    if (length(bad)) {
      stop(
        "`width` contains unexpected names: ",
        paste(bad, collapse = ", ")
      )
    }
  }
  names(width) <- paste0("width-", names(width))
  c(css, width)
}

init_banner <- function(
  left = NULL,
  center = NULL,
  right = NULL,
  position = "bottom",
  exclude = NULL
) {
  opts <- compact(list(left = left, center = center, right = right, exclude = exclude))
  opts <- lapply(opts, function(x) {
    if (!is.character(x)) {
      x <- format(x)
    }
    paste(x, collapse = " ")
  })
  if (length(opts)) {
    opts$position <- position
    if (!is.null(opts$exclude)) {
      opts$exclude <- I(opts$exclude)
    }
    opts <- sprintf(
      "<script>document.addEventListener('DOMContentLoaded',function(){new xeBanner(JSON.parse('%s'))})</script>",
      jsonlite::toJSON(opts, auto_unbox = TRUE)
    )
    opts <- gsub('\\\\"', '\\\\\\\\"', opts)
    htmltools::HTML(opts)
  }
}
