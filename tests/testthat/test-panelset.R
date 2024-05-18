test_that("style_panelset_tabs", {
  expect_snapshot(
    style_panelset_tabs(
      foreground = "var(--text-mild)",
      background = "unset",
      active_foreground = "var(--text-dark)",
      active_background = "var(--text-lightest)",
      active_border_color = "var(--purple)",
      hover_background = "#fafafa",
      hover_border_color = "var(--text-lightest)",
      inactive_opacity = 1,
      separator_color = "var(--text-mild)"
    )
  )

  expect_snapshot(
    style_panelset_tabs(
      foreground = "var(--text-mild)",
      background = "unset",
      active_foreground = "var(--text-dark)",
      active_background = "var(--text-lightest)",
      active_border_color = "var(--purple)",
      hover_background = "#fafafa",
      hover_border_color = "var(--text-lightest)",
      inactive_opacity = 1,
      separator_color = "var(--text-mild)",
      selector = NULL
    )
  )

  expect_warning(expect_null(style_panelset_tabs(foo = "bar")))
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
  expect_snapshot(
    cat(
      render_slide_text(
        paste(
          "```{r echo=FALSE}",
          "xaringanExtra::use_panelset(in_xaringan = TRUE)",
          "```",
          "",
          "```{r plot, panelset = TRUE}",
          "hist(precip)",
          "```",
          sep = "\n"
        )
      )
    )
  )
})

test_that("panelset knitr chunks with custom tab names", {
  expect_snapshot(
    cat(
      render_slide_text(
        paste(
          "```{r echo=FALSE}",
          "xaringanExtra::use_panelset(in_xaringan = TRUE)",
          "```",
          "",
          "```{r plot, panelset = c(source = 'Hist', output = 'Plot')}",
          "hist(precip)",
          "```",
          sep = "\n"
        )
      )
    )
  )
})

test_that("panelset knitr chunks with mutiple outputs", {
  expect_snapshot(
    cat(
      render_slide_text(
        paste(
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
      )
    )
  )
})
