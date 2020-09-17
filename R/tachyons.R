#' Tachyons
#'
#' Tachyons is a collection of CSS utility classes that works beautifully with
#' \pkg{xaringan} presentations using the `remarkjs`` class syntax.
#'
#' @return An `htmltools::tagList()` with the tachyons dependencies, or an
#'   [htmltools::htmlDependency()].
#' @section Usage: To add tachyons to your xaringan presentation, add the
#'   following code chunk to your slides' R Markdown file.
#'
#'   ````markdown
#'   ```{r xaringan-tachyons, echo=FALSE}
#'   xaringanExtra::use_tachyons()
#'   ```
#'   ````
#'
#'  Tachyons provides small, single-purpose CSS classes that are easily composed
#'  to achieve larger functionality and styles. In the [remarkjs content classes
#'  syntax](https://github.com/gnab/remark/wiki/Markdown#content-classes), you
#'  can compose classes by chaining them together. For example, the following
#'  markdown produces a box with a washed green background (`.bg-washed-green`),
#'  a dark green border (`.b--dark-green`) on all sides (`.ba`) with line width
#'  2 (`.bw2`) and border radius (`.br3`). The box has a shadow (`.shadow-5`)
#'  and medium-large horizontal padding (`.ph4`) with a large top margin
#'  (`.mt5`).
#'
#'  ```markdown
#'  .bg-washed-green.b--dark-green.ba.bw2.br3.shadow-5.ph4.mt5[
#'  The only way to write good code is to write tons of bad code first.
#'  Feeling shame about bad code stops you from getting to good code
#'
#'  .tr[
#'  — Hadley Wickham
#'  ]]
#'  ```
#'
#' @references [tachyons](http://tachyons.io/),
#'   [Tachyons Cheat Sheet](https://roperzh.github.io/tachyons-cheatsheet/)
#' @seealso style_tachyons
#' @name tachyons
NULL

#' @describeIn tachyons Adds tachyons to your xaringan slides.
#' @param minified Use the minified Tachyons css file? Default is `TRUE`.
#' @export
use_tachyons <- function(minified = TRUE) {
  htmltools::tagList(
    html_dependency_tachyons(minified)
  )
}

#' @describeIn tachyons Returns an [htmltools::htmlDependency()] with the tile
#'   view dependencies. Most users will want to use `use_tachyons()`.
#' @export
html_dependency_tachyons <- function(minified = TRUE) {
  tachyons_version <- "4.12.0"
  htmltools::htmlDependency(
    name = "tachyons",
    version = tachyons_version,
    package = "xaringanExtra",
    src = "jslib/tachyons",
    stylesheet = paste0("tachyons", if (minified) ".min", ".css"),
    all_files = FALSE
  )
}


list_tachyons_vars <- function() {
  tc <- system.file("jslib/tachyons/tachyons.css", package = "xaringanExtra")
  tc <- readLines(tc)
  tc <- gsub(";", "&;", tc)
  tc <- unlist(strsplit(tc, ";"))
  m <- regexec("--([[:graph:]]+): ([^;]+)&$", tc)
  m <- regmatches(tc, m)
  m <- m[vapply(m, length, integer(1)) > 0]
  m <- do.call(rbind, m)[,2:3]
  vars <- as.list(m[, 2])
  names(vars) <- m[, 1]
  vars
}

args_tachyons_vars <- function() {
  vars <- lapply(list_tachyons_vars(), function(...) NULL)
  names(vars) <- gsub("-", "_", names(vars))
  vars
}

params_tachyons_vars <- function() {
  vars <- unlist(list_tachyons_vars())
  paste0(
    "\\item{",
    gsub("-", "_", names(vars)),
    "}{\\code{--",
    names(vars),
    "}, default is \\code{",
    vars,
    "}}",
    collapse = "\n"
  )
}

#' Style Tachyons
#'
#' Creates a `<style>` tag to set CSS variables used by Tachyons.
#'
#' @evalRd paste("\\arguments{", params_tachyons_vars(), "}", collapse = "\n")
#'
#' @seealso tachyons
#' @export
style_tachyons <- function() {
  vars <- as.list(match.call())[-1]
  if (!length(vars)) {
    return()
  }

  css <- vector("character", length(vars))
  for (i in seq_along(vars)) {
    css_var <- gsub("_", "-", names(vars[i]))
    css[i] <- sprintf("--%s: %s;", css_var, vars[i])
  }
  htmltools::tags$style(
    sprintf(":root { %s }", paste(css, collapse = " "))
  )
}

formals(style_tachyons) <- args_tachyons_vars()
