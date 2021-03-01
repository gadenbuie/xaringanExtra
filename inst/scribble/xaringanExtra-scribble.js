/*
 *  Scribble for remark.js/xaringan
 *  Matthew T. Warkentin <warkentin@lunenfeld.ca>
 */

class Scribble {
  constructor(opts) {
    // User options
    this.opts = opts
    this.penColors = opts['pen_color'] || '#000000'
    this.currColor = this.penColors[0]
    this.penSize = opts['pen_size'] || 3
    this.eraserSize = opts['eraser_size'] || 30
    this.tolerance = this.eraserSize / 2
    this.eraserColor = opts['eraser_color'] || 'rgba(0, 0, 0, 0.1)'
    this.transparent = 'rgba(0, 0, 0, 0)'

    // Fabric objects
    this.fabrics
    this.currFabric

    // State objects
    this.mouseDown = false
    this.drawMode = false
    this.eraseMode = false
    this.hideToolbox = false
    this.isPaused = false

    this.eraserCursorMovement = this.eraserCursorMovement.bind(this)
    this.eraser_impl = this.eraser_impl.bind(this)

    // Toolbox objects
    this.launchKey = 83 // "S" used to toggle toolbox/state
    this.toolBox
    this.btnWrapper
    this.colWrapper
    this.drawBtn
    this.eraseBtn
    this.clearBtn
    this.colorPicker
    this.eraserCursor

    // Scribble initialization
    this.addCanvasToAllSlides()
    this.addCanvasHelpText()
    this.assembleToolbox()
    this.addToolboxToSlide()
    this.initEraserCursor()
    this.addToggleToolbox()
    this.resizeContent()

    this.addDrawing()
    this.addClearing()
    this.addErasing()

    // Scribble continuous updating
    slideshow.on('afterShowSlide', (slide) => {
      this.currFabric = this.fabrics[slide.getSlideIndex()]
      this.addToolboxToSlide()
    })
    slideshow.on(
      'beforeHideSlide',
      this.removeTransparentEraserPaths.bind(this),
    )
    window.addEventListener('resize', this.resizeContent.bind(this))
  }

  getVisibleSlide() {
    return document.querySelector('.remark-visible')
  }

  getVisibleSlideSize() {
    const slideSize = this.getVisibleSlide()
      .querySelector('.remark-slide-scaler')
      .getBoundingClientRect()
    return slideSize
  }

  getVisibleSlideScaleRatio() {
    const scaleRatio = this.getVisibleSlide().querySelector(
      '.remark-slide-scaler',
    ).style.transform
    return scaleRatio
  }

  getVisibleSlideCanvas() {
    return this.fabrics[slideshow.getCurrentSlideIndex()]
  }

  getVisibleSlideOuterContainer() {
    const outerDiv = this.getVisibleSlide().querySelector(
      '.xe-scribble.outer-canvas-container',
    )
    return outerDiv
  }

  getVisibleSlideCanvasContainers() {
    const canvasDiv = this.getVisibleSlide().querySelectorAll(
      '.xe-scribble.drawing-canvas',
    )
    return canvasDiv
  }

  createCanvas(id) {
    const slideSize = this.getVisibleSlideSize()

    const canvasDiv = document.createElement('div')
    canvasDiv.classList.add('xe-scribble', 'outer-canvas-container')
    canvasDiv.style.width = slideSize.width
    canvasDiv.style.height = slideSize.height
    canvasDiv.style.left = slideSize.left + 'px'
    canvasDiv.style.top = slideSize.top + 'px'
    ;['mousedown', 'touchstart'].forEach((gesture) => {
      canvasDiv.addEventListener(gesture, this.mousedown.bind(this))
    })
    ;['mouseup', 'touchend'].forEach((gesture) => {
      canvasDiv.addEventListener(gesture, this.mouseup.bind(this))
    })

    const canvas = document.createElement('canvas')
    canvas.setAttribute('id', 'canvas' + id)
    canvas.classList.add('xe-scribble', 'drawing-canvas')
    canvas.setAttribute('width', slideSize.width)
    canvas.setAttribute('height', slideSize.height)

    canvasDiv.appendChild(canvas)

    return canvasDiv
  }

