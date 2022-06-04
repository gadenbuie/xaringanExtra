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
