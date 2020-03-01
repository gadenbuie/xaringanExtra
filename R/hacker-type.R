#' @title Hacker Typing
#' @description FIXME
#' @export
use_hacker_type <- function() {
	html_dependency_hacker_type()
}

#' @describeIn use_hacker_type Returns an [htmltools::htmlDependency] with the
#'   hacker tpying dependencies. Most users will want to use
#'   `use_hacker_type()`.
#' @export
html_dependency_hacker_type <- function() {
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "typer-js",
      version = "1.0.2",
      package = "xaringanExtra",
      src = "libs/typer-js",
      script = "typer.min.js",
      stylesheet = "typer.css",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = "hacker-type",
      version = packageVersion("xaringanExtra"),
      package = "xaringanExtra",
      src = "hacker-type",
      script = "hacker-type.js",
      all_files = FALSE
    )
  )
}
