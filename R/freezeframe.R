#' FreezeFrame
#'
#' @description
#' FreezeFrame starts any gifs on a slide when you turn to that slide. This
#' helps This helps alleviate the awkward pause that can happen when you turn to
#' a slide with a gif that has already started and you have to wait until it
#' loops back around. You can also directly click on the gif to stop or start
#' it.
#'
#' @section Usage: To add FreezeFrame to your `xaringan` presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringanExtra-freezeframe, echo=FALSE}
#'   xaringanExtra::use_freezeframe()
#'   ```
#'   ````
#' @examples
#' use_freezeframe()
#'
#' @param selector The selector used to search for `.gifs` to freeze.
#' @param trigger The trigger event to start animation for non-touch devices.
#'   One of `"click"` (default), `"hover"` or `"none"`.
#' @param overlay Whether or not to display a play icon on top of the paused
#'   image, default: `FALSE`.
#' @param responsive Whether or not to make the image responsive (100% width),
#'   default: `TRUE`.
#' @param warnings Whether or not to issue warnings in the browser console if
#'   an image doesn't appear to be a gif.
#'
#' @return An `htmltools::tagList()` with the FreezeFrame dependencies, or an
#'   [htmltools::htmlDependency()].
#'
#' @references <http://ctrl-freaks.github.io/freezeframe.js/>,
#'   <https://github.com/ctrl-freaks/freezeframe.js/>
#' @name freezeframe
NULL

#' @describeIn freezeframe Adds FreezeFrame to your xaringan slides.
#' @export
use_freezeframe <- function(
  selector = 'img[src$="gif"]',
  trigger = c("click", "hover", "none"),
  overlay = FALSE,
  responsive = TRUE,
  warnings = TRUE
) {
  htmltools::tagList(
    html_dependency_freezeframe(),
    html_dependency_freezeframe_init(selector, trigger, overlay, responsive, warnings)
  )
}

#' @describeIn freezeframe Returns an [htmltools::htmlDependency()] with the
#'   FreezeFrame dependencies for use in xaringan and R Markdown documents.
#'   Most users will want to use `use_freezeframe()` instead.
#'
#' @export
html_dependency_freezeframe <- function() {
  htmltools::htmlDependency(
    name = "freezeframe",
    version = "5.0.2",
    package = "xaringanExtra",
    src = "jslib/freezeframe",
    script = "freezeframe.min.js",
    all_files = FALSE
  )
}

html_dependency_freezeframe_init <- function(
  selector = 'img[src$="gif"]',
  trigger = c("click", "hover", "none"),
  overlay = FALSE,
  responsive = TRUE,
  warnings = TRUE
) {
  htmltools::htmlDependency(
    name = "xaringanExtra-freezeframe",
    version = "0.0.1",
    package = "xaringanExtra",
    src = "freezeframe",
    script = "freezeframe-init.js",
    head = freezeframe_options(selector, trigger, overlay, responsive, warnings),
    all_files = FALSE
  )
}

freezeframe_options <- function(
  selector = 'img[src$="gif"]',
  trigger = c("click", "hover", "none"),
  overlay = FALSE,
  responsive = TRUE,
  warnings = TRUE
) {
  trigger <- match.arg(trigger)
  if (identical(trigger, "none")) trigger <- FALSE
  stopifnot(
    "selector must be a character" = is.character(selector),
    "selector must be non-missing" = length(selector) > 0 && !is.na(selector),
    "overlay must be boolean" = is.logical(overlay),
    "responsive must be boolean" = is.logical(responsive),
    "warnings must be boolean" = is.logical(warnings)
  )
  opts <- jsonlite::toJSON(
    list(
      selector = paste(selector, collapse = ", "),
      trigger = trigger,
      overlay = overlay,
      responsive = responsive,
      warnings = warnings
    ),
    auto_unbox = TRUE
  )
  script <- htmltools::tags$script(
    id = "xaringanExtra-freezeframe-options",
    type = "application/json",
    htmltools::HTML(opts)
  )
  format(script)
}
