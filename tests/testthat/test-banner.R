# test_that()

describe("use_banner()", {
  it("returns an htmltools tag list with banner dependency", {
    x <- use_banner()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
    expect_true(any(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_true("xaringanExtra-banner" %in% unlist(dep_names))
  })
})

describe("init_banner()", {
  it("returns nothing if no text is included", {
    expect_null(init_banner())
  })

  it("returns a string with a <script> tag", {
    x <- init_banner(left = "bottom left")
    expect_match(x, "^<script>")
    expect_match(x, "</script>$")
    expect_type(x, "character")
    expect_length(x, 1)

    expect_snapshot(init_banner())
    expect_snapshot(init_banner(left = "bottom left", position = "bottom"))
    expect_snapshot(init_banner(right = "top right", position = "top"))
    expect_snapshot(init_banner(left = "left text", exclude = "title-slide"))
    expect_snapshot(init_banner(center = "center", exclude = c("one", "two")))
  })
})

describe("style_banner()", {
  it("returns style tag", {
    x <- style_banner(text_color = "red", height = "3em")
    expect_s3_class(x, "shiny.tag")
    expect_length(x$children, 1)
    expect_s3_class(x$children[[1]], "html")
    expect_equal(x$name, "style")
    expect_snapshot(paste(x$children[[1]]))
  })

  it("errors when non-length-1 values are provided", {
    expect_error(style_banner(text_color = c("red", "blue")), "text_color")
    expect_error(style_banner(selector = c("this", "that")), "selector")
  })

  it("returns nothing if only default values", {
    expect_null(style_banner())
  })

  it("errors if invalid units are provided", {
    expect_silent(style_banner(height = 12))
    expect_error(style_banner(height = "twelve"))

    expect_silent(style_banner(padding_horizontal = "10%"))
    expect_error(style_banner(padding_horizontal = "10 pct"))

    expect_silent(style_banner(padding_vertical = "10%"))
    expect_error(style_banner(padding_vertical = "10 pct"))

    expect_silent(style_banner(font_size = "auto"))
    expect_error(style_banner(font_size = "automatic"))
  })

  it("allow reset values in unit properties", {
    expect_silent(style_banner(font_size = "inherit"))
    expect_silent(style_banner(font_size = "unset"))
    expect_silent(style_banner(font_size = "revert"))
    expect_silent(style_banner(font_size = "initial"))
  })

  it("handles width units", {
    expect_snapshot(style_banner(width = "25%"))
    expect_snapshot(style_banner(width = c("100px", "200px")))
    expect_snapshot(style_banner(width = c(center = "2em", right = "3em")))

    expect_error(
      style_banner(width = "infinite")
    )

    expect_error(
      style_banner(width = 1:5),
      "length 3"
    )

    expect_error(
      style_banner(width = character()),
      "length 3"
    )

    expect_error(
      style_banner(width = c(CENTER = "foo")),
      "CENTER"
    )
  })
})
