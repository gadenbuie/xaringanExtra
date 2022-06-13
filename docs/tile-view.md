## 🗺 Tile View

#### 📺 [Tile View Demo](https://pkg.garrickadenbuie.com/xaringanExtra/tile-view/)

Tile view gives you a way to quickly jump between slides. Just press
<kbd>O</kbd> (the letter **O** for **O**verview) at any point in your
slideshow and the tile view appears. Click on a slide to jump to the
slide, or press <kbd>O</kbd> to exit tile view.

![](figures/tile-view.png)

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

