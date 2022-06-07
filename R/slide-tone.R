#' Slide Tone
#'
#' Slide tone plays a subtle sound when you change slides.The tones increase in
#' pitch for each slide from a low C to a high C note. The tone pitch stays the
#' same for incremental slides.
#'
#' @section Usage: To add slide tone to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-slide-tone, echo=FALSE}
#'   xaringanExtra::use_slide_tone()
#'   ```
#'   ````
#' @examples
#' use_slide_tone()
#'
#' @return An `htmltools::tagList()` with the slide tone dependencies, or an
#'   [htmltools::htmlDependency].
#'
#' @references [tone.js](https://tonejs.github.io/)
#' @name slide_tone
NULL

#' @describeIn slide_tone Adds slide tone to your xaringan slides.
#' @export
use_slide_tone <- function() {
  htmltools::tagList(
    html_dependency_slide_tone()
  )
}

#' @describeIn slide_tone Returns an [htmltools::htmlDependency] with the tile
#'   view dependencies. Most users will want to use `use_slide_tone()`.
#' @export
html_dependency_slide_tone <- function() {
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "tone",
      version = "13.8.34",
      package = "xaringanExtra",
      src = "jslib/tone",
      script = "Tone.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "slide-tone",
      version = "0.2.6",
      package = "xaringanExtra",
      src = "slide-tone",
      script = "slide-tone.js"
    )
  )
}
