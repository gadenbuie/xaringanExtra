## 📝 Editable

#### 📺 [Editable Demo](https://pkg.garrickadenbuie.com/xaringanExtra/editable/)

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

