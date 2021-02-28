## 🗂 Panelset

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./panelset/index.html" title="Panelset Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./panelset" target="_blank">Panelset Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

Panelset adds accessible tabbed panels — just like R Markdown’s
`.tabset` panels — to your xaringan slides. You can activate a panel by
clicking on the tab, or you can use the keyboard. When you reach a slide
with a panelset, the left and right arrows will step through the panels.

To use panelset, add the following chunk to your slides.

```` markdown
```{r xaringan-panelset, echo=FALSE}
xaringanExtra::use_panelset()
```
````

![](figures/panelset.gif)

Then, create a `.panelset[...]` that contains `.panel[]`s. Each
`.panel[]` should have a `.panel-name[]` and content (everything that
isn’t the panel’s name).

``` markdown
.panel[.panel-name[NAME]
...content...
]
```

Here’s the example used in the demo slides.

```` markdown
.panelset[
.panel[.panel-name[R Code]

```{r panel-chunk, fig.show='hide'}
# ... r code ...
```
]

.panel[.panel-name[Plot]

![](README_files/figure-gfm/panel-chunk-1.png)
]
]
````

### Use in R Markdown

[Example R Markdown output with
panelset](https://gadenbuie.github.io/xaringanExtra/panelset/rmarkdown.html)

Panelset works in all R Markdown HTML outputs like HTML reports and
[blogdown](https://bookdown.org/yihui/blogdown/) webpages\!

Panelset works in the same way as `rmarkdown`’s
[tabset](https://bookdown.org/yihui/rmarkdown-cookbook/html-tabs.html)
feature, albeit with fewer style options, but the trade-off is that it
works in a wider range of document types; generally, as long as the
output is HTML, panelset should work.

Another advantage of panelset is that it enables deeplinking: the
currently shown tab is encoded in the URL automatically, allowing users
to link to open tabs. Users can also right click on a panel’s tab and
select *Copy Link* to link directly to a specific panel’s tab, which
will appear in view when visiting the copied link.

With standard R Markdown, i.e.
[rmarkdown::html\_document()](https://rmarkdown.rstudio.com/reference/html_document.html),
you can use the following template.

``` markdown
# Panelset In R Markdown! {.panelset}

## Tab One

Amet enim aptent molestie vulputate pharetra
vulputate primis et vivamus semper.

## Tab Two

### Sub heading one

Sit etiam malesuada arcu fusce ullamcorper
interdum proin tincidunt curabitur felis?

## Tab Three

Adipiscing mauris egestas vitae pretium 
ad dignissim dictumst platea!

# Another section

This content won't appear in a panel.
```

In other, less-standard R Markdown HTML formats, you can use pandoc’s
[fenced divs](https://pandoc.org/MANUAL.html#extension-fenced_divs).

``` markdown
::::: {.panelset}

::: {.panel}
[First Tab]{.panel-name}

Lorem sed non habitasse nulla donec egestas magna
enim posuere fames ante diam!
:::

::: {.panel}
[Second Tab]{.panel-name}

Consectetur ligula taciti neque scelerisque gravida
class pharetra netus lobortis quisque mollis iaculis.
:::

:::::
```

Alternatively, you can also use raw HTML.

``` html
<div class="panelset">
  <div class="panel">
    <div class="panel-name">First Tab</div>
    <!-- Panel content -->
    <p>Lorem ipsum, etc, etc</p>
  </div>
  <div class="panel">
    <div class="panel-name">Second Tab</div>
    <!-- Panel content -->
    <p>Lorem ipsum, etc, etc</p>
  </div>
</div>
```

### Customize Panelset Appearnce

To customize the appearance of your panels, you can use
`style_panelset_tabs()` called directly in an R chunk in your slides.

```` markdown
```{r echo=FALSE}
style_panelset_tabs(foreground = "honeydew", background = "seagreen")
```
````

The panelset uses opacity to soften the in-active tabs to increase the
chances that the tabs will work with your slide theme. If you decide to
change your tab colors or to use solid colored tabs, you’ll likely want
to set `inactive_opacity = 1` in `style_panelset()` (or the
corresponding `--panel-tab-inactive-opacity` CSS variable).

Behind the scenes, `style_panelset_tabs()` updates the values of [custom
CSS properties](https://developer.mozilla.org/en-US/Web/CSS/--*)
that define the panelset appearance. If you’d rather work with CSS, the
default values of these properties are shown in the CSS code below. You
can copy the whole CSS block to your slides and modify the values to
customize the style to fit your presentation.

```` markdown
```{css echo=FALSE}
.panelset {
   --panel-tab-foreground: currentColor;
   --panel-tab-background: unset;
   --panel-tab-active-foreground: currentColor;
   --panel-tab-active-background: unset;
   --panel-tab-active-border-color: currentColor;
   --panel-tab-hover-foreground: currentColor;
   --panel-tab-hover-background: unset;
   --panel-tab-hover-border-color: currentColor;
   --panel-tab-inactive-opacity: 0.5;
   --panel-tabs-border-bottom: #ddd;
   --panel-tab-font-family: Menlo, Consolas, Monaco, Liberation Mono, Lucida Console, monospace;
}
```
````

### Panelset knitr Chunks

A common use-case for **panelset** is to show the code and its output in
separate tabs. For example, you might want to first show the code to
create a plot in the first tab, with the plot itself in a second tab. On
slides where space is constrained, this approach can be useful.

To help facilitate this process, **panelset** provides a `panelset`
chunk option. When set to `TRUE`, the code is included in a panel tab
named *Code* and the output is included in a panel tab named *Output*.

```` markdown
```{r panelset = TRUE}
list(
  normal = rnorm(10),
  uniform = runif(10),
  cauchy = rcauchy(10)
)
```
````

You can also set `panelset` to a named vector, where the `source` item
is the tab name for the source code and the `output` item is the tab
name for the code output.

```` markdown
```{r panelset = c(source = "ggplot2", output = "Plot")}
ggplot(Orange) +
  aes(x = age, y = circumference, colour = Tree) +
  geom_point() +
  geom_line() +
  guides(colour = FALSE) +
  theme_bw()
```
````

Note that when your code contains multiple expressions and outputs, you
may also want to set the `results = "hold"` chunk option. Currently,
knitr chunks default to `results = "markup"` and each code expression
and output pair will generate a pair of tabs.

```` markdown
```{r panelset = TRUE, results="hold"}
print("Oak is strong and also gives shade.")
print("The lake sparkled in the red hot sun.")
```
````

Finally, panelset chunks also work in R Markdown documents, but they
must be encapsulated in `<div class="panelset">` and `</div>`:

```` markdown
<div class="panelset">

```{r panelset = TRUE}
print("Oak is strong and also gives shade.")
```

</div>
````

