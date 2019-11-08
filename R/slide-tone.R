#' Slide Tone
#'
#' Slide tone plays a subtle sound when you change slides.The tones increase in
#' pitch for each slide from a low C to a high C note. The tone pitch stays the
#' same for incremental slides.
#'
#' @return An [htmltools::tagList] with the slide tone dependencies, or an
#'   [htmltools::htmlDependency].
#' @section Usage: To add slide tone to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-slide-tone, echo=FALSE}
#'   xaringanExtra::xaringan_slide_tone()
#'   ```
#'   ````
#'
#' @references [tone.js](https://tonejs.github.io/)
#' @name slide_tone
NULL

#' @describeIn slide_tone Adds slide tone to your xaringan slides.
#' @export
xaringan_slide_tone <- function() {
	htmltools::tagList(
		xaringan_slide_tone_dependency()
	)
}

#' @describeIn slide_tone Returns an [htmltools::htmlDependency] with the tile
#'   view dependencies. Most users will want to use `xaringan_slide_tone()`.
#' @export
xaringan_slide_tone_dependency <- function() {
	htmltools::htmlDependency(
		name = "slide-tone",
		version = utils::packageVersion("xaringanExtra"),
		package = "xaringanExtra",
		src = "slide-tone",
		script = c("tone.js", "slide-tone.js")
	)
}
