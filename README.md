
# xaringanExtra

<!-- badges: start -->
<!-- badges: end -->

<!-- Links -->
[xaringan]: https://slides.yihuie.name/xaringan
[remarkjs]: http://remarkjs.com/
[animate.css]: http://daneden.github.io/animate.css
[text-poster]: https://github.com/IMAGINARY/text-poster#readme

`xaringanExtra` is a playground of enhancements and addins for [xaringan] slides.

- Add an overview of your presentation with [tile view](#-tile-view)
- Announce slide changes with a [subtle tone](#-slide-tone)
- Animate slide transitions with [animate.css](#-animatecss)
- Use the [Tachyons CSS utility toolkit](#-tachyons)
- Create fancy [poster-style text blocks](#-text-poster)
- Fit your slides to [fill the browser window](#-fit-to-screen)

## Installation

You can install the current version of xaringanExtra from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("gadenbuie/xaringanExtra")
```

## &#x1F5FA; Tile View

#### &#x1F4FA; [Tile View Demo](https://gadenbuie.github.io/xaringanExtra/tile-view)

Tile view gives you a way to quickly jump between slides.
Just press <kbd>O</kbd> at any point in your slideshow and the tile view appears.
Click on a slide to jump to the slide, or press <kbd>O</kbd> to exit tile view.

![](man/figures/tile-view.png)

To add tile view to your xaringan presentation, 
add the following code chunk to your slides' R Markdown file.

````markdown
```{r xaringan-tile-view, echo=FALSE}
xaringanExtra::use_tile_view()
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
xaringanExtra::use_slide_tone()
```
````

## &#x1F4FD; Animate.css

#### &#x1F4FA; [Animate.css Demo](https://gadenbuie.github.io/xaringanExtra/animate-css)

[Animate.css] is a popular collection of CSS animations. It contains 

> a bunch of cool, fun, and cross-browser animations for you to use in your
> projects. Great for emphasis, home pages, sliders, and general
> just-add-water-awesomeness.

Use `use_animate_css()` to include the animate.css stylesheets in your slides.
This function automatically modifies the CSS selector that enables the animation
so that only the slides that are visible are animated.
This drastically improves performance on large slide decks with many animations.

To use animate.css in your slides, 
add the following code chunk to your slides' R Markdown.

````markdown
```{r xaringan-animate-css, echo=FALSE}
xaringanExtra::use_animate_css()
```
````

Then add the `animated` class and the [desired animation class][animate.css] to the slides you want to animate.
`Out` animations are only applied to slides on exit.

```markdown
---
class: animated slideInRight fadeOutLeft

## This slide...

- slides in from the right 
- and fades out to the left on exit
```

If you want to use the same slide transitions for all slides,
you can use `use_animate_all()`.
This function sets a default in and out animation for all slides. 
Animations can be disabled for individual slides 
by adding the class `.no-animation` to the slide.

````markdown
```{r xaringan-animate, echo=FALSE}
xaringanExtra::use_animate_all("slide_left")
```
````

Note: if you want to use other animation from `animate.css` use both `use_animation()` and `use_animation_default()`.

For use in other HTML documents, 
set `xaringan = FALSE` to disable the performance tweak mentioned above.

## &#x1F3D7; Tachyons

#### &#x1F4FA; [Tachyons Demo](https://gadenbuie.github.io/xaringanExtra/tachyons)

[tachyons]: http://tachyons.io/
[tachyons-docs]: http://tachyons.io/docs/
[tachyons-cheatsheet]: https://roperzh.github.io/tachyons-cheatsheet/

[Tachyons] is a collection of CSS utility classes
that works beautifully with [xaringan] presentations
and the [remarkjs] class syntax.

To use tachyons in your slides,
add the following code chunk to your slides' R Markdown.

````markdown
```{r xaringan-tachyons, echo=FALSE}
xaringanExtra::use_tachyons()
```
````

Tachyons provides small, single-purpose CSS classes that are easily composed to achieve larger functionality and styles.
In the 
[remarkjs content classes syntax](https://github.com/gnab/remark/wiki/Markdown#content-classes),
you can compose classes by chaining them together.
For example, 
the following markdown produces a box with a 
washed green background (`.bg-washed-green`)
and a dark green border (`.b--dark-green`)
on all sides (`.ba`)
with line width 2 (`.bw2`)
and border radius (`.br3`).
The box has a shadow (`.shadow-5`)
and medium-large horizontal padding (`.ph4`)
with a large top margin (`.mt5`).

```markdown
.bg-washed-green.b--dark-green.ba.bw2.br3.shadow-5.ph4.mt5[
The only way to write good code is to write tons of bad code first. 
Feeling shame about bad code stops you from getting to good code

.tr[
— Hadley Wickham
]]
```

![](man/figures/tachyons.png)

Tachyons provides hundreds of CSS classes that are abbreviated and terse,
so it takes some time to learn.
In addition to the [tachyons documentation][tachyons-docs],
the [Tachyons Cheatsheet][tachyons-cheatsheet] is an excellent and easy to use reference.

## &#x1F520; Text Poster

#### &#x1F4FA; [Text Poster Demo](https://gadenbuie.github.io/xaringanExtra/text-poster)

_Text poster_ typesets text to fit within a rectangular bounding box, 
with the text on each line scaled to fit the horizontal space.
Built using [text-poster.js][text-poster].

![](man/figures/text-poster.png)

````markdown
---
class: center middle

`r xaringanExtra::text_poster(
  "There are no 
  routine statistical
  questions, only questionable 
  statistical routines."
)`

.footnote.pull-right[— Sir David Cox]

```{css echo=FALSE}
@import url('https://fonts.googleapis.com/css?family=Merriweather:300');

.text-poster {
	font-family: 'Merriweather', serif;
}
```
````

## &#x1F4D0; Fit to Screen

#### &#x1F4FA; [Fit to Screen Demo](https://gadenbuie.github.io/xaringanExtra/fit-screen)

xaringan/remark slides scale at a consistent ratio when the browser window is resized.
In other words, if the slide ratio is `4:3`, 
then remark scales the slides and positions them in the browser window 
so that they maintain the aspect ratio.

In certain situations, 
like when showing slides in split screen next to another window like RStudio,
this causes the slides to become rather small.
Alternatively,
it's a great way to be able to adapt your slides 
to the aspect ratio of the projector or television screen
when you don't know the ratio ahead of time.

This extension adds a short cut key — <kbd>Alt</kbd>/<kbd>Option</kbd>+ <kbd>F</kbd> —
that fits the slides to the screen and ignores the slide ratio.
(Currently, it only turns on; reload your slides to return to normal.)

![](man/figures/fit-screen.gif)

````markdown
```{r xaringan-fit-screen, echo=FALSE}
xaringanExtra::use_fit_screen()
```
````
