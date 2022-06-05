## 📰 Banner

#### 📺 [Banner Demo](https://pkg.garrickadenbuie.com/xaringanExtra/banner/)

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

