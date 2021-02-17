devtools::document()
devtools::install(dependencies = FALSE)

rmarkdown_v_expected <- package_version("2.6.6")
rmarkdown_v <- packageVersion("rmarkdown")
if (rmarkdown_v != rmarkdown_v_expected) {
  message(
    "The last version of rmarkdown used was ",
    rmarkdown_v_expected,
    " but current version is ",
    rmarkdown_v
  )
}

docs <- file.path(
  "docs",
  c(
    "slide-tone",
    "tile-view",
    "animate-css",
    "tachyons",
    "panelset",
    "editable",
    "logo",
    "webcam",
    "extra-styles",
    "clipboard",
    "broadcast",
    "share-again"
  )
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
  if (doc == "docs/share-again") {
    message("Rendering docs/share-again/share-again")
    rmarkdown::render(file.path(doc, "share-again.Rmd"), quiet = TRUE)
  }
}

message("Rendering panelset/rmarkdown example")
rmarkdown::render(file.path("docs", "panelset", "rmarkdown.Rmd"), quiet = TRUE)

message("Rendering README")
rmarkdown::render("README.Rmd", quiet = TRUE)

message("Rendering docs/README.md from README.md")

if (fs::dir_exists("docs/figures")) fs::dir_delete("docs/figures")
fs::dir_copy("man/figures", "docs/figures", overwrite = TRUE)

fs::file_copy("NEWs.md", "docs/NEWS.md", overwrite = TRUE)


# Manually process README into documentation site -------------------------

fs::file_copy("README.md", "docs/README.md", overwrite = TRUE)
x <- readLines("docs/README.md")
x <- c("## xaringanExtra", x[-1:-2])
x <- gsub("man/figures", "figures", x, fixed = TRUE)
x <- gsub("docs/", "", x, fixed = TRUE)
x <- gsub("#-", "#", x, fixed = TRUE)
x <- gsub("#animatecss", "#animate.css", x, fixed = TRUE)
idx_headers <- grep("^(## [^[:graph:]]+ (.+))", x, perl = TRUE)
headers <- x[idx_headers]
headers_emoji_names <- sub("^## ", "", headers, perl = TRUE)
header_names <- sub("^[^[:graph:]]+ ", "", headers_emoji_names, perl = TRUE)
header_slugs <- gsub("[^[:alnum:]]", "-", tolower(header_names), perl = TRUE)

for (header_slug in header_slugs) {
  x <- gsub(paste0("#", header_slug), paste0("/", header_slug), x, fixed = TRUE)
}
x <- gsub("(#animate.css)", "(/animate-css)", x, fixed = TRUE)

x <- sub(
  "^#### 📺 \\[(.+?)\\]\\(.+gadenbuie.github.io/xaringanExtra/(.+?)\\)\\s*$",
  paste0(
    '<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./\\2/index.html" title="\\1" width="400" height="300" loading=lazy></iframe></div>\n',
    '<p align="right"><a href="./\\2" target="_blank">\\1<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>'
  ),
  x
)

x <- sub("./share-again/share-again.html/index.html", "./share-again/share-again.html", x, fixed = TRUE)

sidebar <- c(
  "* [xaringanExtra](README.md#xaringanextra)",
  "* [Installation](README.md#installation)",
  "---"
)

for (i in seq_along(idx_headers)) {
  if (i == 1) {
    message("Writing docs/README.md")
    writeLines(x[1:(idx_headers[i]-1)], "docs/README.md")
  }

  title <- headers_emoji_names[i]
  slug <- header_slugs[i]
  sidebar <- c(
    sidebar,
    sprintf("* [%s](%s.md)", title, slug)
  )

  section_end <- if (i == length(idx_headers)) {
    length(x)
  } else {
    idx_headers[i + 1] - 1
  }

  section_file <- fs::path("docs", slug, ext = "md")
  message("Writing ", section_file)
  writeLines(x[idx_headers[i]:section_end], section_file)
}

sidebar <- c(sidebar, "---", "* [Changelog](NEWS.md)")
message("Writing docs/sidebar.md")
writeLines(sidebar, "docs/_sidebar.md")
