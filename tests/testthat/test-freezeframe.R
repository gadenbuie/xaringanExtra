# test_that()

describe("use_freezeframe()", {
  it("returns an htmltools tag list with freezeframe dependencies", {
    x <- use_freezeframe()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_setequal(dep_names, c("freezeframe", "xaringanExtra-freezeframe"))
  })

  it("errors with bad input", {
    expect_error(use_freezeframe(selector = 2))
    expect_error(use_freezeframe(selector = NULL))
    expect_error(use_freezeframe(selector = NA_character_))
    expect_error(use_freezeframe(selector = TRUE))
    expect_error(use_freezeframe(trigger = FALSE))
    expect_error(use_freezeframe(overlay = "no"))
    expect_error(use_freezeframe(responsive = "no"))
    expect_error(use_freezeframe(warnings = "no"))
  })
})

describe("freezeframe_options()", {
  it("returns a string with a <script> tag", {
    x <- freezeframe_options()
    expect_match(x, "^<script")
    expect_match(x, "</script>$")
    expect_type(x, "character")
    expect_length(x, 1)

    expect_snapshot(freezeframe_options())
    expect_snapshot(freezeframe_options("img"))
    expect_snapshot(freezeframe_options(trigger = "none", responsive = FALSE))
  })
})
