## 💌 Logo

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./logo/index.html" title="Logo Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./logo" target="_blank">Logo Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

`use_logo()` adds a logo to all of your slides. You can make the logo a
clickable link and choose where on the slide it is placed. You can also
set which types of slides will not get the logo by default.

To add a logo to your xaringan presentation, add the following code
chunk to your slides’ R Markdown file.

```` markdown
```{r xaringan-logo, echo=FALSE}
xaringanExtra::use_logo(
  image_url = "https://raw.githubusercontent.com/rstudio/hex-stickers/master/PNG/xaringan.png"
)
```
````

See the documentation for `?use_logo` for more options regarding sizing
and positioning. You can also make the logo a link using `link_url` and
you can hide the logo for a particular slide by using the `hide_logo`
slide class.

