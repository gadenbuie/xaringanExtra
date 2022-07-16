class RemarkSearch {
  constructor (options) {
    this.matches = []
    this.currentMatch = -1

    if (options == null) options = {}
    if (options.position == null) options.position = 'bottom-left'
    if (options.caseSensitive == null) options.caseSensitive = false
    if (options.showIcon == null) options.showIcon = true
    if (options.autoSearch == null) options.autoSearch = true

    this.options = options

    this.searchSvg = '<svg version="1.2" baseProfile="tiny" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 50 50" overflow="inherit"><path d="M35.66 29.539c1.661-2.739 2.632-5.948 2.632-9.385 0-10.029-8.115-18.15-18.146-18.154-10.022.003-18.146 8.125-18.146 18.152 0 10.018 8.125 18.139 18.152 18.139 3.44 0 6.645-.972 9.384-2.633l12.343 12.342 6.121-6.124-12.34-12.337zm-15.51 1.841c-6.202-.015-11.216-5.027-11.227-11.216.012-6.202 5.027-11.215 11.227-11.229 6.199.016 11.215 5.028 11.228 11.229-.013 6.182-5.031 11.201-11.228 11.216z"/></svg>'

    this.div = document.createElement('div')
    this.div.classList.add('search')
    this.div.style.zIndex = '9999'
    if (this.options.position.includes('left')) { this.div.innerHTML = '<a id="search-open">' + this.searchSvg + '</a><form><input></form>' } else { this.div.innerHTML = '<form><input></form><a id="search-open">' + this.searchSvg + '</i></a>' }

    const area = document.querySelector('.remark-slides-area')
    area.insertBefore(this.div, area.firstchild)

    this.setUpKeyListener()
    this.setUpForm()
    this.setUpIcons()
    // wait for element to exist because position might depend on its height
    setTimeout(() => this.setUpPosition(), 10)
  }

  static create (options) {
    return new RemarkSearch(options)
  }

  setUpPosition () {
    const self = this
    window.addEventListener('resize', function () {
      self.updatePosition()
    })
    this.updatePosition()
  }

  updatePosition () {
    const scaler = document.querySelector('.remark-visible .remark-slide-scaler')
    const vertical = (document.body.clientHeight - scaler.getBoundingClientRect().height) / 2 + 20
    const horizontal = (document.body.clientWidth - scaler.getBoundingClientRect().width) / 2 + 20

    if (this.options.position.includes('top')) { this.div.style.top = vertical + 'px' } else { this.div.style.top = (document.body.clientHeight - vertical - this.div.getBoundingClientRect().height) + 'px' }

    if (this.options.position.includes('right')) { this.div.style.right = horizontal + 'px' } else { this.div.style.left = horizontal + 'px' }
  }

  setUpIcons () {
    const self = this

    this.div.querySelector('#search-open').addEventListener('click', function (event) {
      self.toggleSearch()
    })

    if (this.options.showIcon) { this.div.classList.add('search-icon-visible') }
  }

  setUpKeyListener () {
    const self = this
    document.addEventListener('keydown', function (event) {
      if (event.ctrlKey && event.key == 'f') {
        event.preventDefault()
        self.openSearch()
        return false
      }

      if (event.key == 'F3' || (event.ctrlKey && event.key.toLowerCase() == 'g')) {
        if (self.matches.length == 0) {
          return self.doSearch(event)
        } else {
          if (event.shiftKey) { return self.showMatch(event, -1) } else { return self.showMatch(event, 1) }
        }
      }
    })

    const input = this.div.querySelector('form input')
    input.addEventListener('keydown', function (event) {
      if (!event.ctrlKey) {
        event.stopPropagation()
      }

      if (event.keyCode == 27) {
        self.closeSearch()
      }
    })
  }

  setUpForm () {
    var self = this

    const form = this.div.querySelector('form')
    form.addEventListener('submit', function (event) {
      if (self.matches.length == 0) {
        return self.doSearch(event)
      } else {
        return self.showMatch(event, 1)
      }
    })
    this.setUpInput()
  }

  setUpInput () {
    const self = this
    const input = this.div.querySelector('form input')
    input.addEventListener('focus', function (event) {
      slideshow.pause()
    })
    input.addEventListener('blur', function (event) {
      slideshow.resume()
    })
    input.addEventListener('input', function (event) {
      self.cleanSearch()
      if (self.options.autoSearch) { self.doSearch() }
    })
  }

  openSearch () {
    const input = this.div.querySelector('form input')

    input.value = ''
    this.cleanSearch()
    this.div.classList.add('search-input-visible')

    input.focus()

    if (!this.options.showIcon) {
      this.updatePosition()
      this.div.classList.add('search-icon-visible')
    }
  }

  toggleSearch () {
    if (this.div.matches('.search-input-visible')) {
      this.closeSearch()
    } else {
      this.openSearch()
    }
  }

  closeSearch () {
    const input = this.div.querySelector('form input')

    input.value = ''
    input.blur()
    this.div.classList.remove('search-input-visible')

    if (!this.options.showIcon) {
      this.div.classList.remove('search-icon-visible')
    }

    this.cleanSearch()
  }

  cleanSearch () {
    this.currentMatch = -1
    this.matches = []

    var context = document.querySelectorAll('.remark-slide')
    var instance = new Mark(context)
    instance.unmark()
  }

  doSearch (event) {
    if (event != null) event.preventDefault()

    const self = this

    const term = this.div.querySelector('form input').value

    this.cleanSearch()

    var context = document.querySelectorAll('.remark-slide')
    var instance = new Mark(context)

    instance.mark(term, {
      element: 'span',
      className: 'match',
      caseSensitive: this.options.caseSensitive,
      separateWordSearch: false,
      each: function (match) {
        self.matches.push(match)
      },
      done: function () {
        if (self.matches.length != 0) { self.showMatch(event, 1) }
      }
    })

    return false
  }

  showMatch (event, delta) {
    if (event != null) event.preventDefault()

    if (this.matches.length == 0) { return this.doSearch(event) }

    const oldMatches = document.querySelectorAll('.current-match')
    for (let i = 0; i < oldMatches.length; i++) { oldMatches[i].classList.remove('current-match') }

    this.currentMatch += delta

    let match = this.matches[this.currentMatch]
    if (match == null) {
      if (delta == -1) { this.currentMatch = this.matches.length } else { this.currentMatch = -1 }
      return this.showMatch(event, delta)
    }
    match.classList.add('current-match')

    while (!match.classList.contains('remark-slide-container')) {
      match = match.parentElement
    };

    let index = 1
    while (match.previousSibling != null) {
      match = match.previousSibling
      index++
    };

    if (slideshow.getCurrentSlideIndex() + 1 != index) { slideshow.gotoSlide(index) }

    return false
  }
}
