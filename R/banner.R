#' Add a banner to the top or bottom of your slides.
#'
#' Adds a banner to all the slides in your deck at the top or the bottom of the
#' slide. You can place content in the left, center, or right portion of the
#' banner.
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
#'
#' @examples
#' use_banner(bottom_left = "bit.ly/my-awesome-slides")
#'
#' use_banner(
#'   bottom_left = "bit.ly/my-awesome-slides",
#'   top_center = "My Presentation",
#'   exclude = c("title-slide", "inverse")
#' )
#'
#' @export
use_banner <- function(
  bottom_left = NULL,
  bottom_center = NULL,
  bottom_right = NULL,
  top_left = NULL,
  top_center = NULL,
  top_right = NULL,
  exclude = NULL
) {
  top <- banner_opts(top_left, top_center, top_right, "top", exclude)
  bottom <- banner_opts(bottom_left, bottom_center, bottom_right, "bottom", exclude)

  htmltools::tagList(
    top,
    bottom,
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

banner_opts <- function(
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
