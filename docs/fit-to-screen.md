## 📐 Fit to Screen

#### 📺 [Fit to Screen Demo](https://pkg.garrickadenbuie.com/xaringanExtra/fit-screen/)

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

![](figures/fit-screen.gif)

```` markdown
```{r xaringan-fit-screen, echo=FALSE}
xaringanExtra::use_fit_screen()
```
````

