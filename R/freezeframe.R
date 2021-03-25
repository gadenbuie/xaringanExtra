#' FreezeFrame
#'
#' @description
#' FreezeFrame starts your gifs when you turn to a slide. This helps alleviate
#' the awkward pause that can happen when you turn to a slide with a gif that
#' has already started and you have to wait until it looks back around. You can
#' also directly click on the gif to stop or start it.
#'
#' @section Usage: To add FreezeFrame to your `xaringan` presentation,
#'   add the following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringanExtra-freezeframe, echo=FALSE}
#'   xaringanExtra::use_freezeframe()
#'   ```
#'   ````
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
use_freezeframe <- function() {
  htmltools::tagList(
    html_dependency_freezeframe()
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
    head = paste0(
      "<script>document.addEventListener('DOMContentLoaded', function() {
        if (typeof slideshow !== 'undefined') {
          const slides = Array.from(document.querySelectorAll('.remark-slide-container'))
          // const getExitingSlideIndex = () => slides.findIndex(s => s.matches('.remark-fading'))
          const getCurrentSlideIndex = () => slides.findIndex(s => s.matches('.remark-visible'))
          window.xeFreezeframe = slides.map(function(slide) {
            return new Freezeframe(
                slide.querySelectorAll('img[src$=\"gif\"]'), {
                trigger: 'click',
                responsive: true
              })
          })
          slideshow.on('hideSlide', function() {
            const ffPrev = window.xeFreezeframe[getCurrentSlideIndex()]
            if (ffPrev) ffPrev.stop()
          })
          slideshow.on('afterShowSlide', function() {
            const ffNew = window.xeFreezeframe[getCurrentSlideIndex()]
            if (ffNew) {
              ffNew.stop()
              ffNew.start()
            }
          })
        } else {
          window.xeFreezeframe = new Freezeframe('img[src$=\"gif\"]', {
            trigger: 'click',
            responsive: true
          })
        }
      })</script>"
    ),
    all_files = FALSE
  )
}
