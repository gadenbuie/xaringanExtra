## 📼 Share Again

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./share-again/share-again.html" title="Share Again" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./share-again/share-again.html" target="_blank">Share Again<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

Share your slides in style with *share again*\! It adds a share bar to
your slides that only shows up when they’re embedded in another page.
The bar adds easy slide navigation, quick access to full screen views,
and a share menu for one-click (or tap\!) sharing on social media sites.

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
    
    `embed_xaringan()` works with
    <span style="text-decoration: underline">any</span> xaringan
    presentation, *share again* not required\!
    
    Here’s what your [slides will look
    like](https://gadenbuie.github.io/xaringanExtra/share-again/) in an
    R Markdown HTML document.

