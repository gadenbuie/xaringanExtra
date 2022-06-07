#' Broadcast Your Slides
#'
#' [Experimental](https://lifecycle.r-lib.org/articles/stages.html)!
#' **Broadcast** lets others follow along, in real time! Built with
#' [PeerJS](https://peerjs.com), **broadcast** give you a unique URL to share
#' with your viewers. Then, when they load your slides, their slides will
#' automatically follow you as you present!
#'
#' @includeRmd man/fragments/broadcast-details.Rmd
#'
#' @examples
#' use_broadcast()
#'
#' @return An `htmltools::tagList()` with the HTML dependencies required for
#'   **broadcast**.
#'
#' @references <https://peerjs.com>
#' @export
use_broadcast <- function() {
  htmltools::tagList(
    html_dependency_jscookie(),
    html_dependency_peerjs(),
    html_dependency_tinytoast(),
    html_dependency_broadcast()
  )
}

html_dependency_broadcast <- function() {
  htmltools::htmlDependency(
    name = "xaringanExtra-broadcast",
    version = "0.2.6",
    package = "xaringanExtra",
    src = "broadcast",
    script = "broadcast.js",
    stylesheet = "broadcast.css",
    all_files = FALSE
  )
}

html_dependency_peerjs <- function() {
  htmltools::htmlDependency(
    name = "peerjs",
    version = "1.3.1",
    package = "xaringanExtra",
    src = c(
      file = "jslib/peerjs",
      href = "https://unpkg.com/peerjs@1.3.1/dist/"
    ),
    script = "peerjs.min.js",
    all_files = TRUE
  )
}

html_dependency_tinytoast <- function() {
  htmltools::htmlDependency(
    name = "tiny.toast",
    version = "1.0.0",
    package = "xaringanExtra",
    src = c(
      file = "jslib/tiny.toast",
      href = "https://www.kirilv.com/tiny.cdn/lib/toast/1.0.0"
    ),
    script = "toast.min.js",
    all_files = TRUE
  )
}
