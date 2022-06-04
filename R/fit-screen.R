#' Fit Slides to the Screen
#'
#' This extension resizes the slides to match the browser window height and
#' width. In other words, the slides are maximized to match the screen size.
#' The primary use case for this extension is for when you want to show your
#' slides in split screen, for example when demonstrating code in RStudio or
#' another window. To enable fit-to-screen, press **Alt**/**Option** + **F** during the
#' slideshow. To disable, reload the slides.
#'
#' @examples
#' use_fit_screen()
#'
#' @return An`htmltools::tagList()` with the fit-to-screen dependency, or an
#'   [htmltools::htmlDependency()].
#'
#' @section Usage: To enable fit-to-screen, add the following code chunk to your
#'   slides:
#'
#'   ````markdown
#'   ```{r xaringan-fit-screen, echo=FALSE}
#'   xaringanExtra::use_fit_screen()
#'   ```
#'   ````
#'
#'   And then press **Alt**/**Option** + **F** at any point during your slide show to
#'   enable the extension.
#' @name fit_screen
NULL

#' @describeIn fit_screen Use the fit-to-screen extension in your xaringan slides.
#' @export
use_fit_screen <- function() {
  htmltools::tagList(
    html_dependency_fit_screen()
  )
}

#' @describeIn fit_screen Returns an [htmltools::htmlDependency()] with the fit
#'   screen dependencies. Most users will want to use `use_fit_screen()`.
#' @export
html_dependency_fit_screen <- function() {
  htmltools::htmlDependency(
    name = "xaringanExtra_fit-screen",
    version = "0.2.6",
    package = "xaringanExtra",
    src = "fit-screen",
    script = "fit-screen.js",
    all_files = FALSE
  )
}
