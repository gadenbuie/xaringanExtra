
# use y if x is.null
`%||%` <- function(x, y) if (is.null(x)) y else x

xe_file <- function(...) {
  system.file(..., package = "xaringanExtra", mustWork = TRUE)
}

xaringan_version <- function(min = NULL) {
	xv <- utils::packageVersion("xaringan")
	if (is.null(min)) return(xv)
	xv >= package_version(min)
}
