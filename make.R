devtools::document()
devtools::install(dependencies = FALSE)


rmarkdown_v_expected <- package_version("2.0.7")
rmarkdown_v <- packageVersion("rmarkdown")
if (rmarkdown_v != rmarkdown_v_expected) {
	message("The last version of rmarkdown used was ", rmarkdown_v_expected,
					" but current version is ", rmarkdown_v)
}

docs <- file.path(
	"docs",
	c("slide-tone", "tile-view", "animate-css", "tachyons", "text-poster",
		"panelset", "editable", "logo")
)

for (doc in docs) {
	if (dir.exists(lib_path <- file.path(doc, "libs"))) {
		unlink(lib_path, recursive = TRUE)
	}
	if (dir.exists(files_path <- file.path(doc, "index_files"))) {
		unlink(files_path, recursive = TRUE)
	}
	message("Rendering ", doc)
	rmarkdown::render(file.path(doc, "index.Rmd"), quiet = TRUE)
}

message("Rendering docs/index.html from README.md")
rmarkdown::render("README.md", output_format = cleanrmd::html_document_clean(theme = "vanilla"), output_file = "docs/index.html")
x <- readLines("docs/index.html")
x <- gsub("docs/", "", x, fixed = TRUE)
x <- gsub("#-", "#", x, fixed = TRUE)
x <- gsub("#animatecss", "#animate.css", x, fixed = TRUE)
writeLines(x, "docs/index.html")
