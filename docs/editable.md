## 📝 Editable

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./editable/index.html" title="Editable Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./editable" target="_blank">Editable Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

Editable gives you a way to write directly inside your slides, updating
your content live. Make any element of your slides editable by using the
`.can-edit[...]` class.

![](figures/editable.gif)

Make your slides editable with the following code chunk.

```` markdown
```{r xaringan-editable, echo=FALSE}
xaringanExtra::use_editable(expires = 1)
```
````

Then, to make a component of your slides editable, use the `.can-edit[]`
class.

``` markdown
## .can-edit[You can edit this slide title]
```

Editable fields that only have the `.can-edit` class are reset whenever
the slides are re-loaded in your browser. If you want to store the
edited values and have them persist across browser sessions, give each
editable field a `.key-<NAME>` class. Be sure to make each key unique
and note that the key name must be a valid CSS class, i.e. it cannot
contain spaces.

``` markdown
## .can-edit.key-firstSlideTitle[Change this title and then reload the page]
```

For more complicated HTML elements, it’s best to make only spans of text
editable, such as

    Hello, .can-edit[world], and welcome to my talk!

or to use placeholder text.

``` markdown
## A few of my favorite things

.can-edit.key-likes[
- thing one
- thing two
]
```

