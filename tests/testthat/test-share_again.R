# test_that()

describe("parse_ratio", {
  it("parses remarkjs style ratios", {
    expect_equal(
      parse_ratio("16:9"),
      c(width = 1600, height = 900)
    )

    expect_equal(
      parse_ratio("4:3"),
      c(width = 400, height = 300)
    )
  })

  it("parses single number (w/h)", {
    expect_equal(
      parse_ratio(16 / 9),
      c(width = 300 * 16 / 9, height = 300)
    )

    expect_equal(
      parse_ratio(4 / 3),
      c(width = 400, height = 300)
    )

    expect_equal(
      parse_ratio("1"),
      c(width = 300, height = 300)
    )
  })

  it("errors if not a number", {
    expect_error(parse_ratio("a"))
  })
})
