# <div class="shareagain">
# 	<iframe src="xaringan-shareagain.html" width="1600" height="900"  loading="lazy" allowfullscreen></iframe>
# </div>

#' @export
use_share_again <- function() {
	htmltools::tagList(
		html_dependency_clipboardjs(),
		html_dependency_shareon(),
		html_dependency_shareagain()
	)
}

#' @export
embed_xaringan <- function(
  url,
  ratio = "16:9",
  border = "2px solid currentColor",
  max_width = NULL,
  margin = "1em auto",
  style = NULL
) {
  ratio <- parse_ratio(ratio)
  style <- paste(style, collapse = ";")
  style <- sprintf("border:%s;%s", border, style)

  parent_style <- sprintf("min-width:300px;margin:%s;", margin)
  if (!is.null(max_width)) {
    parent_style <- sprintf(
      "%smax-width:%s;",
      parent_style,
      htmltools::validateCssUnit(max_width)
    )
  }

  htmltools::tagList(
    htmltools::div(
      class = "shareagain",
      style = parent_style,
      htmltools::tags$iframe(
        src = url,
        width = ratio["width"],
        height = ratio["height"],
        style = style,
        loading = "lazy",
        allowfullscreen = NA
      ),
      htmltools::tags$script(htmltools::HTML("fitvids('.shareagain', {players: 'iframe'});")),
      html_dependency_fitvids()
    )
  )
}

parse_ratio <- function(x) {
  x <- strsplit(as.character(x), ":")[[1]]
  x <- suppressWarnings(as.numeric(x))
  x <- x[!is.na(x)]
  if (!length(x) %in% 1:2) {
    stop("ratio must be \"w:h\" or a single number representing w/h")
  }
  if (length(x) == 1) {
    c(width = x, height = 1) * 300
  } else {
    c(width = x[1], height = x[2]) * 100
  }
}

html_dependency_shareagain <- function() {
	htmltools::htmlDependency(
	  name = "shareagain",
	  version = packageVersion("xaringanExtra"),
	  package = "xaringanExtra",
	  src = "share-again",
	  script = "shareagain.js",
	  stylesheet = "shareagain.css",
	  all_files = FALSE
	)
}

html_dependency_fitvids <- function() {
  htmltools::htmlDependency(
    name = "fitvids",
    version = "2.1.1",
    package = "xaringanExtra",
    src = "jslib/fitvids",
    script = "fitvids.min.js",
    all_files = FALSE
  )
}

html_dependency_shareon <- function() {
	htmltools::htmlDependency(
	  name = "shareon",
	  version = "1.4.1",
	  package = "xaringanExtra",
	  src = c(
	  	file = "jslib/shareon",
	  	href = "https://cdn.jsdelivr.net/npm/shareon@1/dist/"
	  ),
	  script = "shareon.min.js",
	  stylesheet = "shareon.min.css",
	  all_files = FALSE
	)
}
