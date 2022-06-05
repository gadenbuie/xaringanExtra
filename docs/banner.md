## 📰 Banner

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./banner/index.html" title="Banner Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./banner" target="_blank">Banner Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

`use_banner()` adds a banner to the top or the bottom of your slides.
Use banner to add the title of your talk, a link to your materials
online, or any other text to every slide. Each banner has three columns:
left, center, and right. Choose to `exclude` the banner from particular
slides by class.

```` markdown
```{r xaringan-banner, echo=FALSE}
xaringanExtra::use_banner(
  top_left = "My Awesome Talk Title",
  top_right = "Mr. Fancy Pants",
  bottom_left = "bit.ly/my-awesome-talk",
  exclude = "title-slide"
)
```
````

Banners are fully customizable and can be styled based on slide class,
althought the defaults will generally work in most places. See
`style_banner()` for full details!

