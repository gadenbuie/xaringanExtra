/* global slideshow,Tone */
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
    // Array indicating whether or not each slide is a new slide (1) or an incr. (0)
    const slidesContinued = slideshow
      .getSlides()
      .reduce(
        (acc, slide) => [...acc, slide.properties.continued !== 'true'],
        []
      )

    // Total number of non-continued slides
    // because slideshow.getSlideCount() counts incremental slides
    const nSlides = slidesContinued.reduce(
      (acc, isContinued) => acc + isContinued,
      0
    )

    // Array with tone index for each slide
    const slideToneIndex = slidesContinued
      .reduce(
        (acc, isContinued) => [...acc, acc[acc.length - 1] + isContinued],
        [0]
      )
      .slice(1)

    // To reverse the direction (descending tones) uncomment the line below
    // slideToneIndex = slideToneIndex.map(toneIdx => nSlides - toneIdx);

    /*
     * Ascending tones leading up to C5
     */
    function slideToneScale (i) {
      // https://www.intmath.com/trigonometric-graphs/music.php
      const note = 15 - (nSlides - i)
      return 440 * 2 ** (note / 12)
    }

    /*
     * Sliding tones between C3 and C5 with equal steps between tones
     * but not aligned to musical scale
     */
    function slideToneBounded (i, lower = 261.63, upper = 1046.5) {
      const step = (upper - lower) / nSlides
      return lower + step * i
    }

    /*
     * Choose slide tone scale automatically based on number of slides.
     * If there are <= 32 slides, use musical scale.
     */
    function slideToneAuto (i) {
      const toneIdx = slideToneIndex[i]
      return nSlides > 32 ? slideToneBounded(toneIdx) : slideToneScale(toneIdx)
    }

    const synth = new Tone.Synth({
      oscillator: {
        type: 'sine'
      },
      envelope: {
        attack: 0.001,
        decay: 0.2,
        sustain: 0.2,
        release: 1
      }
    }).toMaster()

    slideshow.on('showSlide', slide => {
      const slideIdx = slide.getSlideIndex()
      synth.triggerAttackRelease(slideToneAuto(slideIdx), '8n')
    })
  })
})()
