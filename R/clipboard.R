#' Clipboard
#'
#' Add a "Copy Code" button for one-click code chunk copying.
#'
#' @includeRmd man/fragments/clipboard-details.Rmd details
#'
#' @rdname clipboard
#' @name clipboard
NULL

#' @describeIn clipboard Adds **clipboard** to your xaringan slides or R
#'   Markdown HTML output.
#' @param button_text,success_text,error_text Text (or HTML) shown in the copy
#'   button by default (_button_), on copy _success_, or in the event of an
#'   _error_.
#' @param minified Should the minified clipboardjs dependency be used?
#' @export
use_clipboard <- function(
  button_text = "Copy Code",
  success_text = "Copied!",
  error_text = "Press Ctrl+C to Copy",
  minified = TRUE
) {
  htmltools::tagList(
    html_dependency_clipboardjs(minified),
    html_dependency_clipboard(),
    htmltools::tags$script(
      type = "application/json",
      id = "xaringanextra-clipboard-options",
      jsonlite::toJSON(
        list(button = button_text, success = success_text, error = error_text),
        auto_unbox = TRUE
      )
    )
  )
}

#' @describeIn clipboard Returns an [htmltools::htmlDependency()] with the
#'   [clipboard.js](https://clipboardjs.com/) library. For expert use.
#' @references https://clipboardjs.com/
#' @export
html_dependency_clipboardjs <- function(minified = TRUE) {
  v_clipboard <- "2.0.6"
  htmltools::htmlDependency(
    name = "clipboard",
    version = v_clipboard,
    package = "xaringanExtra",
    src = c(
      file = "jslib/clipboard",
      href = "https://unpkg.com/clipboard@2/dist/"
    ),
    script = paste0("clipboard", if (minified) ".min", ".js"),
    all_files = FALSE
  )
}

#' @describeIn clipboard Returns an [htmltools::htmlDependency()] with the
#'   clipboard dependencies for use in xaringan and R Markdown documents. Most
#'   users will want to use `use_clipboard()` instead.
#' @export
html_dependency_clipboard <- function() {
  htmltools::htmlDependency(
    name = "xaringanExtra-clipboard",
    version = utils::packageVersion("xaringanExtra"),
    package = "xaringanExtra",
    src = "clipboard",
    script = "xaringanExtra-clipboard.js",
    stylesheet = "xaringanExtra-clipboard.css",
    all_files = FALSE
  )
}
