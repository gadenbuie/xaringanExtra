## xaringanExtra

<!-- badges: start -->
<!-- badges: end -->
<!-- Links -->

`xaringanExtra` is a playground of enhancements and extensions for
[xaringan](https://slides.yihui.org/xaringan) slides.

-   Add an overview of your presentation with [tile view](/tile-view)
-   Make your slides [editable](/editable)
-   Share your slides in style with [share again](/share-again)
-   Broadcast your slides in real time to viewers with
    [broadcast](/broadcast)
-   Scribble on your slides during your presentation with
    [scribble](/scribble)
-   Announce slide changes with a [subtle tone](/slide-tone)
-   Animate slide transitions with [animate.css](/animate-css)
-   Add tabbed panels to slides with [panelset](/panelset)
-   Add a logo to all of your slides with [logo](/logo)
-   Add a top or bottom banner to all of your slides with
    [banner](/banner)
-   Add a search box to search through your slides with
    [search](/search)
-   Use the [Tachyons CSS utility toolkit](/tachyons)
-   Add a live video feed of your [webcam](/webcam)
-   Add one-click code copying with [clipboard](/clipboard)
-   Always play gifs from the start with [freezeframe](/freezeframe)
-   Fit your slides to [fill the browser window](/fit-to-screen)
-   Add [extra CSS styles](/extra-styles)

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

