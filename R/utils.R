
# use y if x is.null
`%||%` <- function(x, y) if (is.null(x)) y else x

xe_file <- function(...) {
	system.file(..., package = "xaringanExtra", mustWork = TRUE)
}
