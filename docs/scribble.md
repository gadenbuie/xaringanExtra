## 👩‍🎨 Scribble

#### 📺 [Scribble Demo](https://pkg.garrickadenbuie.com/xaringanExtra/scribble/)

Scribble lets you draw on your
[xaringan](https://slides.yihui.org/xaringan) slides. Click the *pencil*
icon or press <kbd>S</kbd> to begin drawing. Pressing <kbd>S</kbd> or
starting the drawing mode toggles the scribble toolbox. There, you’ll
find the *eraser* button, which helps you remove lines from your
drawing. Or click the *trash* button to clear the drawings on the
current slide.

```` markdown
```{r xaringan-scribble, echo=FALSE}
xaringanExtra::use_scribble()
```
````

Your drawings stay with each slide when you change slides. Note that you
won’t be able to change slides while you’re in drawing mode. In fact,
you can use the <kbd>←</kbd> and <kbd>→</kbd> keys to **undo** or
**redo** your drawings.

Remember that if you use slide continuations to partially reveal slide
contents, each partial slide is technically a *brand-new* slide as far
as xaringan is concerned. This means that each partial slide will have
it’s own drawing layer and your drawings on one slide won’t carry over
to the next. (But they’ll still be there when you switch back!)

To save a copy of the slide with your drawings, your best option is to
print your presentation from the browser.

