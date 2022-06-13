#' Search
#'
#' Search gives you a way to quickly search for text on slides.
#'
#' @return An `htmltools::tagList()` with the search dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add search to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-search, echo=FALSE}
#'   xaringanExtra::use_search()
#'   ```
#'   ````
#'
#' @examples
#' use_search()
#'
#' @references <https://github.com/arestivo/remark.search>
#' @author Original implementation by André Restivo
#' @name search
NULL

#' @describeIn search Adds search to your xaringan slides.
#' @export
use_search <- function(
  position = c("bottom-left", "bottom-right", "top-left", "top-right"),
  case_sensitive = FALSE,
  show_icon = FALSE,
  auto_search = TRUE
) {
  htmltools::tagList(
    html_dependency_markjs(),
    html_dependency_search(position, case_sensitive, show_icon, auto_search)
  )
}

#' @describeIn search Returns an [htmltools::htmlDependency()] with the search
#'   dependencies. Most users will want to use `use_search()`.
#'
#' @param position Where to place the search box.
#' @param case_sensitive If `FALSE`, ignores case of search and text.
#' @param show_icon Show the icon to open or close the search?
#' @param auto_search Search on each keystroke (`TRUE`) or on enter (`FALSE`)?
#'
#' @export
html_dependency_search <- function(
  position = c("bottom-left", "bottom-right", "top-left", "top-right"),
  case_sensitive = FALSE,
  show_icon = FALSE,
  auto_search = TRUE
) {
  htmltools::htmlDependency(
    name = "xaringanExtra-search",
    version = "0.0.1",
    package = "xaringanExtra",
    src = "search",
    script = "search.js",
    stylesheet = "search.css",
    head = init_search(position, case_sensitive, show_icon, auto_search),
    all_files = FALSE
  )
}

#' @describeIn search Style the search input.
#'
#' @param icon_fill Color of search icon
#' @param input_background Color of search input box background
#' @param input_foreground Color of text in search input box
#' @param input_border Border style of search input box
#' @param match_background Color of match background (not current)
#' @param match_foreground Color of match text (not current)
#' @param match_current_background Color of current match background
#' @param match_current_foreground Color of current match text
#' @param selector CSS selector specifying which search bar to update (for
#'   advanced or unusual uses only)
#'
#' @export
style_search <- function(
  icon_fill = "rgba(128, 128, 128, 0.5)",
  input_background = "rgb(204, 204, 204)",
  input_foreground = "black",
  input_border = "1px solid rgb(249, 38, 114)",
  match_background = "rgb(38, 220, 249)",
  match_foreground = "black",
  match_current_background = "rgb(38, 249, 68)",
  match_current_foreground = "black",
  selector = ".search"
) {
  css <- sprintf(
    "
%s {
  --search-icon-fill: %s;
  --search-input-background: %s;
  --search-input-foreground: %s;
  --search-input-border: %s;
  --search-match-background: %s;
  --search-match-foreground: %s;
  --search-match-current-background: %s;
  --search-match-current-foreground: %s;
}",
    selector,
    icon_fill,
    input_background,
    input_foreground,
    input_border,
    match_background,
    match_foreground,
    match_current_background,
    match_current_foreground
  )

  htmltools::tags$style(htmltools::HTML(css))
}

init_search <- function(
  position = c("bottom-left", "bottom-right", "top-left", "top-right"),
  case_sensitive = FALSE,
  show_icon = FALSE,
  auto_search = TRUE
) {
  position <- match.arg(position)
  stopifnot(is.logical(case_sensitive), is.logical(show_icon), is.logical(auto_search))

  opts <- jsonlite::toJSON(
    list(
      position = position,
      caseSensitive = case_sensitive,
      showIcon = show_icon,
      autoSearch = auto_search
    ),
    auto_unbox = TRUE,
    pretty = FALSE
  )

  sprintf(
    "<script>window.addEventListener('load', function() { window.xeSearch = new RemarkSearch(%s) })</script>",
    opts
  )
}

html_dependency_markjs <- function() {
  htmltools::htmlDependency(
    name = "mark.js",
    version = "8.11.1",
    package = "xaringanExtra",
    src = "jslib/markjs",
    script = "mark.min.js",
    all_files = FALSE
  )
}
