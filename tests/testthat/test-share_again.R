# test_that()

expect_str_detect <- function(string, pattern, fixed = TRUE, negate = FALSE) {
  if (!is.character(string)) {
    string <- format(string)
  }
  if (negate) {
    expect_false(grepl(!!pattern, string, fixed = fixed))
  } else {
    expect_true(grepl(!!pattern, string, fixed = fixed))
  }
}

describe("use_share_again()", {
  it("returns an htmltools tag list with shareagain dependency", {
    x <- use_share_again()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_true("xaringanExtra-shareagain" %in% unlist(dep_names))
  })
})

describe("embed_xaringan()", {
  it("returns an htmltools tag list", {
    x <- embed_xaringan("demo-slides.html", max_width = "400px")
    expect_s3_class(x, "shiny.tag.list")
    expect_equal(x[[1]]$name, "div")
    expect_equal(x[[1]]$attribs$class, "shareagain")
    expect_str_detect(x[[1]]$attribs$style, "max-width:400px")
    expect_equal(x[[1]]$children[[1]]$name, "iframe")
    expect_equal(x[[1]]$children[[1]]$attribs$src, "demo-slides.html")
    expect_equal(x[[1]]$children[[1]]$attribs$width, 1600)
    expect_equal(x[[1]]$children[[1]]$attribs$height, 900)
  })
})

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

describe("style_share_again()", {
  it("returns an htmltools style tag", {
    x <- style_share_again()
    expect_s3_class(x, "shiny.tag")
    expect_equal(x$name, "style")
  })

  it("returns nothing if all NULL", {
    expect_null(style_share_again(NULL, NULL, NULL))
  })

  it("updates shareagain css color variables", {
    x <- style_share_again("red", "blue")
    expect_str_detect(x, "--shareagain-foreground: red")
    expect_str_detect(x, "--shareagain-background: blue")
  })

  it("doesn't hide social buttons if 'all' is present", {
    x_all <- style_share_again(share_buttons = "all")
    x_all2 <- style_share_again(share_buttons = c("all", "twitter"))
    x_all_none <- style_share_again(share_buttons = c("all", "twitter", "none"))

    expect_str_detect(x_all, "--shareagain-twitter: none", negate = TRUE)
    expect_str_detect(x_all2, "--shareagain-twitter: none", negate = TRUE)
    expect_str_detect(x_all_none, "--shareagain-twitter: none", negate = TRUE)

    expect_equal(x_all, x_all2)
    expect_equal(x_all, x_all_none)
  })

  it("hides social buttons", {
    not_twitter <- setdiff(share_button_social_options(), "twitter")
    expect_str_detect(
      style_share_again(share_buttons = not_twitter),
      "--shareagain-twitter: none"
    )

    not_twitter_or_fb <- setdiff(not_twitter, "facebook")
    expect_str_detect(
      style_share_again(share_buttons = not_twitter_or_fb),
      "--shareagain-twitter: none"
    )

    expect_str_detect(
      style_share_again(share_buttons = not_twitter_or_fb),
      "--shareagain-facebook: none"
    )
  })

  it("hides all social buttons when none is present", {
    for (social in share_button_social_options()) {
      expect_str_detect(
        style_share_again(share_buttons = "none"),
        paste0("--shareagain-", social, ": none")
      )
    }

    for (social in share_button_social_options()) {
      expect_str_detect(
        style_share_again(share_buttons = c(social, "none")),
        paste0("--shareagain-", social, ": none")
      )
    }
  })
})
