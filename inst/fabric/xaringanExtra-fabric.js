/*
 *  Drawing canvas for remark.js/xaringan Slides
 *  Matthew T. Warkentin <warkentin@lunenfeld.ca>
 */

// Global Variables
var mouseDown = false
var fabrics = new Array()
var fabricID
var drawMode = false
var eraseMode = false

window.xaringanExtraFabric = function (opts) {
  // User provided options
  let defaultPenColor = opts['pen_color'][0]
  chosenStrokeColor = defaultPenColor
  let defaultPenSize = parseInt(opts['pen_size'][0])
  let defaultEraserSize = parseInt(opts['eraser_size'][0])
  let defaultEraserColor = opts['eraser_color'][0]
  let tolerance = defaultEraserSize

  document.addEventListener('DOMContentLoaded', function () {
    // Get visible slide
    const getVisibleSlide = function () {
      const visible = document.querySelector('.remark-visible')
      return visible
    }

    // Get visible slide dimensions
    const getVisibleSlideSize = function () {
      const visible = getVisibleSlide()
      const slideSize = visible
        .querySelector('.remark-slide-scaler')
        .getBoundingClientRect()
      return slideSize
    }

    // Get visible slide scaling ratio
    const getVisibleSlideScaleRatio = function () {
      const visible = getVisibleSlide()
      const scaleRatio = visible.querySelector('.remark-slide-scaler').style
        .transform
      return scaleRatio
    }

    // Get visible slide Canvas
    const getVisibleSlideCanvas = function () {
      return fabrics[slideshow.getCurrentSlideIndex()]
    }

    // Get visible slide canvas container div
    const getVisibleSlideOuterContainer = function () {
      const visible = getVisibleSlide()
      const outerDiv = visible.querySelector('.outer-canvas-container')
      return outerDiv
    }

    // Get visible slide canvas container div
    const getVisibleSlideCanvasContainers = function () {
      const visible = getVisibleSlide()
      const canvasDiv = visible.querySelectorAll('.drawing-canvas')
      return canvasDiv
    }

    // Collect all paths on Canvas
    const getCanvasPaths = function () {
      return fabricID.getObjects('path')
    }

    const mousedown = function () {
      mouseDown = true
    }

    // Canvas/canvas container constructor
    const createCanvas = function (id) {
      const slideSize = getVisibleSlideSize()

      const canvasDiv = document.createElement('div')
      canvasDiv.classList.add('outer-canvas-container')
      canvasDiv.style.width = slideSize.width
      canvasDiv.style.height = slideSize.height
      canvasDiv.style.top = slideSize.left + 'px'
      canvasDiv.style.top = slideSize.top + 'px'
      ;['mousedown', 'touchstart'].forEach((gesture) => {
        canvasDiv.addEventListener(gesture, mousedown)
      })
      ;['mouseup', 'touchend'].forEach((gesture) => {
        canvasDiv.addEventListener(gesture, () => {
          mouseDown = false
          setTimeout(function () {
            fabricID.forEachObject((obj) => {
              obj.selectable = false
              if (obj.stroke === defaultEraserColor) {
                fabricID.remove(obj)
              }
            })
          }, 100)
        })
      })

      const canvas = document.createElement('canvas')
      canvas.setAttribute('id', 'canvas' + id)
      canvas.setAttribute('class', 'drawing-canvas')
      canvas.setAttribute('width', slideSize.width)
      canvas.setAttribute('height', slideSize.height)

      canvasDiv.appendChild(canvas)

      return canvasDiv
    }

    // Add canvas to every slide on load
    i = 0
    const slides = document.getElementsByClassName('remark-slide-container')
    slides.forEach((slide) => {
      const canvasDiv = createCanvas(i)
      slide.appendChild(canvasDiv)
      i += 1
    })

    // Coerce canvas to Fabric canvas
    const allCanvases = document.querySelectorAll('.drawing-canvas')
    allCanvases.forEach((el, index) => {
      fabrics[index] = new fabric.Canvas(el.id, {
        isDrawingMode: false,
      })
      fabrics[index].freeDrawingBrush.decimate = 0
      fabrics[index].freeDrawingBrush.width = defaultPenSize
      fabrics[index].freeDrawingBrush.color = chosenStrokeColor
    })
    fabricID = fabrics[0] // set to first slide to start

    // Create toolbox, button div, color picker div
    const toolBox = document.createElement('div')
    toolBox.id = 'tool-box'
    toolBox.style.zIndex = 101 // need to set here to manipulate via JS

    const btnWrapper = document.createElement('div')
    btnWrapper.id = 'btn-wrapper'

    const colWrapper = document.createElement('div')
    colWrapper.id = 'col-wrapper'

    // Inline SVG icons
    const icons = function (icon) {
      var svg
      switch (icon) {
        case 'draw':
          svg =
            '<svg viewBox="0 0 576 512"><path d="M402.3 344.9l32-32c5-5 13.7-1.5 13.7 5.7V464c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V112c0-26.5 21.5-48 48-48h273.5c7.1 0 10.7 8.6 5.7 13.7l-32 32c-1.5 1.5-3.5 2.3-5.7 2.3H48v352h352V350.5c0-2.1.8-4.1 2.3-5.6zm156.6-201.8L296.3 405.7l-90.4 10c-26.2 2.9-48.5-19.2-45.6-45.6l10-90.4L432.9 17.1c22.9-22.9 59.9-22.9 82.7 0l43.2 43.2c22.9 22.9 22.9 60 .1 82.8zM460.1 174L402 115.9 216.2 301.8l-7.3 65.3 65.3-7.3L460.1 174zm64.8-79.7l-43.2-43.2c-4.1-4.1-10.8-4.1-14.8 0L436 82l58.1 58.1 30.9-30.9c4-4.2 4-10.8-.1-14.9z"/></svg>'
          break

        case 'eraser':
          svg =
            '<svg viewBox="0 0 512 512"><path d="M497.941 273.941c18.745-18.745 18.745-49.137 0-67.882l-160-160c-18.745-18.745-49.136-18.746-67.883 0l-256 256c-18.745 18.745-18.745 49.137 0 67.882l96 96A48.004 48.004 0 0 0 144 480h356c6.627 0 12-5.373 12-12v-40c0-6.627-5.373-12-12-12H355.883l142.058-142.059zm-302.627-62.627l137.373 137.373L265.373 416H150.628l-80-80 124.686-124.686z"/></svg>'
          break

        case 'trash':
          svg =
            '<svg viewBox="0 0 448 512"><path d="M268 416h24a12 12 0 0 0 12-12V188a12 12 0 0 0-12-12h-24a12 12 0 0 0-12 12v216a12 12 0 0 0 12 12zM432 80h-82.41l-34-56.7A48 48 0 0 0 274.41 0H173.59a48 48 0 0 0-41.16 23.3L98.41 80H16A16 16 0 0 0 0 96v16a16 16 0 0 0 16 16h16v336a48 48 0 0 0 48 48h288a48 48 0 0 0 48-48V128h16a16 16 0 0 0 16-16V96a16 16 0 0 0-16-16zM171.84 50.91A6 6 0 0 1 177 48h94a6 6 0 0 1 5.15 2.91L293.61 80H154.39zM368 464H80V128h288zm-212-48h24a12 12 0 0 0 12-12V188a12 12 0 0 0-12-12h-24a12 12 0 0 0-12 12v216a12 12 0 0 0 12 12z"/></svg>'
          break
      }
      return svg
    }

    // Button constructor
    const createButton = function (id, name) {
      const btn = document.createElement('button')
      btn.classList.add('tool-btn')
      btn.id = id
      btn.innerHTML = icons(name)
      return btn
    }

    // Build draw, erase, clear buttons
    const drawBtn = createButton('drawBtn', 'draw')
    const eraseBtn = createButton('eraseBtn', 'eraser')
    const clearBtn = createButton('clearBtn', 'trash')

    // Color picker constructor/listeners
    const makeColorPicker = function () {
      let colorPicker = document.createElement('input')
      colorPicker.setAttribute('id', 'colorPicker')
      colorPicker.classList.add('tool-btn', 'hidden')
      colorPicker.setAttribute('type', 'color')
      colorPicker.setAttribute('value', defaultPenColor)
      return colorPicker
    }
    const colorPicker = makeColorPicker()
    colorPicker.addEventListener('input', function () {
      chosenStrokeColor = colorPicker.value
      fabricID.freeDrawingBrush.color = chosenStrokeColor
    })

    // Assemble tool box
    ;[drawBtn, eraseBtn, clearBtn].forEach((btn) => {
      btnWrapper.appendChild(btn)
    })
    colWrapper.appendChild(colorPicker)
    ;[btnWrapper, colWrapper].forEach((btn) => {
      toolBox.appendChild(btn)
    })

    var hideToolbox = false
    const addToolboxToSlide = function () {
      const canvasDiv = getVisibleSlideOuterContainer()
      chosenStrokeColor = defaultPenColor
      colorPicker.value = defaultPenColor
      canvasDiv.appendChild(toolBox)
      if (hideToolbox) {
        toolBox.classList.toggle('hidden', true)
      }
    }
    addToolboxToSlide()

    slideshow.on('afterShowSlide', function (slide) {
      addToolboxToSlide()
      fabricID = fabrics[slide.getSlideIndex()]
    })

    // Resize container and canvas
    function resizeContent() {
      const scalerSize = document
        .querySelector('.remark-visible .remark-slide-scaler')
        .getBoundingClientRect()

      // Resize canvas container
      const outerContainers = document.getElementsByClassName(
        'outer-canvas-container',
      )
      outerContainers.forEach((div) => {
        div.style.width = scalerSize.width + 'px'
        div.style.height = scalerSize.height + 'px'
        div.style.left = scalerSize.left + 'px'
        div.style.top = scalerSize.top + 'px'
      })

      // Resize canvas itself
      fabrics.forEach((canvas) => {
        canvas.setWidth(scalerSize.width)
        canvas.setHeight(scalerSize.height)
      })
    }

    // Update sizes/offsets on window resize
    resizeContent()
    window.addEventListener('resize', resizeContent)

    // Hide/show toolbox
    const launchKey = 68 // "d" used to toggle toolbox viz
    document.addEventListener('keydown', (ev) => {
      if (ev.keyCode === launchKey) {
        toolBox.classList.toggle('hidden')
        hideToolbox = !hideToolbox
      }
    })

    // Add remark help text
    const addCanvasHelpText = () => {
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
      newRow.innerHTML += '<td><span class="key">d</span></td>'
      newRow.innerHTML += '<td>Toggle canvas toolbox</td>'
      helpTable.append(newRow)
    }
    addCanvasHelpText()

    // Drawing
    var isPaused = false
    ;['click', 'touchend'].forEach((gesture) => {
      drawBtn.addEventListener(gesture, (ev) => {
        ev.preventDefault()
        ev.stopPropagation()
        if (!drawMode) {
          drawMode = true
          eraseMode = false

          slideshow.pause()

          fabricID.isDrawingMode = true
          fabricID.freeDrawingBrush.width = defaultPenSize
          fabricID.freeDrawingBrush.color = chosenStrokeColor
          const drawingCanvas = getVisibleSlideCanvasContainers()
          drawingCanvas.forEach((cnt) => {
            cnt.classList.add('active')
          })

          colorPicker.classList.remove('hidden')
          drawBtn.querySelector('svg').classList.add('active')
          eraseBtn.querySelector('svg').classList.remove('active')

          return
        }

        drawMode = false
        eraseMode = false
        slideshow.resume()
        const drawingCanvas = getVisibleSlideCanvasContainers()
        drawingCanvas.forEach((cnt) => {
          cnt.classList.remove('active')
        })

        colorPicker.classList.add('hidden')
        drawBtn.querySelector('svg').classList.remove('active')
        eraseBtn.querySelector('svg').classList.remove('active')
      })
    })

    // Eraser implementation
    const erase_impl = function (ev) {
      if (mouseDown & eraseMode) {
        xy = [fabricID.getPointer(ev).x, fabricID.getPointer(ev).y]
        let objs = getCanvasPaths()
        let paths = objs.map((path) => {
          return path.path
        })

        let remove_or_not = paths.map((path) => {
          const toRemove = path.some((point) => {
            const xcond = Math.abs(point[1] - xy[0]) < tolerance / 2
            const ycond = Math.abs(point[2] - xy[1]) < tolerance / 2
            const both = xcond & ycond
            return both
          })
          return toRemove
        })

        objs.map(function (item, index) {
          if (remove_or_not[index]) {
            fabricID.remove(item)
          }
        })
      }
    }

    // Eraser init
    const eraser = function (ev) {
      colorPicker.classList.add('hidden')

      if (!eraseMode) {
        eraseMode = true
        drawMode = false

        slideshow.pause()

        const outerDiv = getVisibleSlideOuterContainer()
        outerDiv.addEventListener('mousemove', erase_impl)
        outerDiv.addEventListener('touchmove', erase_impl)

        fabricID.isDrawingMode = true
        fabricID.freeDrawingBrush.width = tolerance
        fabricID.freeDrawingBrush.color = defaultEraserColor

        const drawingCanvas = getVisibleSlideCanvasContainers()
        drawingCanvas.forEach((cnt) => {
          cnt.classList.add('active')
        })

        drawBtn.querySelector('svg').classList.remove('active')
        eraseBtn.querySelector('svg').classList.add('active')

        return
      }

      drawMode = false
      eraseMode = false

      slideshow.resume()
      const drawingCanvas = getVisibleSlideCanvasContainers()
      drawingCanvas.forEach((cnt) => {
        cnt.classList.remove('active')
      })

      drawBtn.querySelector('svg').classList.remove('active')
      eraseBtn.querySelector('svg').classList.remove('active')
    }

    ;['click', 'touchend'].forEach((gesture) => {
      eraseBtn.addEventListener(gesture, (ev) => {
        ev.preventDefault()
        ev.stopPropagation()
        eraser(ev)
      })
    })

    // Clear entire canvas
    const clearCanvas = function () {
      fabricID.forEachObject((obj) => {
        fabricID.remove(obj)
      })
    }

    ;['click', 'touchend'].forEach((gesture) => {
      clearBtn.addEventListener(gesture, (ev) => {
        ev.preventDefault()
        ev.stopPropagation()
        clearCanvas()
      })
    })
  })
}
