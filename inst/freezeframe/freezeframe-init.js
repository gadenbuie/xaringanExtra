/* global slideshow,Freezeframe */
document.addEventListener('DOMContentLoaded', function () {
  const optsEl = document.getElementById('xaringanExtra-freezeframe-options')
  const opts = optsEl
             ? JSON.parse(optsEl.innerText)
             : { selector: 'img[src$="gif"]', trigger: 'click', responsive: true }

  if (typeof slideshow !== 'undefined') {
    const slides = Array.from(document.querySelectorAll('.remark-slide-container'))
    const getCurrentSlideIndex = () => slides.findIndex(s => s.matches('.remark-visible'))

    window.xeFreezeframe = slides.map(function (slide) {
      const optsSlide = Object.assign({}, opts)
      optsSlide.selector = slide.querySelectorAll(opts.selector)
      return new Freezeframe(optsSlide)
    })

    slideshow.on('afterShowSlide', function () {
      window.xeFreezeframe.forEach((ff, idx) => {
        idx == getCurrentSlideIndex() ? ff.start() : ff.stop()
      })
    })
  } else {
    window.xeFreezeframe = new Freezeframe(opts)
  }
})
