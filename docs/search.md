## 🔍 search

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

<table width="100%">
<tr>
<td>
<code>position</code>
</td>
<td>
Where to place the search box.
</td>
</tr>
<tr>
<td>
<code>case\_sensitive</code>
</td>
<td>
If <code>FALSE</code>, ignores case of search and text.
</td>
</tr>
<tr>
<td>
<code>show\_icon</code>
</td>
<td>
Show the icon to open or close the search?
</td>
</tr>
<tr>
<td>
<code>auto\_search</code>
</td>
<td>
Search on each keystroke (<code>TRUE</code>) or on enter
(<code>FALSE</code>)?
</td>
</tr>
</table>

In your slides, press <kbd>Control</kbd> + <kbd>F</kbd> to start
searching, or click on the search icon 🔍 if you set `show_icon = TRUE`.
Press <kbd>Enter</kbd> to jump to the next match.

To change the appearance of the **search** box, use `style_search()`:

```` markdown
```{r xaringanExtra-search-style, echo=FALSE}
xaringanExtra::style_search(match_background = "pink")
```
````

<table width="100%">
<tr>
<td>
<code>icon\_fill</code>
</td>
<td>
Color of search icon
</td>
</tr>
<tr>
<td>
<code>input\_background</code>
</td>
<td>
Color of search input box background
</td>
</tr>
<tr>
<td>
<code>input\_foreground</code>
</td>
<td>
Color of text in search input box
</td>
</tr>
<tr>
<td>
<code>input\_border</code>
</td>
<td>
Border style of search input box
</td>
</tr>
<tr>
<td>
<code>match\_background</code>
</td>
<td>
Color of match background (not current)
</td>
</tr>
<tr>
<td>
<code>match\_foreground</code>
</td>
<td>
Color of match text (not current)
</td>
</tr>
<tr>
<td>
<code>match\_current\_background</code>
</td>
<td>
Color of current match background
</td>
</tr>
<tr>
<td>
<code>match\_current\_foreground</code>
</td>
<td>
Color of current match text
</td>
</tr>
<tr>
<td>
<code>selector</code>
</td>
<td>
CSS selector specifying which search bar to update (for advanced or
unusual uses only)
</td>
</tr>
</table>

