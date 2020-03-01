class HackerTyper {
  constructor() {
    this.typers = this.findHackerTypers(document.querySelector('.remark-slides-area'))
    this.typers = this.typers.map(ht => this.prepareHackerTypers(ht))
		this.hasSlideListener = false
		this.visibleSlideRan = false
		this.remarkFixWhiteSpaceClass()
		this.typers.forEach(el => this.addHackerEventListeners(el))
		const styles = document.createElement('style')
		styles.innerHTML = `.hacker-type {
				min-height: 1em;
			}
			.hacker-type.hacker-type-on-click:hover {
				outline: #ddd 1px solid;
			}
			.white-space:first-child {
				display: none;
			}
			.fix-white-space .white-space {
			  white-space: normal;
			}
			.remark-code-line {
				white-space: pre;
			}`
		document.head.appendChild(styles)
  }

  randId() {
		return Date.now().toString(36) + Math.random().toString(36).substr(2, 9);
	}

	findHackerTypers(scope = document) {
	  const containers = scope.querySelectorAll('.hacker-type')
	  if (!containers) return null;
	  return containers
	}

	getHackerTyperById(id) {
		return this.typers.filter(t => t.id === id)[0]
	}

	remarkFixWhiteSpaceClass() {
		let slidesArea = document.querySelectorAll('.remark-slides-area')
		console.log(slidesArea)
		if (!slidesArea.length) return
		slidesArea.forEach(el => el.classList.add('fix-white-space'))
	}

	hackerSpeed(classes) {
		let defaultSpeed = {min: 15, max: 125}
		if (!classes || classes.includes('hacker-type-normal')) {
			return defaultSpeed
		} else if (classes.includes('hacker-type-fast')) {
			return {min: 5, max: 75}
		} else if (classes.includes('hacker-type-slow')) {
			return {min: 75, max: 300}
		}
		return defaultSpeed
	}

	prepareHackerTypers(container) {
		let id = this.randId()
    let text,selector = null
    container.id = id
    // .hacker-type-hide-cursor forces the cursor to be hidden
    // .hacker-type-show-cursor forces cursor to show up
    // default is to show the cursor only if the text container is a <span>
    // because the cursor shows up on a newline otherwise
    let cursor = !container.matches('.hacker-type-hide-cursor') &&
     (container.matches('.hacker-type-show-cursor') ||
      container.tagName === 'SPAN')
    let military = container.matches('.hacker-type-military')
    let hackerClasses = [...container.classList]
      .filter(c => c.match('hacker-type'))
    let speed = this.hackerSpeed(hackerClasses)

    if (
      container.firstChild.tagName === "PRE" &&
      container.firstChild.firstChild.tagName === "CODE"
    ) {
    	// rewrite code chunks so that each line of code appears on its own line
    	// otherwise space is added between lines
      let codeNode = container.querySelector('code')
      text = codeNode.innerHTML
        .toString()
        .replace(/<div/g, '<span')
        .replace(/<\/div>/g, '</span><br>')
        .replace(/<br>$/, '')
      container.querySelector('code').innerHTML = ' '
      selector = 'pre > code'
      cursor = !container.matches('.hacker-type-hide-cursor')
    } else if (container.matches('.remark-slide-content')) {
      // if the slide is .hacker-type then move the
      // .hacker-type div inside the slide
      let newDiv = document.createElement('div')
      newDiv.classList.add('hacker-type')
      newDiv.classList.add('hacker-type-on-show')
      newDiv.id = container.id
      let slideNumber = container.querySelector('.remark-slide-number')
      newDiv.appendChild(slideNumber)
      container
        .querySelectorAll('.remark-code-line:empty')
        .forEach(el => el.innerHTML = "&#x200D;")
      text = container.innerHTML
      container.removeAttribute('id')
      container.innerHTML = ''
      container.appendChild(newDiv)
      container.appendChild(slideNumber)
      // fix white-space property for whole slide
      container.classList.add('fix-white-space')
      // clear
      container.classList.remove('hacker-type')
      container.classList.remove('hacker-type-on-show')
      container.classList.remove('hacker-type-military')
      container = newDiv
      // default to no cursor for full-slide typing
      cursor = false
    } else {
      text = container.innerHTML
      container.innerHTML = ' '
    }
    return {
      container,
      id,
      text: text.trim(),
      event: this.hackerEventType(container),
      selector,
      speed,
      cursor,
      military
    }
	}

	hackerEventType(el) {
	  if (el.matches('[class^="remark-slide"]')) {
	    return 'slide'
	  }
	  if (el.classList.contains('hacker-type-on-click')) {
	    return 'click'
	  }
	  if (el.classList.contains('hacker-type-on-show')) {
	    return 'slide'
	  }
	  return 'slide'
	}

	addHackerEventListeners({container, id, text, event = 'slide', ...ht}) {
		self = this
		function handleHackerClick(event, restart = true) {
		  let elClicked = event.target.closest('.hacker-type')
		  const htIdx = self.typers.findIndex(o => o.id === elClicked.id)
		  let ht = self.typers[htIdx]
		  HackerTyper.runTyper(ht, restart)
		}

		function finishTyper(event) {
		  let elDone = event.target.closest('.hacker-type')
		  const htIdx = self.typers.findIndex(o => o.id === elDone.id)
		  let ht = self.typers[htIdx]
		  HackerTyper.doneTyper(ht)
		}

		function enterSlideTypers() {
			let hts = document.querySelectorAll('.remark-visible .remark-slide-content .hacker-type:not(.hacker-type-on-click)')
	    if (!(hts || hts.length)) return
	    hts.forEach(target => handleHackerClick({target}))
		}

		function exitSlideTypers() {
			let hts = document.querySelectorAll('.remark-visible .remark-slide-content .hacker-type:not(.hacker-type-on-click)')
	    if (!(hts || hts.length)) return
	    hts.forEach(target => handleHackerClick({target}, false))
		}

	  if (event === 'click') {
	    container.addEventListener('click', (event) => {
	      if (event.altKey) {
	        finishTyper(event)
	      } else {
	    		handleHackerClick(event)
	      }
	    })
	  } else if (event === 'slide' && !this.hasSlideListener) {
	    this.hasSlideListener = true
      slideshow.on('afterShowSlide', () => {
        enterSlideTypers()
      })
      slideshow.on('beforeHideSlide', () => {
      	exitSlideTypers()
      })
	  }
	  container.addEventListener('typer-done', finishTyper)
	  if (!this.visibleSlideRan) {
	    this.visibleSlideRan = true
	    enterSlideTypers()
	  }
	}

	static runTyper(ht, restart = true) {
		let container = ht.container
	  if (ht.selector) {
	    container = ht.container.querySelector(ht.selector)
	  }
	  if (
	    typeof container.dataset.hackerState === 'undefined' ||
	    (container.dataset.hackerState === 'done' && restart)
	  ) {
	    container.dataset.hackerState = 'typing'
	    if (ht.typer) {
	      ht.typer.kill()
	      ht.typer = null
	    }
	    ht.typer = typer(container)
	      .empty()
	      .cursor(ht.cursor)
	      .line(ht.text, {
	      	html: true,
	      	min: ht.speed.min,
	      	max: ht.speed.max,
	      	military: ht.military ? {chars: 15, speed: 50} : false
	      })
	      .emit('typer-done', container)
	  } else if (container.dataset.hackerState === 'typing') {
	    ht.typer.halt()
	    container.dataset.hackerState = 'halted'
	  } else if (container.dataset.hackerState === 'halted' && restart) {
	    ht.typer.resume()
	    container.dataset.hackerState = 'typing'
	  }
	}

	static doneTyper(ht) {
		if (ht.typer === null) return
	  let container = ht.container
	  console.log(ht.id + ' stopped')
	  // ht.typer.kill()
	  // ht.typer = null
	  container.dataset.hackerState = 'done'
	}
}

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

  ready(function() {
  	window.hackerTyper = new HackerTyper()
  })
})()
