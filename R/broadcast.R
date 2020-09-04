#' @export
use_broadcast <- function() {
	htmltools::tagList(
		html_dependency_jscookie(),
		html_dependency_peerjs(),
		html_dependency_broadcast()
	)
}

html_dependency_broadcast <- function() {
	htmltools::htmlDependency(
	  name = "xaringanExtra-broadcast",
	  version = utils::packageVersion("xaringanExtra"),
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
