## 📼 Share Again

#### 📺 [Share Again](https://pkg.garrickadenbuie.com/xaringanExtra/share-again/share-again.html)

Share your slides in style with *share again*! It adds a share bar to
your slides that only shows up when they’re embedded in another page.
The bar adds easy slide navigation, quick access to full screen views,
and a share menu for one-click (or tap!) sharing on social media sites.

![](figures/meet-share-again.jpg)

Add share again to your slides in three easy steps.

1.  Add `use_share_again()` to your slides

    ```` markdown
    ```{r share-again, echo=FALSE}
    xaringanExtra::use_share_again()
    ```
    ````

2.  Style your share bar and choose social media sites

    ```` markdown
    ```{r style-share-again, echo=FALSE}
    xaringanExtra::style_share_again(
      share_buttons = c("twitter", "linkedin", "pocket")
    )
    ```
    ````

3.  Embed your slides in
    [blogdown](https://bookdown.org/yihui/blogdown/) or R Markdown
    websites

    ```` markdown
    ```{r embed-xaringan, echo=FALSE}
    xaringanExtra::embed_xaringan(url = "share-again.html", ratio = "4:3")
    ```
    ````

    `embed_xaringan()` works with <span
    style="text-decoration: underline">any</span> xaringan presentation,
    *share again* not required!

    Here’s what your [slides will look
    like](https://pkg.garrickadenbuie.com/xaringanExtra/share-again/) in
    an R Markdown HTML document.

