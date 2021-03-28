## 🔍 Search

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./search/index.html" title="Search Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./search" target="_blank">Search Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

Brings [remark.search](https://github.com/arestivo/remark.search) to
xaringan slides! Call `use_search()` to add **search** to your slides
and to choose your options.

```` markdown
```{r xaringanExtra-search, echo=FALSE}
xaringanExtra::use_search(show_icon = TRUE)
```
````

| Parameter        | Description                                                                    |
|:-----------------|:-------------------------------------------------------------------------------|
| `position`       | Where to place the search box.                                                 |
| `case_sensitive` | If <code>FALSE</code>, ignores case of search and text.                        |
| `show_icon`      | Show the icon to open or close the search?                                     |
| `auto_search`    | Search on each keystroke (<code>TRUE</code>) or on enter (<code>FALSE</code>)? |

In your slides, press <kbd>Control</kbd> + <kbd>F</kbd> to start
searching, or click on the search icon 🔍 if you set `show_icon = TRUE`.
Press <kbd>Enter</kbd> to jump to the next match.

To change the appearance of the **search** box, use `style_search()`:

```` markdown
```{r xaringanExtra-search-style, echo=FALSE}
xaringanExtra::style_search(match_background = "pink")
```
````

| Argument                   | Description                                                                            |
|:---------------------------|:---------------------------------------------------------------------------------------|
| `icon_fill`                | Color of search icon                                                                   |
| `input_background`         | Color of search input box background                                                   |
| `input_foreground`         | Color of text in search input box                                                      |
| `input_border`             | Border style of search input box                                                       |
| `match_background`         | Color of match background (not current)                                                |
| `match_foreground`         | Color of match text (not current)                                                      |
| `match_current_background` | Color of current match background                                                      |
| `match_current_foreground` | Color of current match text                                                            |
| `selector`                 | CSS selector specifying which search bar to update (for advanced or unusual uses only) |

