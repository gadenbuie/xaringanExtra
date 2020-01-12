devtools::document()
devtools::install(dependencies = FALSE)

docs <- file.path(
	"docs",
	c("slide-tone", "tile-view", "animate-css", "tachyons", "text-poster",
		"panelset", "editable")
)

for (doc in docs) {
	if (dir.exists(lib_path <- file.path(doc, "libs"))) {
		unlink(lib_path, recursive = TRUE)
	}
	if (dir.exists(files_path <- file.path(doc, "index_files"))) {
		unlink(files_path, recursive = TRUE)
	}
	rmarkdown::render(file.path(doc, "index.Rmd"))
}
