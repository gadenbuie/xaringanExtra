# test_that()

describe("use_scribble()", {
  it("returns an htmltools tag list with scribble dependencies", {
    x <- use_scribble()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_setequal(dep_names, c("fabric", "xaringanExtra-scribble"))
  })

  it("errors with bad input", {
    expect_error(use_scribble(pen_color = c("red", "blue")))
    expect_error(use_scribble(pen_color = 12))
    expect_error(use_scribble(pen_size = "three"))
    expect_error(use_scribble(eraser_size = "thirty"))
  })
})

describe("init_scribble()", {
  it("returns a string with a <script> tag", {
    x <- init_scribble()
    expect_match(x, "^<script>")
    expect_match(x, "</script>$")
    expect_type(x, "character")
    expect_length(x, 1)

    expect_snapshot(init_scribble())
    expect_snapshot(init_scribble("#abc123"))
    expect_snapshot(init_scribble("#FF00FF", pen_size = 4))
    expect_snapshot(init_scribble(pen_size = 4, eraser_size = 33))
  })
})
