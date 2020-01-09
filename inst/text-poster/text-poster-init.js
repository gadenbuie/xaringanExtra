/* global TextPoster */
(function () {
  const ready = function (fn) {
    /* MIT License Copyright (c) 2016 Nuclei */
    /* https://github.com/nuclei/readyjs */
    const completed = () => {
      document.removeEventListener('DOMContentLoaded', completed)
      window.removeEventListener('load', completed)
      fn()
    }
    if (document.readyState !== 'loading') {
      setTimeout(fn)
    } else {
      document.addEventListener('DOMContentLoaded', completed)
      window.addEventListener('load', completed)
    }
  }

  const fitPosterText = function () {
    const pt = document.querySelectorAll('.text-poster__text')
    pt.forEach(el => {
      TextPoster.render(el, el.dataset.text, { maxLineHeight: 0.5 })
    })
  }

  if (!('Promise' in window)) {
    ready(fitPosterText)
  } else {
    document.fonts.ready.then(fitPosterText)
  }
})()
