test_that("style_panelset_tabs", {
  css <- style_panelset_tabs(
  	foreground = "var(--text-mild)",
  	background = "unset",
  	active_foreground = "var(--text-dark)",
  	active_background =  "var(--text-lightest)",
  	active_border_color = "var(--purple)",
  	hover_background =  "#fafafa",
  	hover_border_color = "var(--text-lightest)",
  	inactive_opacity = 1,
  	tabs_border_bottom = "var(--text-mild)"
  )

  # FIXME: convert to testthat 3e
  expect_equal(
  	as.character(css),
  	"<style>.panelset{--panel-tab-foreground: var(--text-mild);--panel-tab-background: unset;--panel-tab-active-foreground: var(--text-dark);--panel-tab-active-background: var(--text-lightest);--panel-tab-active-border-color: var(--purple);--panel-tab-hover-background: #fafafa;--panel-tab-hover-border-color: var(--text-lightest);--panel-tabs-border-bottom: var(--text-mild);--panel-tab-inactive-opacity: 1;}</style>"
  )
})
