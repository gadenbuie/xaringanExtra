#' Editable
#'
#' Editable gives you a way to write directly inside your slides. Make any
#' element of your slides editable by using the `.can-edit[...]` class. Editable
#' fields are reset when the slides are reloaded, but it is possible for edits
#' to persist across sessions (in the same browser) by giving the editable
#' element a `.key-<NAME>` class, where `<NAME>` is a unique identifier (and
#' valid CSS class).
#'
#' @examples
#' use_editable()
#'
#' @return An `htmltools::tagList()` with the editable dependencies, or an
#'   [htmltools::htmlDependency].
#' @section Usage: To make your xaringan presentations _editable_, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-editable, echo=FALSE}
#'   # Setup editable fields and only store values in the browser for one day
#'   # (by default values expire in 2 weeks).
#'   xaringanExtra::use_editable(expires = 1)
#'   ```
#'   ````
#'
#'   Then, to make a component of your slides editable, use the `.can-edit[]`
#'   class.
#'
#'   ```markdown
#'   ## .can-edit[You can edit this slide title]
#'   ```
#'
#'   Editable fields that only have the `.can-edit` class are reset whenever the
#'   slides are re-loaded in your browser. If you want to store the edited
#'   values and have them persist across browser sessions, give each editable
#'   field a `.key-<NAME>` class. Be sure to make each key unique and note that
#'   the key name must be a valid CSS class, i.e. it cannot contain spaces.
#'
#'   ```markdown
#'   ## .can-edit.key-firstSlideTitle[Change this title and then reload the page]
#'   ```
#'
#'   **Warning** Editable fields may not work well with slide continuations. If
#'   your full slide builds up over several slides, you can only edit the
#'   currently visible slide. If the field has a key, however, all editable
#'   elements with the same key class are updated when the slides are loaded.
#'   In other words, you can edit the title on the first slide of a multi-part
#'   slide and reload the page to have the title applied to subsequent slides.
#'
#' @name editable
NULL

#' @describeIn editable Adds editable to your xaringan slides.
#' @param id Optional. By default, when `id` is `NULL`, each re-generation of
#'   your slides creates a new document ID. This way, values that were
#'   previously stored in the browser for an older version of your slides will
#'   not be loaded into a new version. If you are confident that the editable
#'   fields in your slides are not changing between versions, you can set the
#'   document ID so that newer versions of your slides will continue to load
#'   edited values from previous versions in the browser.
#' @param expires Editable values that also have a `.key-KEYNAME` class are
#'   stored in the browser and automatically loaded when the slides are
#'   reloaded. These values are stored using cookies so that they can eventually
#'   expire and `expires` provides the number of days that those values should
#'   be stored before being released.
#' @export
use_editable <- function(id = NULL, expires = 14) {
  htmltools::tagList(
    html_dependency_editable(expires = expires, id = id)
  )
}

#' @describeIn editable Returns an [htmltools::htmlDependency] with the tile
#'   view dependencies. Most users will want to use `use_editable()`.
#' @export
html_dependency_editable <- function(expires = 14, id = NULL) {
  htmltools::tagList(
    html_dependency_editable_id(expires = expires, id = id),
    htmltools::htmlDependency(
      name = "himalaya",
      version = "1.1.0",
      package = "xaringanExtra",
      src = "jslib/himalaya",
      script = "himalaya.js",
      all_files = TRUE
    ),
    html_dependency_jscookie(),
    htmltools::htmlDependency(
      name = "editable",
      version = "0.2.6",
      package = "xaringanExtra",
      src = "editable",
      script = "editable.js",
      stylesheet = "editable.css",
      all_files = FALSE
    )
  )
}

html_dependency_jscookie <- function() {
  htmltools::htmlDependency(
    name = "js-cookie",
    version = "3.0.0",
    package = "xaringanExtra",
    src = "jslib/js-cookie",
    script = "js.cookie.js",
    all_files = FALSE
  )
}

# Insert JSON in the document head containing editable options, in particular
# the document id and expiration time for cookies.
html_dependency_editable_id <- function(expires = NULL, id = NULL) {
  id <- id %||% uuid()
  expires <- if (is.null(expires)) {
    "null"
  } else {
    if (is.numeric(expires)) {
      expires <- format(expires)
    } else {
      stop(
        "`expires` must be a numeric number of days for retention of stored values",
        call. = FALSE
      )
    }
  }
  htmltools::htmlDependency(
    name = "xaringanExtra-editable-id",
    version = "0.2.6",
    src = ".",
    head = format(htmltools::tags$script(
      type = "application/json",
      id = "xaringanExtra-editable-docid",
      sprintf('{"id":"%s","expires":%s}', id, expires)
    )),
    all_files = FALSE
  )
}

uuid <- function() {
  # Create a unique id for this document, ensure that it's a valid HTML ID
  x <- uuid::UUIDgenerate()
  if (!substr(x, 1, 1) %in% letters) substr(x, 1, 1) <- "x"
  gsub("-", "", x)
}
