# init_search(): returns a string with a <script> tag

    Code
      init_search()
    Output
      [1] "<script>window.addEventListener('load', function() { window.xeSearch = new RemarkSearch({\"position\":\"bottom-left\",\"caseSensitive\":false,\"showIcon\":false,\"autoSearch\":true}) })</script>"

---

    Code
      init_search("top-right")
    Output
      [1] "<script>window.addEventListener('load', function() { window.xeSearch = new RemarkSearch({\"position\":\"top-right\",\"caseSensitive\":false,\"showIcon\":false,\"autoSearch\":true}) })</script>"

---

    Code
      init_search(case_sensitive = TRUE)
    Output
      [1] "<script>window.addEventListener('load', function() { window.xeSearch = new RemarkSearch({\"position\":\"bottom-left\",\"caseSensitive\":true,\"showIcon\":false,\"autoSearch\":true}) })</script>"

---

    Code
      init_search(show_icon = TRUE)
    Output
      [1] "<script>window.addEventListener('load', function() { window.xeSearch = new RemarkSearch({\"position\":\"bottom-left\",\"caseSensitive\":false,\"showIcon\":true,\"autoSearch\":true}) })</script>"

---

    Code
      init_search(auto_search = FALSE)
    Output
      [1] "<script>window.addEventListener('load', function() { window.xeSearch = new RemarkSearch({\"position\":\"bottom-left\",\"caseSensitive\":false,\"showIcon\":false,\"autoSearch\":false}) })</script>"

# style_search(): returns style tag

    Code
      paste(x$children[[1]])
    Output
      [1] "\n.search {\n  --search-icon-fill: rgba(128, 128, 128, 0.5);\n  --search-input-background: rgb(204, 204, 204);\n  --search-input-foreground: black;\n  --search-input-border: 1px solid rgb(249, 38, 114);\n  --search-match-background: rgb(38, 220, 249);\n  --search-match-foreground: black;\n  --search-match-current-background: rgb(38, 249, 68);\n  --search-match-current-foreground: black;\n}"

