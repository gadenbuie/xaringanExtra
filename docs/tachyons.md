## 🏗 Tachyons

#### 📺 [Tachyons Demo](https://pkg.garrickadenbuie.com/xaringanExtra/tachyons/)

[Tachyons](http://tachyons.io/) is a collection of CSS utility classes
that works beautifully with
[xaringan](https://slides.yihui.org/xaringan) presentations and the
[remarkjs](https://remarkjs.com/) class syntax.

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

![](figures/tachyons.png)

Tachyons provides hundreds of CSS classes that are abbreviated and
terse, so it takes some time to learn. In addition to the [tachyons
documentation](http://tachyons.io/), the [Tachyons
Cheatsheet](https://roperzh.github.io/tachyons-cheatsheet/) is an
excellent and easy to use reference.

