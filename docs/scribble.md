## 👩‍🎨 Scribble

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./scribble/index.html" title="Scribble Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./scribble" target="_blank">Scribble Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

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

