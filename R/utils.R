
# use y if x is.null
`%||%` <- function(x, y) if (is.null(x)) y else x

xe_file <- function(...) {
  system.file(..., package = "xaringanExtra", mustWork = TRUE)
}

xaringan_version <- function(min = NULL) {
  xv <- utils::packageVersion("xaringan")
  if (is.null(min)) {
    return(xv)
  }
  xv >= package_version(min)
}

compact <- function(.l) {
  is_null <- vapply(.l, is.null, logical(1))
  is_len_0 <- vapply(.l, length, integer(1)) == 0

  .l[!(is_null | is_len_0)]
}
