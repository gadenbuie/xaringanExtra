## ⏸️ FreezeFrame

#### 📺 [FreezeFrame Demo](https://pkg.garrickadenbuie.com/xaringanExtra/freezeframe/)

FreezeFrame starts any gifs on a slide when you turn to that slide. This
helps alleviate the awkward pause that can happen when you turn to a
slide with a gif that has already started and you have to wait until it
loops back around. You can also directly click on the gif to stop or
start it. Built using
[freezeframe.js](http://ctrl-freaks.github.io/freezeframe.js/).

To add FreezeFrame to your `xaringan` presentation, add the following
code chunk to your slides' R Markdown file.

```` markdown
```{r xaringanExtra-freezeframe, echo=FALSE}
xaringanExtra::use_freezeframe()
```
````

| Argument   | Description                                                                                                    |
|:-----------|:---------------------------------------------------------------------------------------------------------------|
| selector   | The selector used to search for `.gifs` to freeze.                                                             |
| trigger    | The trigger event to start animation for non-touch devices. One of `"click"` (default), `"hover"` or `"none"`. |
| overlay    | Whether or not to display a play icon on top of the paused image, default: `FALSE`.                            |
| responsive | Whether or not to make the image responsive (100% width), default: `TRUE`.                                     |
| warnings   | Whether or not to issue warnings in the browser console if an image doesn’t appear to be a gif.                |

