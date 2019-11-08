
# xaringanExtra

<!-- badges: start -->
<!-- badges: end -->

<!-- Links -->
[xaringan]: https://slides.yihuie.name/xaringan

`xaringanExtra` is a playground of enhancements and addins for [xaringan] slides.

## Installation

You can install the current version of xaringanExtra from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("gadenbuie/xaringanExtra")
```

## &#x1F5FA; Tile View

#### &#x1F4FA; [Tile View Demo](https://gadenbuie.github.io/xaringanExtra/tile-view)

Tile view gives you a way to quickly jump between slides.
Just press <kbd>T</kbd> at any point in your slideshow and the tile view appears.
Click on a slide to jump to the slide, or press <kbd>T</kbd> to exit tile view.

![](man/figures/tile-view.png)

To add tile view to your xaringan presentation, 
add the following code chunk to your slides' R Markdown file.

````markdown
```{r xaringan-tile-view, echo=FALSE}
xaringanExtra::xaringan_tile_view()
```
````

Tile view is heavily inspired by
(and is essentially a port to Vanilla JavaScript of)
[a jQuery remarkjs hook](https://github.com/StephenHesperus/remark-hook/)
by the same name by [Stephen Hesperus](https://github.com/StephenHesperus).

## &#x1F50A; Slide Tone

#### &#x1F4FA; [Slide Tone Demo](https://gadenbuie.github.io/xaringanExtra/slide-tone)

Slide tone plays a subtle sound when you change slides.
It was 
[requested by a blind R user](https://github.com/yihui/xaringan/issues/214)
and enables users to hear an auditory signal of their progress through the slides.

The tones increase in pitch for each slide from a low C to a high C note.
The tone pitch stays the same for incremental slides.

Visit the 
[slide tone demo slides](https://gadenbuie.github.io/xaringanExtra/slide-tone)
to experience it yourself.
Or include slide tone in your next xaringan presentation 
by adding the following code chunk to your slides' R Markdown.

````markdown
```{r xaringan-slide-tone, echo=FALSE}
xaringanExtra::xaringan_slide_tone()
```
````
