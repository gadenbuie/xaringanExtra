## 📋 Clipboard

#### 📺 [Clipboard Demo](https://pkg.garrickadenbuie.com/xaringanExtra/clipboard/)

Add a “Copy Code” button for one-click code chunk copying.

To add **clipboard** to your xaringan presentation or R Markdown
document, add the following code chunk to your slides’ R Markdown file.

```` markdown
```{r xaringanExtra-clipboard, echo=FALSE}
xaringanExtra::use_clipboard()
```
````

You can also customize the text that is shown bby default when hovering
over a code chunk with the `button_text` argument. Use `success_text` to
specify the text shown when the copy action works, or `error_text` for
the text shown when the copy action fails. If the copy action fails, the
text will still be selected, so the user can still manually press
`Ctrl+C` to copy the code chunk.

These options accept raw HTML strings, so you can achieve an icon-only
appearance using FontAwesome icons:

```` markdown
```{r xaringanExtra-clipboard, echo=FALSE}
htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i>",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i>",
    error_text = "<i class=\"fa fa-times-circle\" style=\"color: #F94144\"></i>"
  ),
  rmarkdown::html_dependency_font_awesome()
)
```
````

clipboard works in xaringan slides, R Markdown documents, blogdown
sites, and Shiny apps!

**Related projects:** For related R packages that provide copy support
via [clipboard.js](https://clipboardjs.com/) see

-   [RLesur/klippy: Copy to Clipboard Buttons for RMarkdown HTML
    Documents](https://github.com/RLesur/klippy)
-   [sbihorel/rclipboard: clipboard.js for R/Shiny
    Applications](https://github.com/sbihorel/rclipboard)