  addCanvasToAllSlides() {
    // Add <canvas> to slide container
    const nslides = slideshow.getSlideCount()
    let i = 0
    const slides = document.getElementsByClassName('remark-slide-container')
    slides.forEach((slide) => {
      if (i + 1 <= nslides) {
        const canvasDiv = this.createCanvas(i)
        slide.appendChild(canvasDiv)
        i += 1
      }
    })

    // Convert <canvas> to fabric.Canvas
    const allCanvases = document.querySelectorAll('.xe-scribble.drawing-canvas')
    this.fabrics = new Array()
    allCanvases.forEach((el, index) => {
      this.fabrics[index] = new fabric.Canvas(el.id, {
        isDrawingMode: false,
        containerClass: 'xe-scribble canvas-container',
      })
    })
    this.currFabric = this.fabrics[0] // set to first slide to start
  }

  resizeContent() {
    const scalerSize = document
      .querySelector('.remark-visible .remark-slide-scaler')
      .getBoundingClientRect()

    // Resize canvas container
    const outerContainers = document.querySelectorAll(
      '.xe-scribble.outer-canvas-container',
    )
    outerContainers.forEach((div) => {
      div.style.width = scalerSize.width + 'px'
      div.style.height = scalerSize.height + 'px'
      div.style.left = scalerSize.left + 'px'
      div.style.top = scalerSize.top + 'px'
    })

    let scaleRatio = parseFloat(
      this.getVisibleSlideScaleRatio().match('\\d+.\\d+'),
    )

    // Resize canvas itself
    this.fabrics.forEach((fab) => {
      fab.setWidth(scalerSize.width)
      fab.setHeight(scalerSize.height)
      fab.setZoom(scaleRatio)
    })
  }

  createButton(id, name) {
    const btn = document.createElement('button')
    btn.classList.add('xe-scribble', 'tool-btn')
    btn.id = id
    btn.innerHTML = this.svgs[name]
    return btn
  }

  createColorPicker() {
    const colorPicker = document.createElement('input')
    colorPicker.setAttribute('id', 'colorPicker')
    colorPicker.classList.add('xe-scribble', 'tool-btn', 'hidden')
    colorPicker.setAttribute('type', 'color')
    colorPicker.setAttribute('value', this.currColor)
    return colorPicker
  }

  createToolbox() {
    this.toolBox = document.createElement('div')
    this.toolBox.id = 'tool-box'
    this.toolBox.classList.add('xe-scribble')

    this.btnWrapper = document.createElement('div')
    this.btnWrapper.id = 'btn-wrapper'
    this.btnWrapper.classList.add('xe-scribble')

    this.colWrapper = document.createElement('div')
    this.colWrapper.id = 'col-wrapper'
    this.colWrapper.classList.add('xe-scribble')
  }

  assembleToolbox() {
    this.createToolbox()

    // Build draw, erase, clear buttons
    this.drawBtn = this.createButton('drawBtn', 'draw')
    this.eraseBtn = this.createButton('eraseBtn', 'eraser')
    this.clearBtn = this.createButton('clearBtn', 'trash')

    this.colorPicker = this.createColorPicker()
    this.colorPicker.addEventListener('input', () => {
      this.currColor = this.colorPicker.value
      this.currFabric.freeDrawingBrush.color = this.currColor
    })
    ;[this.drawBtn, this.eraseBtn, this.clearBtn].forEach((btn) => {
      this.btnWrapper.appendChild(btn)
    })
    this.colWrapper.appendChild(this.colorPicker)
    ;[this.btnWrapper, this.colWrapper].forEach((wrap) => {
      this.toolBox.appendChild(wrap)
    })
  }

  addToolboxToSlide() {
    const canvasDiv = this.getVisibleSlideOuterContainer()
    canvasDiv.appendChild(this.toolBox)
    if (this.hideToolbox) {
      this.toolBox.classList.add('hidden')
    }
  }

  addToggleToolbox() {
    document.addEventListener('keydown', (ev) => {
      if (ev.keyCode === this.launchKey) {
        this.toolBox.classList.toggle('hidden')
        this.hideToolbox = !this.hideToolbox

        // Start draw mode when revealing toolbox
        if (!this.hideToolbox & !this.drawMode) this.drawBtn.click()

        if (this.hideToolbox) {
          this.drawMode
            ? this.drawBtn.click()
            : this.eraseMode
            ? this.eraseBtn.click()
            : null
        }
      }
    })
  }

  addCanvasHelpText() {
    const helpTable = document.querySelector(
      '.remark-help-content table.light-keys',
    )
    if (!helpTable) {
      console.error(
        'Could not find remark help table, has remark been initialized?',
      )
      return
    }
    const newRow = document.createElement('tr')
    newRow.innerHTML += '<td><span class="key">s</span></td>'
    newRow.innerHTML += '<td>Toggle scribble toolbox</td>'
    helpTable.append(newRow)
  }

