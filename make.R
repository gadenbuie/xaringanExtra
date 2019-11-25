devtools::document()
devtools::install()

docs <- file.path(
	"docs",
	c("slide-tone", "tile-view", "animate-css", "tachyons", "text-poster")
)

for (doc in docs) {
	if (dir.exists(file.path(doc, "libs"))) {
		unlink(file.path(doc, "libs"), recursive = TRUE)
	}
	rmarkdown::render(file.path(doc, "index.Rmd"))
}
