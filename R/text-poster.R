#' Text Poster
#'
#' Text poster typesets text to fit within a rectangular bounding box, with the
#' text on each line scaled to fit the horizontal space.
#'
#' @return The `text_poster()` function returns HTML with the following
#'   structure:
#'
#'   ```html
#'   <div class="text-poster" style="width:100%;height:100%;padding:1em;">
#'     <div class="text-poster__text" data-text="first line\\nsecond line"></div>
#'   </div>
#'   ```
#'
#'   If specified, additional classes are added to the `.text-poster` `div`.
#'   Additional inline styles can be applied using named arguments to
#'   `text_poster()`, and the pre-set styles can be disabled by setting them
#'   equal to `NULL`. Note that the `div.text-poster` must have a width and
#'   height.
#'
#'   Once rendered, the final output will have the following structure:
#'
#'   ```html
#'   <div class="text-poster" style="width:100%;height:100%;padding:1em;">
#'     <div class="text-poster__text" data-text="first line\\nsecond line">
#'       <div class="line-container">
#'         <div class="line">first line</div>
#'         <div class="line">second line</div>
#'       </div>
#'     </div>
#'   </div>
#'   ```
#'
#' @section Usage: To add text-poster to your xaringan presentation, use
#'   `text_poster()` to create a block of poster text. Include line breaks in
#'   the text string to split the text block.
#'
#'   ```{r poster-text, echo=FALSE}
#'   xaringanExtra::text_poster(
#'     "There are no
#'     routine statistical
#'     questions, only questionable
#'     statistical routines."
#'   )
#'   ```
#'   ````
#'
#' @references [text-poster](https://github.com/IMAGINARY/text-poster#readme)
#' @name text_poster
NULL

#' @describeIn text_poster Create poster text in your xaringan slides.
#' @param text The text to include in the poster text block. Include line breaks
#'   to force new lines in the block.
#' @param width,height,padding The width, height, and padding of the poster text
#'    container `<div>`. Set to `NULL` to leave unset, but be sure to use global
#'    CSS rules to set the width and height of the `.text-poster` container.
#' @param class Additional classes added to the poster text container `<div>`.
#' @param ... Additional named arguments added to the poster text container
#'   `<div>` as inline styles, e.g. `margin = "0 auto"`.
#' @export
text_poster <- function(
  text,
  width = "100%",
  height = "100%",
  padding = "1em",
  class = NULL,
  ...
) {
  css_unit <- function(key, value = NULL, validate = TRUE) {
    if (is.null(value)) {
      return("")
    }
    validate <- if (validate) htmltools::validateCssUnit else paste0
    sprintf("%s:%s;", key, validate(value))
  }

  extra_styles <- list(...)
  if (length(extra_styles)) {
    extra_styles <- vapply(
      names(extra_styles),
      function(key) css_unit(key, extra_styles[[key]], FALSE),
      character(1),
      USE.NAMES = FALSE
    )
    extra_styles <- paste(extra_styles, collapse = "")
  }

  htmltools::div(
    class = paste(c("text-poster", class), collapse = " "),
    style = paste0(
      css_unit("width", width),
      css_unit("height", height),
      css_unit("padding", padding, FALSE),
      if (length(extra_styles)) extra_styles
    ),
    htmltools::div(
      class = "text-poster__text",
      `data-text` = text
    ),
    use_text_poster()
  )
}

#' @describeIn text_poster Prepares your xaringan slides to use `text-poster`.
#'   If you use `text_poster()` to create your poster-block text, you do not
#'   need to call this function.
#' @export
use_text_poster <- function() {
  htmltools::tagList(
    html_dependency_text_poster()
  )
}

#' @describeIn text_poster Returns an [htmltools::htmlDependency()] with the
#'   `text-poster` dependencies. Most users will want to use `use_text_poster()`.
#' @export
html_dependency_text_poster <- function() {
  htmltools::htmlDependency(
    name = "text-poster",
    version = "1.0.1",
    package = "xaringanExtra",
    src = "text-poster",
    script = c("text-poster.js", "text-poster-init.js"),
    stylesheet = "text-poster.css"
  )
}
