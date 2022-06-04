#' Add Logo
#'
#' `use_logo()` adds a logo to all of your slides. You can make the logo a
#' clickable link and choose where on the page it is placed. You can also set
#' which types of slides will not get the logo by default.
#'
#' @return An `htmltools::tagList()` with the Add Logo dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add a logo to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-logo, echo=FALSE}
#'   xaringanExtra::use_logo(
#'     image_url = "https://raw.githubusercontent.com/rstudio/hex-stickers/master/PNG/xaringan.png"
#'   )
#'   ```
#'   ````
#'
#'   See the documentation for `?use_logo` for more options regarding sizing
#'   and positioning. You can also make the logo a link using `link_url` and
#'   you can hide the logo for a particular slide by using the `hide_logo`
#'   slide class.
#'
#' @examples
#' xaringan_logo <- file.path(
#'   "https://raw.githubusercontent.com/rstudio/hex-stickers/master",
#'   "PNG/xaringan.png"
#' )
#' use_logo(xaringan_logo)
#'
#' @name logo
NULL

#' @describeIn logo Adds logo to your xaringan slides.
#' @param image_url The URL to the image file of your logo. In general, either
#'   a full URL or the path to the image relative to your slides file.
#' @param position The position of the logo from the sides of the slide. Use
#'   [css_position()] to specify.
#' @param link_url Optional. If provided, your logo becomes a clickable link.
#' @param exclude_class The slide classes that should not receive the logo. By
#'   default, the title slide, inverse slides and slides with the `hide_logo`
#'   class are excluded.
#' @param width Width in CSS units of the logo
#' @param height Height in CSS units of the logo
#' @export
use_logo <- function(
  image_url,
  width = "110px",
  height = "128px",
  position = css_position(top = "1em", right = "1em"),
  link_url = NULL,
  exclude_class = c("title-slide", "inverse", "hide_logo")
) {
	htmltools::div(
		htmltools::tags$style(
			type = "text/css",
			htmltools::HTML(
				logo_css(image_url, width, height, position)
			)
		),
		html_dependency_logo(link_url, exclude_class)
	)
}

#' Helper to set absolute position of an element.
#'
#' Sets position for an absolutely positioned element. Setting one of top or
#'   bottom or one of left or right will "unset" the other. It's probably not a
#'   good idea to set both top and bottom or right and left.
#'
#' @param top,right,bottom,left The position of the element in distance from the
#'   top, right, bottom, or left edge of it's container element.
#'
#' @return An object of class `css_position` that describes `top`, `right`,
#'   `bottom`, and `left` positions.
#'
#' @examples
#' css_position(top = "1em", right = "1em") # top right corner
#' css_position(top = "1em", left = "1em") # top left corner
#' css_position(bottom = 0, right = 0) # bottom right corner
#' @export
css_position <- function(
  top = "1em",
  right = "1em",
  left = NULL,
  bottom = NULL
) {
  p <- list()
  p$top <- if (!is.null(bottom) && missing(top)) NULL else top
  p$right <- if (!is.null(left) && missing(right)) NULL else right
  p$bottom <- if (!is.null(top) && missing(bottom)) NULL else bottom
  p$left <- if (!is.null(right) && missing(left)) NULL else left
  class(p) <- c("css_position", class(p))
  p
}

is_css_position <- function(x) {
  if (inherits(x, "css_position")) {
    return(TRUE)
  }
  x <- x[vapply(x, function(y) !is.null(y), logical(1))]
  has_vert <- length(setdiff(c("top", "bottom"), names(x))) <= 1
  has_horz <- length(setdiff(c("right", "left"), names(x))) <= 1
  has_vert && has_horz
}

#' @describeIn logo Returns an [htmltools::htmlDependency()] with the tile
#'   view dependencies. Most users will want to use `use_logo()`.
#' @param inline In [html_dependency_logo()], should the JS and CSS code to
#'   create the logo be returned inline (inside the rendered slides) or in
#'   separate CSS and JS documents attached as an html dependency? The default
#'   is to use inline for \pkg{xaringan} version 0.16 or later.
#' @export
html_dependency_logo <- function(
	link_url = NULL,
  exclude_class = c("title-slide", "inverse", "hide_logo"),
	inline = NULL
) {
	inline <- inline %||% xaringan_version("0.16")

	logo_code_js <- logo_js(link_url, exclude_class)

	ret <- if (inline) {
		htmltools::HTML(paste0("<script>", logo_code_js, "</script>"))
	} else {
		tmpdir <- tempfile("xaringanExtra-add-logo_")
		js <- file.path(tmpdir, "logo.js")
		dir.create(tmpdir)
		cat(logo_code_js, file = js)

		htmltools::htmlDependency(
			name = "xaringanExtra-logo",
			version = "0.2.6",
			src = tmpdir,
			script = "logo.js"
		)
	}

  htmltools::tagList(ret)
}

logo_css <- function(url, width, height, position) {
  if (!is_css_position(position)) {
    stop("Please use `css_position()` to specify the position of your logo", call. = FALSE)
  }
  dirs <- c("top", "right", "left", "bottom")
  names(dirs) <- dirs
  p <- lapply(dirs, function(pos) {
    if (!is.null(position[[pos]])) sprintf("%s:%s;", pos, position[[pos]]) else ""
  })
  width <- htmltools::validateCssUnit(width)
  height <- htmltools::validateCssUnit(height)
  sprintf(".xaringan-extra-logo {
width: %s;
height: %s;
z-index: 0;
background-image: url(%s);
background-size: contain;
background-repeat: no-repeat;
position: absolute;
%s%s%s%s
}
", width, height, url, p$top, p$right, p$bottom, p$left)
}

logo_js <- function(link_url, exclude_class = c("title-slide", "inverse", "hide_logo")) {
  element <- if (!is.null(link_url)) 'a' else 'div'
  link <- if (!is.null(link_url)) sprintf("'%s'", link_url) else "null"

  if (!is.null(exclude_class) && length(exclude_class)) {
    for (i in seq_along(exclude_class)) {
      if (!substr(exclude_class[i], 1, 1) == ".") {
        exclude_class[i] <- paste0(".", exclude_class[i])
      }
    }
    exclude_class <- paste(sprintf(":not(%s)", exclude_class), collapse = "")
  } else {
    exclude_class <- ""
  }

  sprintf("(function () {
  let tries = 0
  function addLogo () {
    if (typeof slideshow === 'undefined') {
      tries += 1
      if (tries < 10) {
        setTimeout(addLogo, 100)
      }
    } else {
      document.querySelectorAll('.remark-slide-content%s')
        .forEach(function (slide) {
          const logo = document.createElement('%s')
          logo.classList = 'xaringan-extra-logo'
          logo.href = %s
          slide.appendChild(logo)
        })
    }
  }
  document.addEventListener('DOMContentLoaded', addLogo)
})()",
    exclude_class, element, link)
}
