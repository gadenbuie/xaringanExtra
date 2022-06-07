## 😎 Extra Styles

#### 📺 [Extra Styles Demo](https://pkg.garrickadenbuie.com/xaringanExtra/extra-styles/)

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
