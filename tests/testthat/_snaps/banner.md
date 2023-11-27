# init_banner(): returns a string with a <script> tag

    Code
      init_banner()

---

    Code
      init_banner(left = "bottom left", position = "bottom")
    Output
      <script>document.addEventListener('DOMContentLoaded',function(){new xeBanner(JSON.parse('{"left":"bottom left","position":"bottom"}'))})</script>

---

    Code
      init_banner(right = "top right", position = "top")
    Output
      <script>document.addEventListener('DOMContentLoaded',function(){new xeBanner(JSON.parse('{"right":"top right","position":"top"}'))})</script>

---

    Code
      init_banner(left = "left text", exclude = "title-slide")
    Output
      <script>document.addEventListener('DOMContentLoaded',function(){new xeBanner(JSON.parse('{"left":"left text","exclude":["title-slide"],"position":"bottom"}'))})</script>

---

    Code
      init_banner(center = "center", exclude = c("one", "two"))
    Output
      <script>document.addEventListener('DOMContentLoaded',function(){new xeBanner(JSON.parse('{"center":"center","exclude":["one two"],"position":"bottom"}'))})</script>

# style_banner(): returns style tag

    Code
      paste(x$children[[1]])
    Output
      [1] ":root {\n  --xe-banner-fg: red;\n  --xe-banner-height: 3em;\n}"

# style_banner(): handles width units

    Code
      style_banner(width = "25%")
    Output
      <style>:root {
        --xe-banner-width-left: 25%;
        --xe-banner-width-center: 25%;
        --xe-banner-width-right: 25%;
      }</style>

---

    Code
      style_banner(width = c("100px", "200px"))
    Output
      <style>:root {
        --xe-banner-width-left: 100px;
        --xe-banner-width-center: 200px;
      }</style>

---

    Code
      style_banner(width = c(center = "2em", right = "3em"))
    Output
      <style>:root {
        --xe-banner-width-center: 2em;
        --xe-banner-width-right: 3em;
      }</style>

