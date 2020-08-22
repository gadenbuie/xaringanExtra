xaringanExtra
================

<!-- badges: start -->

<!-- badges: end -->

<!-- Links -->

`xaringanExtra` is a playground of enhancements and extensions for
[xaringan](https://slides.yihuie.org/xaringan) slides.

  - Add an overview of your presentation with [tile view](#-tile-view)
  - Make your slides [editable](#-editable)
  - Share your slides in style with [share again](#-share-again)
  - Announce slide changes with a [subtle tone](#-slide-tone)
  - Animate slide transitions with [animate.css](#-animatecss)
  - Add tabbed panels to slides with [panelset](#-panelset)
  - Add a logo to all of your slides with [logo](#-logo)
  - Use the [Tachyons CSS utility toolkit](#-tachyons)
  - Add a live video feed of your [webcam](#-webcam)
  - Add one-click code copying with [clipboard](#-clipboard)
  - Fit your slides to [fill the browser window](#-fit-to-screen)
  - Add [extra CSS styles](#-extra-styles)

Each item can be enabled separately, or load everything at once with a
single call.

```` markdown
```{r xaringanExtra, echo=FALSE}
xaringanExtra::use_xaringan_extra(c("tile_view", "animate_css", "tachyons"))
```
````

## Installation

You can install the current version of xaringanExtra from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("gadenbuie/xaringanExtra")
```

## 🗺 Tile View

#### 📺 [Tile View Demo](https://gadenbuie.github.io/xaringanExtra/tile-view)

Tile view gives you a way to quickly jump between slides. Just press
<kbd>O</kbd> (the letter **O** for **O**verview) at any point in your
slideshow and the tile view appears. Click on a slide to jump to the
slide, or press <kbd>O</kbd> to exit tile view.

![](man/figures/tile-view.png)

To add tile view to your xaringan presentation, add the following code
chunk to your slides’ R Markdown file.

```` markdown
```{r xaringan-tile-view, echo=FALSE}
xaringanExtra::use_tile_view()
```
````

Tile view is heavily inspired by (and is essentially a port to Vanilla
JavaScript of) [a jQuery remarkjs
hook](https://github.com/StephenHesperus/remark-hook/) by the same name
by [Stephen Hesperus](https://github.com/StephenHesperus).

## 📝 Editable

#### 📺 [Editable Demo](https://gadenbuie.github.io/xaringanExtra/editable)

Editable gives you a way to write directly inside your slides, updating
your content live. Make any element of your slides editable by using the
`.can-edit[...]` class.

![](man/figures/editable.gif)

Make your slides editable with the following code chunk.

```` markdown
```{r xaringan-editable, echo=FALSE}
xaringanExtra::use_editable(expires = 1)
```
````

Then, to make a component of your slides editable, use the `.can-edit[]`
class.

``` markdown
## .can-edit[You can edit this slide title]
```

Editable fields that only have the `.can-edit` class are reset whenever
the slides are re-loaded in your browser. If you want to store the
edited values and have them persist across browser sessions, give each
editable field a `.key-<NAME>` class. Be sure to make each key unique
and note that the key name must be a valid CSS class, i.e. it cannot
contain spaces.

``` markdown
## .can-edit.key-firstSlideTitle[Change this title and then reload the page]
```

For more complicated HTML elements, it’s best to make only spans of text
editable, such as

    Hello, .can-edit[world], and welcome to my talk!

or to use placeholder text.

``` markdown
## A few of my favorite things

.can-edit.key-likes[
- thing one
- thing two
]
```

## 📼 Share Again

#### 📺 [Share Again](https://gadenbuie.github.io/xaringanExtra/share-again/share-again.html)

Share your slides in style with *share again*\! It adds a share bar to
your slides that only shows up when they’re embedded in another page.
The bar adds easy slide navigation, quick access to full screen views,
and a share menu for one-click (or tap\!) sharing on social media sites.

![](man/figures/meet-share-again.jpg)

Add share again to your slides in three easy steps.

1.  Add `use_share_again()` to your slides
    
    ```` markdown
    ```{r share-again, echo=FALSE}
    xaringanExtra::use_share_again()
    ```
    ````

2.  Style your share bar and choose social media sites
    
    ```` markdown
    ```{r style-share-again, echo=FALSE}
    xaringanExtra::style_share_again(
      share_buttons = c("twitter", "linkedin", "pocket")
    )
    ```
    ````

3.  Embed your slides in
    [blogdown](https://bookdown.org/yihui/blogdown/) or R Markdown
    websites
    
    ```` markdown
    ```{r embed-xaringan, echo=FALSE}
    xaringanExtra::embed_xaringan(url = "share-again.html", ratio = "4:3")
    ```
    ````
    
    `embed_xaringan()` works with
    <span style="text-decoration: underline">any</span> xaringan
    presentation, *share again* not required\!
    
    Here’s what your [slides will look
    like](https://gadenbuie.github.io/xaringanExtra/share-again/) in an
    R Markdown HTML document.

## 🔊 Slide Tone

#### 📺 [Slide Tone Demo](https://gadenbuie.github.io/xaringanExtra/slide-tone)

Slide tone plays a subtle sound when you change slides. It was
[requested by a blind R
user](https://github.com/yihui/xaringan/issues/214) and enables users to
hear an auditory signal of their progress through the slides.

The tones increase in pitch for each slide from a low C to a high C
note. The tone pitch stays the same for incremental slides.

Visit the [slide tone demo
slides](https://gadenbuie.github.io/xaringanExtra/slide-tone) to
experience it yourself. Or include slide tone in your next xaringan
presentation by adding the following code chunk to your slides’ R
Markdown.

```` markdown
```{r xaringan-slide-tone, echo=FALSE}
xaringanExtra::use_slide_tone()
```
````

## 📽 Animate.css

#### 📺 [Animate.css Demo](https://gadenbuie.github.io/xaringanExtra/animate-css)

[Animate.css](http://daneden.github.io/animate.css) is a popular
collection of CSS animations. It contains

> a bunch of cool, fun, and cross-browser animations for you to use in
> your projects. Great for emphasis, home pages, sliders, and general
> just-add-water-awesomeness.

Use `use_animate_css()` to include the animate.css stylesheets in your
slides. This function automatically modifies the CSS selector that
enables the animation so that only the slides that are visible are
animated. This drastically improves performance on large slide decks
with many animations. For use in other HTML documents, set `xaringan =
FALSE` to load the default `animate.css` file without this performance
tweak.

To use animate.css in your slides, add the following code chunk to your
slides’ R Markdown.

```` markdown
```{r xaringan-animate-css, echo=FALSE}
xaringanExtra::use_animate_css()
```
````

Then add the `animated` class and the [desired animation
class](http://daneden.github.io/animate.css) to the slides you want to
animate. `Out` animations are only applied to slides on exit.

``` markdown
---
class: animated slideInRight fadeOutLeft

## This slide...

- slides in from the right 
- and fades out to the left on exit
```

If you want to use the same slide transitions for all slides, you can
use `use_animate_all()`. This function sets a default in and out
animation for all slides. Animations can be disabled for individual
slides by adding the class `no-animation` to the slide.

```` markdown
```{r xaringan-animate-all, echo=FALSE}
xaringanExtra::use_animate_all("slide_left")
```
````

Note: because `use_animate_all()` only imports the CSS required for the
slide in and slide out animations, you need to also include
`use_animate_css()` (see above) if you want to use other animations from
`animate.css` in your slides.

## 🗂 Panelset

#### 📺 [Panelset Demo](https://gadenbuie.github.io/xaringanExtra/panelset)

Panelset adds accessible tabbed panels — just like R Markdown’s
`.tabset` panels — to your xaringan slides. You can activate a panel by
clicking on the tab, or you can use the keyboard. When you reach a slide
with a panelset, the left and right arrows will step through the panels.

To use panelset, add the following chunk to your slides.

```` markdown
```{r xaringan-panelset, echo=FALSE}
xaringanExtra::use_panelset()
```
````

![](man/figures/panelset.gif)

Then, create a `.panelset[...]` that contains `.panels[]`. Each
`.panel[]` should have a `.panel-name[]` and content (everything that
isn’t the panel’s name).

``` markdown
.panel[.panel-name[NAME]
...content...
]
```

Here’s the example used in the demo slides.

```` markdown
.panelset[
.panel[.panel-name[R Code]

```{r panel-chunk, fig.show='hide'}
# ... r code ...
```
]

.panel[.panel-name[Plot]

![](README_files/figure-gfm/panel-chunk-1.png)
]
]
````

### Use in R Markdown

[Example R Markdown output with
panelset](https://gadenbuie.github.io/xaringanExtra/panelset/rmarkdown.html)

Panelset works in all R Markdown HTML outputs like HTML reports and
[blogdown](https://bookdown.org/yihui/blogdown/) webpages\!

Panelset may require a little bit more work than `rmarkdown`’s
[tabset](https://bookdown.org/yihui/rmarkdown-cookbook/html-tabs.html)
feature, but the trade-off is that it works in a wider range of document
types; generally, as long as the output is HTML, panelset should work.

Another advantage of panelset is that it enables deeplinking: the
currently shown tab is encoded in the URL automatically, allowing users
to link to open tabs. Users can also right click on a panel’s tab and
select *Copy Link* to link directly to a specific panel’s tab, which
will appear in view when visiting the copied link.

With standard R Markdown,
i.e. [rmarkdown::html\_document()](https://rmarkdown.rstudio.com/docs/reference/html_document.html),
you can use the following template.

``` markdown
::::: {.panelset}

## Tab One {.panel}

Amet enim aptent molestie vulputate pharetra
vulputate primis et vivamus semper.

## Tab Two {.panel}

### Sub heading one

Sit etiam malesuada arcu fusce ullamcorper
interdum proin tincidunt curabitur felis?

## Tab Three {.panel}

Adipiscing mauris egestas vitae pretium 
ad dignissim dictumst platea!

:::::
```

In other, less-standard R Markdown HTML formats, you can use pandoc’s
[fenced divs](https://pandoc.org/MANUAL.html#extension-fenced_divs).

``` markdown
::::: {.panelset}

::: {.panel}
[First Tab]{.panel-name}

Lorem sed non habitasse nulla donec egestas magna
enim posuere fames ante diam!
:::

::: {.panel}
[Second Tab]{.panel-name}

Consectetur ligula taciti neque scelerisque gravida
class pharetra netus lobortis quisque mollis iaculis.
:::

:::::
```

Alternatively, you can also use raw HTML.

``` html
<div class="panelset">
  <div class="panel">
    <div class="panel-name">First Tab</div>
    <!-- Panel content -->
    <p>Lorem ipsum, etc, etc</p>
  </div>
  <div class="panel">
    <div class="panel-name">Second Tab</div>
    <!-- Panel content -->
    <p>Lorem ipsum, etc, etc</p>
  </div>
</div>
```

### Customize Panelset Appearnce

To customize the appearance of your panels, you can use
`style_panelset_tabs()` called directly in an R chunk in your slides.

```` markdown
```{r echo=FALSE}
style_panelset_tabs(foreground = "honeydew", background = "seagreen")
```
````

The panelset uses opacity to soften the in-active tabs to increase the
chances that the tabs will work with your slide theme. If you decide to
change your tab colors or to use solid colored tabs, you’ll likely want
to set `inactive_opacity = 1` in `style_panelset()` (or the
corresponding `--panel-tab-inactive-opacity` CSS variable).

Behind the scenes, `style_panelset_tabs()` updates the values of [custom
CSS properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)
that define the panelset appearance. If you’d rather work with CSS, the
default values of these properties are shown in the CSS code below. You
can copy the whole CSS block to your slides and modify the values to
customize the style to fit your presentation.

```` markdown
```{css echo=FALSE}
.panelset {
   --panel-tab-foreground: currentColor;
   --panel-tab-background: unset;
   --panel-tab-active-foreground: currentColor;
   --panel-tab-active-background: unset;
   --panel-tab-active-border-color: currentColor;
   --panel-tab-hover-foreground: currentColor;
   --panel-tab-hover-background: unset;
   --panel-tab-hover-border-color: currentColor;
   --panel-tab-inactive-opacity: 0.5;
   --panel-tabs-border-bottom: #ddd;
   --panel-tab-font-family: Menlo, Consolas, Monaco, Liberation Mono, Lucida Console, monospace;
}
```
````

## 💌 Logo

#### 📺 [Logo Demo](https://gadenbuie.github.io/xaringanExtra/logo)

`use_logo()` adds a logo to all of your slides. You can make the logo a
clickable link and choose where on the slide it is placed. You can also
set which types of slides will not get the logo by default.

To add a logo to your xaringan presentation, add the following code
chunk to your slides’ R Markdown file.

```` markdown
```{r xaringan-logo, echo=FALSE}
xaringanExtra::use_logo(
  image_url = "https://raw.githubusercontent.com/rstudio/hex-stickers/master/PNG/xaringan.png"
)
```
````

See the documentation for `?use_logo` for more options regarding sizing
and positioning. You can also make the logo a link using `link_url` and
you can hide the logo for a particular slide by using the `hide_logo`
slide class.

## 🏗 Tachyons

#### 📺 [Tachyons Demo](https://gadenbuie.github.io/xaringanExtra/tachyons)

[Tachyons](http://tachyons.io/) is a collection of CSS utility classes
that works beautifully with
[xaringan](https://slides.yihuie.org/xaringan) presentations and the
[remarkjs](http://remarkjs.com/) class syntax.

To use tachyons in your slides, add the following code chunk to your
slides’ R Markdown.

```` markdown
```{r xaringan-tachyons, echo=FALSE}
xaringanExtra::use_tachyons()
```
````

Tachyons provides small, single-purpose CSS classes that are easily
composed to achieve larger functionality and styles. In the [remarkjs
content classes
syntax](https://github.com/gnab/remark/wiki/Markdown#content-classes),
you can compose classes by chaining them together. For example, the
following markdown produces a box with a washed green background
(`.bg-washed-green`) and a dark green border (`.b--dark-green`) on all
sides (`.ba`) with line width 2 (`.bw2`) and border radius (`.br3`). The
box has a shadow (`.shadow-5`) and medium-large horizontal padding
(`.ph4`) with a large top margin (`.mt5`).

``` markdown
.bg-washed-green.b--dark-green.ba.bw2.br3.shadow-5.ph4.mt5[
The only way to write good code is to write tons of bad code first. 
Feeling shame about bad code stops you from getting to good code

.tr[
— Hadley Wickham
]]
```

![](man/figures/tachyons.png)

Tachyons provides hundreds of CSS classes that are abbreviated and
terse, so it takes some time to learn. In addition to the [tachyons
documentation](http://tachyons.io/docs/), the [Tachyons
Cheatsheet](https://roperzh.github.io/tachyons-cheatsheet/) is an
excellent and easy to use reference.

## 🤳 Webcam

#### 📺 [Webcam Demo](https://gadenbuie.github.io/xaringanExtra/webcam)

Add a live video of your webcam into your slides (in your own browser
only). Useful when you are presenting via video conference to include
your video, or when you are recording a class or lecture.

To add **webcam** to your xaringan presentation, add the following code
chunk to your slides’ R Markdown file.

```` markdown
```{r}
xaringanExtra::use_webcam()
```
````

Inside your slides, press **w** to turn the webcam on and off, or press
**Shift** + **W** to move the video to the next corner. You can also
drag and drop the video within the browser window.

The webcam extension is based on the original [webcam
implementation](https://yihui.org/en/2017/12/html5-camera/) by Yihui
Xie, author of [xaringan](https://slides.yihuie.org/xaringan).

## 📋 Clipboard

#### 📺 [Clipboard Demo](https://gadenbuie.github.io/xaringanExtra/clipboard)

Add a “Copy Code” button for one-click code chunk copying.

To add **clipboard** to your xaringan presentation or R Markdown
document, add the following code chunk to your slides’ R Markdown file.

```` markdown
```{r xaringanExtra-clipboard, echo=FALSE}
xaringanExtra::use_clipboard()
```
````

You can also customize the text that is shown bby default when hovering
over a code chunk with the `button_text` argument. Use `success_text` to
specify the text shown when the copy action works, or `error_text` for
the text shown when the copy action fails. If the copy action fails, the
text will still be selected, so the user can still manually press
`Ctrl+C` to copy the code chunk.

These options accept raw HTML strings, so you can achieve an icon-only
appearance using FontAwesome icons:

```` markdown
```{r xaringanExtra-clipboard, echo=FALSE}
htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i>",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i>",
    error_text = "<i class=\"fa fa-times-circle\" style=\"color: #F94144\"></i>"
  ),
  rmarkdown::html_dependency_font_awesome()
)
```
````

clipboard works in xaringan slides, R Markdown documents, blogdown
sites, and Shiny apps\!

**Related projects:** For related R packages that provide copy support
via [clipboard.js](https://clipboardjs.com/) see

  - [RLesur/klippy: Copy to Clipboard Buttons for RMarkdown HTML
    Documents](https://github.com/RLesur/klippy)
  - [sbihorel/rclipboard: clipboard.js for R/Shiny
    Applications](https://github.com/sbihorel/rclipboard)

## 📐 Fit to Screen

#### 📺 [Fit to Screen Demo](https://gadenbuie.github.io/xaringanExtra/fit-screen)

xaringan/remark slides scale at a consistent ratio when the browser
window is resized. In other words, if the slide ratio is `4:3`, then
remark scales the slides and positions them in the browser window so
that they maintain the aspect ratio.

In certain situations, like when showing slides in split screen next to
another window like RStudio, this causes the slides to become rather
small. Alternatively, it’s a great way to be able to adapt your slides
to the aspect ratio of the projector or television screen when you don’t
know the ratio ahead of time.

This extension adds a short cut key — <kbd>Alt</kbd>/<kbd>Option</kbd>+
<kbd>F</kbd> — that fits the slides to the screen and ignores the slide
ratio. (Currently, it only turns on; reload your slides to return to
normal.)

![](man/figures/fit-screen.gif)

```` markdown
```{r xaringan-fit-screen, echo=FALSE}
xaringanExtra::use_fit_screen()
```
````

## 😎 Extra Styles

#### 📺 [Extra Styles Demo](https://gadenbuie.github.io/xaringanExtra/extra-styles)

I’ve collected a few CSS extras that I like to include in my slides,
that I’ve bundled up into the `use_extra_styles()` function.

```` markdown
```{r xaringan-extra-styles}
xaringanExtra::use_extra_styles(
  hover_code_line = TRUE,         #<<
  mute_unhighlighted_code = TRUE  #<<
)
```
````

  - `hover_code_line` adds a little floating triangle next to the
    hovered line in a code chunk

  - `mute_unhighlighted_code` modifies the xaringan/remarkjs line
    highlighting to mute the lines that *aren’t highlighted*.

![](man/figures/extra-styles-hover.gif)
