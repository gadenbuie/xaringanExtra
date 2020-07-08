devtools::document()
devtools::install(dependencies = FALSE)

rmarkdown_v_expected <- package_version("2.1")
rmarkdown_v <- packageVersion("rmarkdown")
if (rmarkdown_v != rmarkdown_v_expected) {
	message("The last version of rmarkdown used was ", rmarkdown_v_expected,
					" but current version is ", rmarkdown_v)
}

docs <- file.path(
	"docs",
	c("slide-tone", "tile-view", "animate-css", "tachyons",
		"panelset", "editable", "logo", "webcam")
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
x <- gsub(paste0(getwd(), "/man/"), "", x, fixed = TRUE)
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
	'<iframe src="/\\2/index.html" title="\\1" width=100% height=400px loading=lazy></iframe>',
	x
)
writeLines(x, "docs/README.md")
