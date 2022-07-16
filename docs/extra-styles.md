## 😎 Extra Styles

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./extra-styles//index.html" title="Extra Styles Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./extra-styles/" target="_blank">Extra Styles Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

### Extra Styles

I’ve collected a few CSS extras that I like to include in my slides,
that I’ve bundled up into the `use_extra_styles()` function.

```` markdown
```{r xaringan-extra-styles}
xaringanExtra::use_extra_styles(
  hover_code_line = TRUE,         #<<
  mute_unhighlighted_code = TRUE  #<<
)
```
````

-   `hover_code_line` adds a little floating triangle next to the
    hovered line in a code chunk

-   `mute_unhighlighted_code` modifies the xaringan/remarkjs line
    highlighting to mute the lines that *aren’t highlighted*.

![](figures/extra-styles-hover.gif)

### Progress Bar

You can also add an animated progress bar using
`xaringanExtra::use_progress_bar()`.

```` markdown
```{r xaringanExtra, echo = FALSE}
xaringanExtra::use_progress_bar(color = "#0051BA", location = "top")
```
````

-   `color` can be any CSS color

-   `location` can be `"top"` or `"bottom"`

-   `height` can be a valid CSS unit, e.g. `10px` or `0.25em`
