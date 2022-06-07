#' Add an animated progress bar
#'
#' Adds an animated progress bar to all slides.
#'
#' @param color A valid CSS color to be used as the color of the progress bar.
#' @param location One of `"top"` or `"bottom"`.
#' @param height A valid CSS unit specifying the height of the progress bar.
#'
#' @return An `htmltools::tagList()` with the HTML dependencies required for
#'   **progress bar**.
#'
#' @examples
#' xaringanExtra::use_progress_bar("red", "top", "0.25em")
#'
#' @export
use_progress_bar <- function(
  color = "red",
  location = c("top", "bottom"),
  height = "0.25em"
) {
  location <- match.arg(location)
  height <- htmltools::validateCssUnit(height)

  htmltools::tagList(
    htmltools::tags$style(htmltools::HTML(progress_bar_css(color, location, height))),
    htmltools::htmlDependency(
      name = "xaringanExtra-progressBar",
      version = "0.0.1",
      package = "xaringanExtra",
      src = "progress-bar",
      script = "progress-bar.js",
      all_files = FALSE
    )
  )
}

progress_bar_css <- function(color = "red", location = "top", height = "10px") {
  css <- '.xe__progress-bar__container {
  %s:0;
  opacity: 1;
  position:absolute;
  right:0;
  left: 0;
}
.xe__progress-bar {
  height: %s;
  background-color: %s;
  width: calc(var(--slide-current) / var(--slide-total) * 100%%);
}
.remark-visible .xe__progress-bar {
  animation: xe__progress-bar__wipe 200ms forwards;
  animation-timing-function: cubic-bezier(.86,0,.07,1);
}
@keyframes xe__progress-bar__wipe {
  0%% { width: calc(var(--slide-previous) / var(--slide-total) * 100%%); }
  100%% { width: calc(var(--slide-current) / var(--slide-total) * 100%%); }
}'

  sprintf(css, location, height, color)
}
