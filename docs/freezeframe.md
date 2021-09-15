## ⏸️ FreezeFrame

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./freezeframe/index.html" title="FreezeFrame Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./freezeframe" target="_blank">FreezeFrame Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

FreezeFrame starts any gifs on a slide when you turn to that slide. This
helps alleviate the awkward pause that can happen when you turn to a
slide with a gif that has already started and you have to wait until it
loops back around. You can also directly click on the gif to stop or
start it. Built using
[freezeframe.js](http://ctrl-freaks.github.io/freezeframe.js).

To add FreezeFrame to your `xaringan` presentation, add the following
code chunk to your slides' R Markdown file.

```` markdown
```{r xaringanExtra-freezeframe, echo=FALSE}
xaringanExtra::use_freezeframe()
```
````

| Argument   | Description                                                                                                    |
| :--------- | :------------------------------------------------------------------------------------------------------------- |
| selector   | The selector used to search for `.gifs` to freeze.                                                             |
| trigger    | The trigger event to start animation for non-touch devices. One of `"click"` (default), `"hover"` or `"none"`. |
| overlay    | Whether or not to display a play icon on top of the paused image, default: `FALSE`.                            |
| responsive | Whether or not to make the image responsive (100% width), default: `TRUE`.                                     |
| warnings   | Whether or not to issue warnings in the browser console if an image doesn't appear to be a gif.                |

