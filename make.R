devtools::document()
devtools::install(dependencies = FALSE)

rmarkdown_v_expected <- package_version("2.3")
rmarkdown_v <- packageVersion("rmarkdown")
if (rmarkdown_v != rmarkdown_v_expected) {
	message("The last version of rmarkdown used was ", rmarkdown_v_expected,
					" but current version is ", rmarkdown_v)
}

docs <- file.path(
	"docs",
	c("slide-tone", "tile-view", "animate-css", "tachyons",
		"panelset", "editable", "logo", "webcam", "extra-styles", "clipboard")
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

message("Rendering README")
rmarkdown::render("README.Rmd", quiet = TRUE)

message("Rendering docs/README.md from README.md")

if (fs::dir_exists("docs/figures")) fs::dir_delete("docs/figures")
fs::dir_copy("man/figures", "docs/figures", overwrite = TRUE)

fs::file_copy("README.md", "docs/README.md", overwrite = TRUE)
x <- readLines("docs/README.md")
x <- c("## xaringanExtra", x[-1:-2])
x <- gsub("man/figures", "figures", x, fixed = TRUE)
x <- gsub("docs/", "", x, fixed = TRUE)
x <- gsub("#-", "#", x, fixed = TRUE)
x <- gsub("#animatecss", "#animate.css", x, fixed = TRUE)
idx_headers <- grep("^(## [^[:graph:]]+ (.+))", x, perl = TRUE)
headers <- x[idx_headers]
headers_slug <- sub("^## [^[:graph:]]+ ", "", headers, perl = TRUE)
headers_slug <- sub("[^[:alnum:]]", "-", tolower(headers_slug), perl = TRUE)
headers <- paste0(headers, " :id=", headers_slug)
x[idx_headers] <- headers
x <- sub(
	"^#### 📺 \\[(.+?)\\]\\(.+gadenbuie.github.io/xaringanExtra/(.+?)\\)\\s*$",
	paste0(
		'<iframe src="./\\2/index.html" title="\\1" width=100% height=400px loading=lazy></iframe>\n',
		'<p align="right"><a href="./\\2" target="_blank">\\1<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>'
	),
	x
)
writeLines(x, "docs/README.md")
