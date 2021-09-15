test_that("style_panelset_tabs", {
  css <- style_panelset_tabs(
    foreground = "var(--text-mild)",
    background = "unset",
    active_foreground = "var(--text-dark)",
    active_background = "var(--text-lightest)",
    active_border_color = "var(--purple)",
    hover_background = "#fafafa",
    hover_border_color = "var(--text-lightest)",
    inactive_opacity = 1,
    tabs_border_bottom = "var(--text-mild)"
  )

  # FIXME: convert to testthat 3e
  expect_equal(
    as.character(css),
    "<style>.panelset{--panel-tab-foreground: var(--text-mild);--panel-tab-background: unset;--panel-tab-active-foreground: var(--text-dark);--panel-tab-active-background: var(--text-lightest);--panel-tab-active-border-color: var(--purple);--panel-tab-hover-background: #fafafa;--panel-tab-hover-border-color: var(--text-lightest);--panel-tabs-border-bottom: var(--text-mild);--panel-tab-inactive-opacity: 1;}</style>"
  )
})

describe("panelset_source_opts()", {
  default <- c(source = "Code", output = "Output")

  it("returns default if TRUE", {
    expect_equal(panelset_source_opts(TRUE), default)
  })

  it("returns default if not character", {
    expect_equal(panelset_source_opts(1), default)
    expect_equal(panelset_source_opts(1:10), default)
    expect_equal(panelset_source_opts(list()), default)
    expect_equal(panelset_source_opts(character()), default)
  })

  it("adds names if none provided", {
    expect_equal(
      panelset_source_opts(c("Code", "Output")),
      default
    )
    expect_equal(
      panelset_source_opts(c("Code")),
      default
    )
    expect_equal(
      panelset_source_opts(c("Apple", "Banana")),
      c(source = "Apple", output = "Banana")
    )
    expect_equal(
      panelset_source_opts(c(apple = "Apple", banana = "Banana")),
      default
    )
  })

  it("uses correct names if names are used", {
    expect_equal(
      panelset_source_opts(c(output = "Output", source = "Code")),
      default
    )

    expect_equal(
      panelset_source_opts(c(output = "Output")),
      default
    )

    expect_equal(
      panelset_source_opts(c(a = 1, b = 2, output = "Output", source = "Code")),
      default
    )
  })
})

render_slide_text <- function(rmd) {
  tmpfile <- tempfile(fileext = ".Rmd")
  on.exit(unlink(tmpfile))
  rmd <- c("---", "title: test", "---", "", rmd)
  writeLines(rmd, tmpfile)

  callr::r_safe(function(tmpfile) {
    rmarkdown::render(
      tmpfile,
      output_file = "slides.html",
      output_format = xaringan::moon_reader(seal = FALSE),
      quiet = TRUE
    )
  }, list(tmpfile = tmpfile))

  extract_slides_text(file.path(dirname(tmpfile), "slides.html"))
}

extract_slides_text <- function(path) {
  txt <- readLines(path)
  idx <- grep("^\\s*</?textarea", txt)
  txt <- txt[(idx[1] + 1):(idx[2] - 1)]
  txt <- paste(txt, collapse = "\n")
  txt <- gsub("\n\n+", "\n\n", txt)
  trimws(txt)
}

test_that("panelset knitr chunks with plots", {
  rmd <- paste(
    "```{r echo=FALSE}",
    "xaringanExtra::use_panelset(in_xaringan = TRUE)",
    "```",
    "",
    "```{r plot, panelset = TRUE}",
    "hist(precip)",
    "```",
    sep = "\n"
  )
  out <- render_slide_text(rmd)

  expect_equal(
    out,
    paste(
      c(
        ".panel[.panel-name[Code]",
        "",
        "```r",
        "hist(precip)",
        "```",
        "",
        "]",
        "",
        ".panel[.panel-name[Output]",
        "",
        "![](slides_files/figure-html/plot-1.png)&lt;!-- --&gt;",
        "",
        "]"
      ),
      collapse = "\n"
    )
  )
})

test_that("panelset knitr chunks with custom tab names", {
  rmd <- paste(
    "```{r echo=FALSE}",
    "xaringanExtra::use_panelset(in_xaringan = TRUE)",
    "```",
    "",
    "```{r plot, panelset = c(source = 'Hist', output = 'Plot')}",
    "hist(precip)",
    "```",
    sep = "\n"
  )
  out <- render_slide_text(rmd)

  expect_equal(
    out,
    paste(
      c(
        ".panel[.panel-name[Hist]",
        "",
        "```r",
        "hist(precip)",
        "```",
        "",
        "]",
        "",
        ".panel[.panel-name[Plot]",
        "",
        "![](slides_files/figure-html/plot-1.png)&lt;!-- --&gt;",
        "",
        "]"
      ),
      collapse = "\n"
    )
  )
})

test_that("panelset knitr chunks with mutiple outputs", {
  rmd <- paste(
    "```{r echo=FALSE}",
    "xaringanExtra::use_panelset(in_xaringan = TRUE)",
    "```",
    "",
    "```{r panelset = TRUE}",
    'print("Oak is strong and also gives shade.")',
    'print("The lake sparkled in the red hot sun.")',
    "```",
    sep = "\n"
  )
  out <- render_slide_text(rmd)

  expect_equal(
    out,
    paste(
      c(
        ".panel[.panel-name[Code]",
        "",
        "```r",
        "print(\"Oak is strong and also gives shade.\")",
        "print(\"The lake sparkled in the red hot sun.\")",
        "```",
        "",
        "]",
        "",
        ".panel[.panel-name[Output]",
        "",
        "```",
        "## [1] \"Oak is strong and also gives shade.\"",
        "## [1] \"The lake sparkled in the red hot sun.\"",
        "```",
        "",
        "]"
      ),
      collapse = "\n"
    )
  )
})
