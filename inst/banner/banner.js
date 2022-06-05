class xeBanner {
  constructor (opts) {
    const { position, exclude, ...content } = opts
    this.position = position || 'bottom'
    this.exclude = exclude
    this.content = content
    this.banners = []
    this.addBanner()
  }

  getBanners () {
    return this.banners
  }

  addBanner () {
    const slides = document.querySelectorAll('.remark-slides-area .remark-slide-content')

    slides.forEach(slide => {
      if (this.exclude) {
        for (const excludeClass of this.exclude) {
          if (slide.classList.contains(excludeClass)) {
            return
          }
        }
      }
      slide.style.position = 'relative'

      // add banner
      const banner = this.createBanner()
      if (slide.children.length) {
        slide.insertBefore(banner, slide.firstElementChild)
      } else {
        slide.appendChild(banner)
      }

      this.banners.push(banner)
    })

    return this.banners
  }

  createBanner () {
    const el = document.createElement('div')
    el.classList.add('xe-banner', this.position)

    if (this.banners.length) {
      // hide subsequent banners from assistive technologies so they don't
      // announce the same exact content on every slide
      el.setAttribute('aria-hidden', 'true')
    }

    ;['left', 'center', 'right'].forEach(block => {
      if (!this.content[block]) {
        return
      }
      const blockEl = document.createElement('div')
      blockEl.classList.add(`xe-banner__${block}`)
      blockEl.innerHTML = this.content[block]
      el.appendChild(blockEl)
    })

    return el
  }
}