  mousedown() {
    this.mouseDown = true
  }

  mouseup() {
    this.mouseDown = false
  }

  getCanvasPaths() {
    return this.currFabric.getObjects('path')
  }

  addDrawing() {
    ;['click', 'touchend'].forEach((gesture) => {
      this.drawBtn.addEventListener(gesture, (ev) => {
        ev.preventDefault()
        ev.stopPropagation()
        this.drawMode ? this.stopDrawing() : this.startDrawing()
      })
    })
  }

  startDrawing() {
    slideshow.pause()

    this.drawMode = true
    this.eraseMode = false

    this.currFabric.isDrawingMode = true
    this.currFabric.freeDrawingBrush.width = this.penSize
    this.currFabric.freeDrawingBrush.color = this.currColor
    this.currFabric.freeDrawingCursor = 'crosshair'

    const drawingCanvas = this.getVisibleSlideCanvasContainers()
    drawingCanvas.forEach((container) => {
      container.classList.add('active', 'draw')
    })

    document.removeEventListener('mousemove', this.eraserCursorMovement)
    document.removeEventListener('touchmove', this.eraserCursorMovement)

    this.colorPicker.classList.remove('hidden')
    this.eraserCursor.classList.add('hidden')
    this.drawBtn.querySelector('svg').classList.add('active')
    this.eraseBtn.querySelector('svg').classList.remove('active')
  }

  stopDrawing() {
    slideshow.resume()

    this.drawMode = false
    this.eraseMode = false

    const drawingCanvas = this.getVisibleSlideCanvasContainers()
    drawingCanvas.forEach((container) => {
      container.classList.remove('active', 'draw')
    })

    this.colorPicker.classList.add('hidden')
    this.drawBtn.querySelector('svg').classList.remove('active')
    this.eraseBtn.querySelector('svg').classList.remove('active')
  }

  addClearing() {
    ;['click', 'touchend'].forEach((gesture) => {
      this.clearBtn.addEventListener(gesture, (ev) => {
        ev.preventDefault()
        ev.stopPropagation()
        this.clearCurrentCanvas()
      })
    })
  }

  clearCurrentCanvas() {
    this.currFabric.forEachObject((obj) => {
      this.currFabric.remove(obj)
    })
  }

  addErasing() {
    ;['click', 'touchend'].forEach((gesture) => {
      this.eraseBtn.addEventListener(gesture, (ev) => {
        ev.preventDefault()
        ev.stopPropagation()
        this.eraseMode ? this.stopErasing() : this.startErasing()
      })
    })
  }

  startErasing() {
    slideshow.pause()

    this.eraseMode = true
    this.drawMode = false
    this.eraserCursor.classList.remove('hidden')
    this.colorPicker.classList.add('hidden')

    const outerDiv = this.getVisibleSlideOuterContainer()
    outerDiv.addEventListener('mousemove', this.eraser_impl)
    outerDiv.addEventListener('touchmove', this.eraser_impl)

    document.addEventListener('mousemove', this.eraserCursorMovement)
    document.addEventListener('touchmove', this.eraserCursorMovement)

    this.currFabric.isDrawingMode = true
    this.currFabric.freeDrawingBrush.width = this.tolerance
    this.currFabric.freeDrawingBrush.color = this.transparent
    this.currFabric.freeDrawingCursor = 'none'

    const drawingCanvas = this.getVisibleSlideCanvasContainers()
    drawingCanvas.forEach((container) => {
      container.classList.add('active', 'erase')
    })

    this.drawBtn.querySelector('svg').classList.remove('active')
    this.eraseBtn.querySelector('svg').classList.add('active')
  }

  stopErasing() {
    this.drawMode = false
    this.eraseMode = false
    this.eraserCursor.classList.add('hidden')

    const outerDiv = this.getVisibleSlideOuterContainer()
    outerDiv.removeEventListener('mousemove', this.eraser_impl)
    outerDiv.removeEventListener('touchmove', this.eraser_impl)

    document.removeEventListener('mousemove', this.eraserCursorMovement)
    document.removeEventListener('touchmove', this.eraserCursorMovement)

    slideshow.resume()
    const drawingCanvas = this.getVisibleSlideCanvasContainers()
    drawingCanvas.forEach((container) => {
      container.classList.remove('active', 'erase')
    })

    this.drawBtn.querySelector('svg').classList.remove('active')
    this.eraseBtn.querySelector('svg').classList.remove('active')
  }

