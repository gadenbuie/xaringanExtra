/* global slideshow */
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

  ready(function () {
    // set --slide-total CSS property
    document.body.style.setProperty('--slide-total', slideshow.getSlides().length - 1)
    document.body.style.setProperty('--slide-previous', 0)
    document.body.style.setProperty('--slide-current', slideshow.getCurrentSlideIndex())

    document
      .querySelectorAll('.remark-slides-area .remark-slide-content')
      .forEach(function (slide) {
        const pb = document.createElement('div')
        pb.classList = 'xe__progress-bar__container'
        const pbFill = document.createElement('div')
        pbFill.classList = 'xe__progress-bar'
        pb.appendChild(pbFill)
        slide.appendChild(pb)
      })

    // set --slide-current using slide index for where we're headed
    slideshow.on('beforeShowSlide', function (slide) {
      document.body.style.setProperty('--slide-current', slide.getSlideIndex())
    })

    // set --slide-previous from slide we're moving away from
    slideshow.on('beforeHideSlide', function (slide) {
      document.body.style.setProperty('--slide-previous', slide.getSlideIndex())
    })
  })
})()
