use_freezeframe <- function() {
  htmltools::tagList(
    html_dependency_freezeframe()
  )
}

html_dependency_freezeframe <- function() {
  htmltools::htmlDependency(
    name = "freezeframe",
    version = "5.0.2",
    package = "xaringanExtra",
    src = "jslib/freezeframe",
    script = "freezeframe.min.js",
    head = paste0(
      "<script>document.addEventListener('DOMContentLoaded', function() {
        window.xeFreezeframe = new Freezeframe('.remark-slides-area img[src$=\"gif\"]')
      })</script>"
    ),
    all_files = FALSE
  )
}
