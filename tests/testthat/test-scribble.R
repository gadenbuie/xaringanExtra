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
    expect_error(use_scribble(pen_color = "rgb(0, 0, 0)"))
    expect_warning(use_scribble(
      palette = paste0("#", replicate(11, paste(sample(c(0:9, letters[1:6]), 6, replace = TRUE), collapse = "")))
    ))
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
    expect_snapshot(init_scribble(palette = c("#bada55", "#55adab", "#bada55")))
  })
})

test_that("is_hex_color()", {
  expect_true(is_hex_color("#fff"))
  expect_true(is_hex_color("#FFF"))
  expect_true(is_hex_color("#444"))
  expect_true(is_hex_color("#012345"))
  expect_true(is_hex_color("#67abcd"))
  expect_true(is_hex_color("#123456ab"))
  expect_false(is_hex_color("#1234"))
  expect_false(is_hex_color("#12345"))
  expect_false(is_hex_color("#1234567"))
  expect_false(is_hex_color("rgb(0, 0, 0)"))
  expect_false(is_hex_color("rgba(0, 0, 0, 10%)"))
  expect_false(is_hex_color("hsl(0, 0, 0, 10%)"))
})
