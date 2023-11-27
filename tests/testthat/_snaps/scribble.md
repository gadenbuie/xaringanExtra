# init_scribble(): returns a string with a <script> tag

    Code
      init_scribble()
    Output
      [1] "<script>document.addEventListener('DOMContentLoaded', function() { window.xeScribble = new Scribble({\"pen_color\":[\"#FF0000\"],\"pen_size\":3,\"eraser_size\":30,\"palette\":[]}) })</script>"

---

    Code
      init_scribble("#abc123")
    Output
      [1] "<script>document.addEventListener('DOMContentLoaded', function() { window.xeScribble = new Scribble({\"pen_color\":[\"#abc123\"],\"pen_size\":3,\"eraser_size\":30,\"palette\":[]}) })</script>"

---

    Code
      init_scribble("#FF00FF", pen_size = 4)
    Output
      [1] "<script>document.addEventListener('DOMContentLoaded', function() { window.xeScribble = new Scribble({\"pen_color\":[\"#FF00FF\"],\"pen_size\":4,\"eraser_size\":40,\"palette\":[]}) })</script>"

---

    Code
      init_scribble(pen_size = 4, eraser_size = 33)
    Output
      [1] "<script>document.addEventListener('DOMContentLoaded', function() { window.xeScribble = new Scribble({\"pen_color\":[\"#FF0000\"],\"pen_size\":4,\"eraser_size\":33,\"palette\":[]}) })</script>"

---

    Code
      init_scribble(palette = c("#bada55", "#55adab", "#bada55"))
    Output
      [1] "<script>document.addEventListener('DOMContentLoaded', function() { window.xeScribble = new Scribble({\"pen_color\":[\"#FF0000\"],\"pen_size\":3,\"eraser_size\":30,\"palette\":[\"#bada55\",\"#55adab\",\"#bada55\"]}) })</script>"

