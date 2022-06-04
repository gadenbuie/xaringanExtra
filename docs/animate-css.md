## 📽 Animate.css

#### 📺 [Animate.css Demo](https://pkg.garrickadenbuie.com/xaringanExtra/animate-css/)

[Animate.css](https://daneden.github.io/animate.css/) is a popular
collection of CSS animations. It contains

> a bunch of cool, fun, and cross-browser animations for you to use in
> your projects. Great for emphasis, home pages, sliders, and general
> just-add-water-awesomeness.

Use `use_animate_css()` to include the animate.css stylesheets in your
slides. This function automatically modifies the CSS selector that
enables the animation so that only the slides that are visible are
animated. This drastically improves performance on large slide decks
with many animations. For use in other HTML documents, set
`xaringan = FALSE` to load the default `animate.css` file without this
performance tweak.

To use animate.css in your slides, add the following code chunk to your
slides’ R Markdown.

```` markdown
```{r xaringan-animate-css, echo=FALSE}
xaringanExtra::use_animate_css()
```
````

Then add the `animated` class and the [desired animation
class](https://daneden.github.io/animate.css/) to the slides you want to
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

