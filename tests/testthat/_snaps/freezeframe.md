# freezeframe_options(): returns a string with a <script> tag

    Code
      freezeframe_options()
    Output
      [1] "<script id=\"xaringanExtra-freezeframe-options\" type=\"application/json\">{\"selector\":\"img[src$=\\\"gif\\\"]\",\"trigger\":\"click\",\"overlay\":false,\"responsive\":true,\"warnings\":true}</script>"

---

    Code
      freezeframe_options("img")
    Output
      [1] "<script id=\"xaringanExtra-freezeframe-options\" type=\"application/json\">{\"selector\":\"img\",\"trigger\":\"click\",\"overlay\":false,\"responsive\":true,\"warnings\":true}</script>"

---

    Code
      freezeframe_options(trigger = "none", responsive = FALSE)
    Output
      [1] "<script id=\"xaringanExtra-freezeframe-options\" type=\"application/json\">{\"selector\":\"img[src$=\\\"gif\\\"]\",\"trigger\":false,\"overlay\":false,\"responsive\":false,\"warnings\":true}</script>"

