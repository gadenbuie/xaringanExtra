# xaringanExtra 0.8.0

This release focuses entirely on improving the **panelset** feature, especially
in Quarto web pages and slides. Panelset is also now a Quarto extension that can
be installed with `quarto add gadenbuie/xaringanExtra` and can be used with any
computation engine.

* **panelset** now works even better in Quarto documents, using the same syntax
  as [used for panelsets in R Markdown documents](http://pkg.garrickadenbuie.com/xaringanExtra/#/panelset?id=use-in-r-markdown) (#190).

* **panelset** now supports a [fenced div](https://pandoc.org/MANUAL.html#extension-fenced_divs)
  syntax where `::: {.panelset}` is used to start a panelset and each panel is
  defined by a new heading within the fenced div. When used in this way, the
  heading level of the subsections is ignored, the highest level subsection
  heading within the fenced div determines the section level that creates a new
  panel (#191).

* **panelset** CSS was revamped for better ergonomics, in particular to improve
  how the border bottom separating the tabs from the content and the bottom
  border of the active tab are handled. `style_panelset_tabs()` gains a new
  `separator_color` argument to replace `tabs_border_bottom` (#192).

* **panelset** now fully supports panelset chunks in Quarto, either with
  `#| panelset: true` for chunk options or the alternative syntax specifying the
  panel names for the source and output panels (#193):

  ````markdown
  ```{r}
  #| panelset:
  #|  - source: The Code
  #|  - output: The Result
  rnorm(10)
  ```
  ````

  Unlike in R Markdown, where you always need to place panelset chunks in a
  `::: {.panelset}` div, in Quarto, panelset code chunks automatically create
  their own panelsets with two tabs (code and output). Use the 
  `::: {.panelset}` syntax to add more than one panelset code chunk to the same
  panelset (#196).

* Nested **panelsets** are now supported (#194)! In xaringan slides and when
  using the hand-rolled panelset syntax, you can now nest panelsets within
  panelsets. In R Markdown or Quarto documents, panelsets chunks can be nested
  within panelset sections. Nesting panelset sections requires the fenced div
  syntax:

  ````markdown
  # Nested fenced divs

  ::: {.panelset #outer}

  ## One

  Outer panel One.

  ::: {.panelset #inner}
  ### One A

  Inner panel One A.

  ### One B

  Inner panel One B.
  :::

  ## Two

  Outer panel Two.
  :::
  ````

* **panelset** fully supports [Quarto Revealjs Presentations](https://quarto.org/docs/presentations/revealjs/).
  All of panelset's features in xaringan are fully supported in Quarto slides,
  including automatically stepping through the panels on a slides (#195).

* **panelset** now supports synchronized panels (#195)! Give each panelset a
  `group` attribute with a unique name, e.g. `{.panelset group="language"}`, and
  the selected tab will be synchronized across all other panelsets with the same
  group name. The tab selection is synchronized by tab name, so if the user
  switches from the "R" tab to the "Python" tab, all panelsets with
  `group="language"` will have their "Python" tab activated (if they have one).

  The chosen panel tab is stored in the user's browser, which means that the
  user's choice is reflected across all pages on your domain. It's also
  remembered when they return to your page later (in the same browser).
  Technically, this feature uses the browser's
  [localStorage API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API/Using_the_Web_Storage_API)
  and no user data is transmitted anywhere.

* **panelset** is now also a Quarto extension that can be installed and used
  without requiring R (#195). To install the extension, run the following in
  your terminal.

  ```bash
  quarto add gadenbuie/xaringanExtra
  ```

  Then, in your Quarto document, add the following to the YAML front matter:

  ```yaml
  filters:
    - panelset
  ```

* **panelset** now forces the chunk options `echo = TRUE` and `eval = TRUE`,
  when `panelset = TRUE` is used. Without these options, panelset's knitr hooks
  can't correctly convert the chunk source and output into two separate panels.

  When these options are disabled via a chunk option on the panelset chunk,
  panelset will give an error to help you spot this issue early. But if `echo`
  and `eval` are globally set to `FALSE`, panelset will now automatically set
  them to `TRUE`. This is especially helpful in Quarto revealjs presentations
  where Quarto defaults to `echo = FALSE` (#196).

# xaringanExtra 0.7.0

* BREAKING CHANGE: All arguments to `use_banner()` must be named. `use_banner()`
  now takes `...` earlier since you may want to include `style_banner()` style
  arguments without having to specify all the other arguments (#169).

* **scribble** can now be disabled on an individual slide by adding
  `class: no-scribble` to the slide (@mattwarkentin #166).

* Embedding slides via `embed_xaringan()` no longer requires that you set
  `self_contained: false` in the R Markdown document. `embed_xaringan()` now
  automatically sets the `data-external="1"` attribute on the element embedding
  the xaringan slides (thanks @jhelvy, @drfurtado, #177).

* **editable** now hides remark's "Paused" overlay when editing slides in
  presenter mode (#178).

# xaringanExtra 0.6.0 (2022-06-07)

* First release available on CRAN! Read about it at [garrickadenbuie.com/blog/xaringanextra-v0.6.0/](https://www.garrickadenbuie.com/blog/xaringanextra-v0.6.0/).

## New extras

* Add banners to your slides with `use_banner()`. Banners are text (or other
  HTML) that appear on every slide, for example the title of your talk or a link
  to your slides online. (thanks @mattwarkentin and @dataning, #161)

## Improved extras

* Sideways panelsets collapse to standard panelsets with tabs above the content
  on small devices (max-width 480px). (#122)

* Keep sideways panelset tabs on screen with long-scrolling content. (#123)

* The `panelset=TRUE` chunk option now automatically sets `results="hold"`
  unless over-ridden by a local chunk option.

## Fixed extras

* _share again_ no longer shows when viewing slides in the RStudio viewer pane. (#128)

* `use_xaringan_extras("panelset")` is now equivalent to `use_panelset()`.
  Previously the first would not install the knitr chunk hooks.

* panelset now uses the xaringan knitr source hooks, restoring line highlighting
  in the source panel of panelset chunks. (#138)

* Hide scribble controls when printing slides (thanks @yyzeng, #136).

* `text_poster()` has been removed.


# xaringanExtra 0.5.0 (2021-06-13)

* Added _sideways_ panelsets where tabs appear on the left or right side next
  to the tabbed content. [Learn more about this feature](https://pkg.garrickadenbuie.com/xaringanExtra/#/panelset?id=sideways-panelsets). (#121)

# xaringanExtra 0.4.2 (2021-05-29)

* Added color presets to **scribble**: press `0` through `9` while drawing to
  quickly toggle through a preset color palette, customizable using the
  `palette` argument of `use_palette()` (thanks @kim-soo-hwan, #112, #117).

* New feature: animated progress bars that don't interfere with the slide
  number. Simply add `use_progress_bar()` to your slides! (#109, #118)

# xaringanExtra 0.4.0 (2021-03-27)

* New extension: Always play gifs from the start with `use_freezeframe()` (#102)

# xaringanExtra 0.3.1 (2021-03-13)

* **Breaking change:** scribble now only accepts hexadecimal pen colors. You
  can still use `rgb()` syntax by calling the `rgb()` function in R: instead of
  `"rgb(61, 255, 232)"`, you can write `rgb(61, 255, 232, maxColorValue = 255)`.
* Fix a few other minor issues with **scribble**:
    - Fix toolbox unminimizing after mouseover when it should stay minimized
    - Don't show the eraser cursor until the mouse moves

# xaringanExtra 0.3.0 (2021-03-07)

- New addin: **scribble**! Now you can draw on your slides! Huge thanks to
  @mattwarkentin for developing and contributing this extension. With
  `use_scribble()` you can draw on your slides using your mouse or a tablet with
  stylus. Drawings stay with each slide and scale when the slides are resized.
  You can erase individual lines, undo or redo with keyboard shortcuts, or clear
  the drawings on the current slide easily with the provided toolbox.
  Thanks also to @LauraRK and @rpruim for suggestions and feedback.
  (@mattwarkentin #87)

# xaringanExtra 0.2.6 (2021-03-02)

- New addin: **search**! Easily search through the text in your slides.
  (thanks @statnmap, #82)

- All extensions now use version numbers that are independent of the
  xaringanExtra package version. This will reduce the number of copies of an
  extension that are added to a blogdown site's dependencies by ensuring that
  unrelated package updates don't change the extension version number.

# xaringanExtra 0.2.5 (2021-02-17)

- Resizing the tiles in Tile View now works when using browser zoom in/out

# xaringanExtra 0.2.4 (2020-10-21)

- Added **panelset chunks** that output code chunks source and results in
  separate panel tabs (#59)

- Added **broadcast**, a new experimental extension that allows viewers to follow the
  presenter's slides in their own browsers (thanks @spcanelon, #51, #58)

- Changing a panelset tab now emits a window resize event in hopes that any
  HTMLwidgets contained in the panel will resize to fit the panel container
  (thanks @mfherman #64)

# xaringanExtra 0.2.3 (2020-09-03)

## New Features

- **Panelset** now works with the same markdown formatting as R Markdown's
  `.tabset` feature in R Markdown documents! See
  [the panelset documentation](https://pkg.garrickadenbuie.com/xaringanExtra/#/panelset)
  for more information and examples (#41).

## Bug Fixes

- Fixed an issue with URL updating and **panelset** that caused security warnings
  in Safari and led to temporarily broken slide navigation (thanks @jvcasillas, #50)

# xaringanExtra 0.2.2 (2020-09-02)

- Fixed several issues with `style_share_again()`: fixed default arguments,
  the buttons now correctly inherit the foreground color, and slides without an
  author or title are handled correctly (thanks @mattwarkentin, #48).

# xaringanExtra 0.2.1 (2020-08-23)

- Use absolute units for share bar sizes and fix a typo in share bar hover text
  (thanks @apreshill, #44)

# xaringanExtra 0.2.0 (2020-08-22)

## New Features

- Added a new extension for sharing your slides called _share again_. It adds a
  "share bar" to the bottom of your slides when embedded in an `<iframe`> in
  another page. Another function `embed_xaringan()` is provided to embed slides
  in blogdown and R Markdown HTML sites in a responsive container.

## Updates and Changes

* Various updates do `use_logo()` documentation. The class to hide the logo is
  `.hide_logo` and the logo CSS and JavaScript are embedded directly for
  xaringan >= 0.16 (thanks @chainsawriot, #22, #24, #25, #30)

* Updated cookie settings when storing editable fields (#42)

* Disabled spell check and auto complete in editable areas (#16)

# xaringanExtra 0.1.0 (2020-08-14)

## Breaking Changes

* The CSS variables for panelset have been renamed and the arguments of
  `style_panelset_tabs()` haven been updated for ease of use. Unfortunately, this
  change is not backwards compatible; using the previous argument names will
  result in an informative warning without throwing an error. The panelset
  also does a better job of handling many tabs, which are now wrapped into
  multiple lines of tabs. (thanks @realauggieheschmeyer, #37, #38, #39).

* In conjunction with the item above, the `style_panelset()` has been renamed
  `style_panelset_tabs()`. This more clearly describes the part of the panelset
  that is styled, and it helps clarify the meaning of the more concise function
  argument names.

# xaringanExtra 0.0.19 (2020-07-22)

* Increased specificity of CSS rules for the panelset.

* Added `--panel-tab-background-color` with additional `-active` and `-hover`
  custom properties to style the background color of tabs. Similarly, two
  CSS variables for border color were added: `--panel-tab-border-color-active`
  and `--panel-tab-border-color-hover`.

* Updated Tachyons to 4.12.0 (#27)

* Added **clipboard** extra with `use_clipboard()`. Adds a "Copy Code" button
  to code chunks (`<pre><code>...</code></pre>`) and works in both xaringan
  slides and R Markdown documents (thanks @mattwarkentin #20, #36).

# xaringanExtra 0.0.18 (2020-07-16)

* Improved accessibility of panelset so that it now works with touch devices.
  The currently selected tab is written into the URL query to ensure that URLs
  resolve to currently open tab. The tab ID isn't written into the URL hash
  because this is used by remarkjs to jump to the current slide. (#34, #33, #18)

* Added a `NEWS.md` file to track changes to the package.

# xaringanExtra 0.0.17 (2020-07-09)

* [_Your slides are so extra!_ (useR!2020)](https://youtu.be/vZMuu77ocMY)

* `text_poster()` has been deprecated and will be removed eventually.
