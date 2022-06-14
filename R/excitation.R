#' Excitation
#'
#' @description Excitation lets you add visual citations as tooltips to your
#'   \pkg{xaringan} slides. Simply include a `.bib` file in your R Markdown
#'   YAML header, as usual, and cite away!
#'
#' @section Usage: To use excitation for visual citations, add the following
#'   code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-excitation, echo=FALSE}
#'   xaringanExtra::use_excitation()
#'   ```
#'   ````
#'
#' @examples
#' use_excitation()
#'
#' @name excitation
NULL

#' @describeIn excitation Adds visual citations to your xaringan slides.
#' @export
use_excitation <- function() {
  assign('.excitation_keys', vector('character'), envir = globalenv())
  htmltools::tagList(
    html_dependency_popper(),
    html_dependency_tippy(),
    html_dependency_excitation()
  )
}

#' @describeIn excitation Adds visual citations to your xaringan slides.
#' @export
excite <- function(key) {
  bibs <- rmarkdown::metadata$bibliography
  self_contained <- FALSE

  if (is.null(bibs)) return(key)

  if (length(bibs) > 1) {
    tmp_bib <- tempfile(fileext = '.bib')
    for (i in seq_len(bibs)) {
      write(readLines(bibs[[i]]), tmp_bib, append = TRUE)
    }
    bibs <- tmp_bib
  }

  .excitation_keys <- get('.excitation_keys', envir = globalenv())

  script <- NULL

  if (!key %in% .excitation_keys) {
    tooltip <- htmltools::includeHTML(
      namedropR::drop_name(
        bibs,
        output_dir = tempdir(),
        cite_key = key,
        export_as = "html",
        use_xaringan = TRUE,
        include_qr = if (self_contained) 'embed' else 'link',
        qr_hyperlink = TRUE,
        qr_size = 150,
        style = 'classic',
        path_absolute = TRUE
      )
    )
    tooltip <- htmltools::HTML(as.character(tooltip))
    tooltip_json <- jsonlite::toJSON(tooltip, auto_unbox = TRUE)
    .excitation_keys <- c(.excitation_keys, key)
    assign('.excitation_keys', .excitation_keys, envir = globalenv())
    script <- htmltools::tags$script(
      tooltip_json,
      type = 'application/json',
      class = 'xe-excitation__data',
      `data-excitation-key` = key
    )
  }

  num_id <- which(.excitation_keys == key)

  htmltools::tagList(
    htmltools::tags$span(
      key,
      class = 'xe-excitation__tooltip',
      `data-excitation-key` = key,
      `data-excitation-id` = num_id
    ),
    script
  )
}

#' @describeIn excitation Returns an [htmltools::htmlDependency()] with the
#'   `excitation.js` dependencies for use in xaringan and R Markdown
#'   documents. Most users will want to use `use_excitation()` instead.
#'
#' @export
html_dependency_excitation <- function() {
  htmltools::htmlDependency(
    name = "excitation",
    version = "0.0.1",
    package = "xaringanExtra",
    src = "excitation",
    script = "excitation.js",
    stylesheet = "excitation.css",
    all_files = FALSE
  )
}

#' @describeIn excitation Returns an [htmltools::htmlDependency()] with the
#'   `popper.js` dependencies for use in xaringan and R Markdown
#'   documents. Most users will want to use `use_excitation()` instead.
#'
#' @export
html_dependency_popper <- function() {
  htmltools::htmlDependency(
    name = "popper",
    version = "2.11.5",
    package = "xaringanExtra",
    src = c(
      file = 'jslib/popper',
      href = 'https://unpkg.com/@popperjs/core@2.11.5/dist/umd/popper.min.js'
    ),
    script = 'popper.js',
    all_files = FALSE
  )
}

#' @describeIn excitation Returns an [htmltools::htmlDependency()] with the
#'   `tippy.js` dependencies for use in xaringan and R Markdown
#'   documents. Most users will want to use `use_excitation()` instead.
#'
#' @export
html_dependency_tippy <- function() {
  htmltools::htmlDependency(
    name = "tippy",
    version = "6.3.7",
    package = "xaringanExtra",
    src = c(
      file = 'jslib/tippy',
      href = 'https://unpkg.com/tippy.js@6.3.7/dist/tippy-bundle.umd.js'
    ),
    script = 'tippy.js',
    all_files = FALSE
  )
}
