# test_that()

describe("use_search()", {
  it("returns an htmltools tag list with search dependency", {
    x <- use_search()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_true("xaringanExtra-search" %in% unlist(dep_names))
  })

  it("errors with bad input", {
    expect_error(use_search(position = "top"))
    expect_error(use_search(case_sensitive = "yes"), "logical")
    expect_error(use_search(show_icon = "yes"), "logical")
    expect_error(use_search(auto_search = "yes"), "logical")
  })
})

describe("init_search()", {
  it("returns a string with a <script> tag", {
    x <- init_search()
    expect_match(x, "^<script>")
    expect_match(x, "</script>$")
    expect_type(x, "character")
    expect_length(x, 1)

    expect_snapshot(init_search())
    expect_snapshot(init_search("top-right"))
    expect_snapshot(init_search(case_sensitive = TRUE))
    expect_snapshot(init_search(show_icon = TRUE))
    expect_snapshot(init_search(auto_search = FALSE))
  })
})

describe("style_search()", {
  it("returns style tag", {
    x <- style_search()
    expect_s3_class(x, "shiny.tag")
    expect_length(x$children, 1)
    expect_s3_class(x$children[[1]], "html")
    expect_equal(x$name, "style")
    expect_snapshot(paste(x$children[[1]]))
  })
})
