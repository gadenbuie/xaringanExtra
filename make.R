devtools::document()
devtools::install()

docs <- c("docs/slide-tone", "docs/tile-view")

for (doc in docs) {
	if (dir.exists(file.path(doc, "libs"))) {
		unlink(file.path(doc, "libs"), recursive = TRUE)
	}
	rmarkdown::render(file.path(doc, "index.Rmd"))
}
