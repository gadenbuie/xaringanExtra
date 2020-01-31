# test_that()

describe("css_position()", {
  it("is_css_position()", {
    expect_true(is_css_position(css_position()))
    expect_true(is_css_position(list(top = 0, right = 0)))
    expect_true(is_css_position(list(top = 0, right = 0, left = 0)))
    expect_false(is_css_position(list(top = NULL, right = 0, left = 0)))
  })

  it("top OR bottom, left OR right, or both", {
    expect_in_names <- function(x, name, has = TRUE) {
      if (has) expect_true(name %in% names(x)) else expect_false(name %in% x)
    }
    expect_in_names(css_position(top = 0), "top")
    expect_in_names(css_position(bottom = 0), "bottom")
    expect_in_names(css_position(bottom = 0), "top", FALSE)
    expect_in_names(css_position(right = 0), "right")
    expect_in_names(css_position(left = 0), "left")
    expect_in_names(css_position(left = 0), "right", FALSE)

    expect_in_names(css_position(top = 1, bottom = 1), "top")
    expect_in_names(css_position(top = 1, bottom = 1), "bottom")
    expect_in_names(css_position(left = 1, right = 1), "left")
    expect_in_names(css_position(left = 1, right = 1), "right")
  })
})