  eraser_impl(ev) {
    if (this.mouseDown & this.eraseMode) {
      let xy = [
        this.currFabric.getPointer(ev).x,
        this.currFabric.getPointer(ev).y,
      ]
      let objs = this.getCanvasPaths()
      let paths = objs.map((path) => {
        return path.path
      })

      let remove_or_not = paths.map((path) => {
        const toRemove = path.some((point) => {
          const xcond = Math.abs(point[1] - xy[0]) < this.tolerance
          const ycond = Math.abs(point[2] - xy[1]) < this.tolerance
          const both = xcond & ycond
          return both
        })
        return toRemove
      })

      let currFab = this.currFabric
      objs.map(function (item, index) {
        if (remove_or_not[index]) {
          currFab.remove(item)
        }
      })
    }
  }

  removeTransparentEraserPaths() {
    this.currFabric.forEachObject((obj) => {
      if (obj.stroke === this.transparent) {
        this.currFabric.remove(obj)
      }
    })
  }

  initEraserCursor() {
    const slideArea = document.querySelector('.remark-slides-area')
    this.eraserCursor = document.createElement('div')
    this.eraserCursor.classList.add('xe-scribble', 'eraser-cursor', 'hidden')
    this.eraserCursor.style.width = this.eraserSize + 'px'
    this.eraserCursor.style.height = this.eraserSize + 'px'
    this.eraserCursor.style.backgroundColor = this.eraserColor

    slideArea.appendChild(this.eraserCursor)
  }

  eraserCursorMovement(ev) {
    var pX
    var pY
    if (ev.type === 'mousemove') {
      pX = ev.pageX
      pY = ev.pageY
    } else if (ev.type === 'touchmove') {
      pX = ev.touches[0].pageX
      pY = ev.touches[0].pageY
    }
    this.eraserCursor.style.top = pY - this.tolerance + 'px'
    this.eraserCursor.style.left = pX - this.tolerance + 'px'
  }
}

Scribble.prototype.svgs = {
  draw:
    '<svg viewBox="0 0 576 512"><path d="M402.3 344.9l32-32c5-5 13.7-1.5 13.7 5.7V464c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V112c0-26.5 21.5-48 48-48h273.5c7.1 0 10.7 8.6 5.7 13.7l-32 32c-1.5 1.5-3.5 2.3-5.7 2.3H48v352h352V350.5c0-2.1.8-4.1 2.3-5.6zm156.6-201.8L296.3 405.7l-90.4 10c-26.2 2.9-48.5-19.2-45.6-45.6l10-90.4L432.9 17.1c22.9-22.9 59.9-22.9 82.7 0l43.2 43.2c22.9 22.9 22.9 60 .1 82.8zM460.1 174L402 115.9 216.2 301.8l-7.3 65.3 65.3-7.3L460.1 174zm64.8-79.7l-43.2-43.2c-4.1-4.1-10.8-4.1-14.8 0L436 82l58.1 58.1 30.9-30.9c4-4.2 4-10.8-.1-14.9z"/></svg>',
  eraser:
    '<svg viewBox="0 0 512 512"><path d="M497.941 273.941c18.745-18.745 18.745-49.137 0-67.882l-160-160c-18.745-18.745-49.136-18.746-67.883 0l-256 256c-18.745 18.745-18.745 49.137 0 67.882l96 96A48.004 48.004 0 0 0 144 480h356c6.627 0 12-5.373 12-12v-40c0-6.627-5.373-12-12-12H355.883l142.058-142.059zm-302.627-62.627l137.373 137.373L265.373 416H150.628l-80-80 124.686-124.686z"/></svg>',
  trash:
    '<svg viewBox="0 0 448 512"><path d="M268 416h24a12 12 0 0 0 12-12V188a12 12 0 0 0-12-12h-24a12 12 0 0 0-12 12v216a12 12 0 0 0 12 12zM432 80h-82.41l-34-56.7A48 48 0 0 0 274.41 0H173.59a48 48 0 0 0-41.16 23.3L98.41 80H16A16 16 0 0 0 0 96v16a16 16 0 0 0 16 16h16v336a48 48 0 0 0 48 48h288a48 48 0 0 0 48-48V128h16a16 16 0 0 0 16-16V96a16 16 0 0 0-16-16zM171.84 50.91A6 6 0 0 1 177 48h94a6 6 0 0 1 5.15 2.91L293.61 80H154.39zM368 464H80V128h288zm-212-48h24a12 12 0 0 0 12-12V188a12 12 0 0 0-12-12h-24a12 12 0 0 0-12 12v216a12 12 0 0 0 12 12z"/></svg>',
}
