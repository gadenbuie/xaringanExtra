#' Clipboard
#'
#' Add a "Copy Code" button for one-click code chunk copying.
#'
#' @includeRmd man/fragments/clipboard-details.Rmd details
#'
#' @examples
#' use_clipboard()
#'
#' @rdname clipboard
#' @name clipboard
NULL

#' @describeIn clipboard Adds **clipboard** to your xaringan slides or R
#'   Markdown HTML output.
#' @param button_text,success_text,error_text Text (or HTML) shown in the copy
#'   button by default (_button_), on copy _success_, or in the event of an
#'   _error_.
#' @param selector The CSS selector used to identify the elements that will
#'   receive the copy code button. If `NULL`, the extension will automatically
#'   choose the selector for \pkg{xaringan} slides or general R Markdown.
#'
#'   The CSS selector should identify the parent container that holds the
#'   content to be copied. The copy button will be added as the last element
#'   in this container, and then the text of every element inside the container
#'   identified by the selector, minus the copy button text, is copied to the
#'   clipboard.
#' @param minified Should the minified clipboardjs dependency be used?
#'
#' @return An `htmltools::tagList()` with the HTML dependencies required for
#'   **clipboard**.
#'
#' @export
use_clipboard <- function(
  button_text = "Copy Code",
  success_text = "Copied!",
  error_text = "Press Ctrl+C to Copy",
  selector = NULL,
  minified = TRUE
) {
  opts <- list(button = button_text, success = success_text, error = error_text)
  selector <- if (!is.null(selector)) sprintf("'%s'", selector) else "null"

  htmltools::tagList(
    html_dependency_clipboardjs(minified),
    html_dependency_clipboard(),
    htmltools::htmlDependency(
      name = uuid::UUIDgenerate(), # random name ensures each call ends up in <head>
      version = "9.9.9",
      package = "xaringanExtra",
      src = "",
      head = sprintf(
        "<script>window.xaringanExtraClipboard(%s, %s)</script>",
        selector,
        jsonlite::toJSON(opts, auto_unbox = TRUE)
      ),
      all_files = FALSE
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
    version = "0.2.6",
    package = "xaringanExtra",
    src = "clipboard",
    script = "xaringanExtra-clipboard.js",
    stylesheet = "xaringanExtra-clipboard.css",
    all_files = FALSE
  )
}
