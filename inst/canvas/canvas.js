/*
 *  Drawing canvas for remark.js/xaringan Slides
 *  Matthew T. Warkentin <warkentin@lunenfeld.ca>
*/

/*
  * TODO List:
    - Fix resizing/offset issue
*/

window.xaringanExtraCanvas = function (opts) {
  // Global variables
  var cnv
  var ctx
  var offsetTop
  var offsetLeft
  var drawMode
  var mouseDown
  var strokeColor

  // User provided options
  let defaultPenColor = opts["default_color"][0]
  strokeColor = defaultPenColor
  let defaultPenSize = parseInt(opts["pen_size"][0])
  let defaultEraserSize = parseInt(opts["eraser_size"][0])

  document.addEventListener("DOMContentLoaded", function() {

    var startX
    var startY
    // Draw line
    const drawLine = function(ev) {
      const cX = ev.type=="mousemove" ? ev.clientX : ev.touches[0].clientX
      const cY = ev.type=="mousemove" ? ev.clientY : ev.touches[0].clientY

      const currX = Math.round(cX - offsetLeft)
      const currY = Math.round(cY - offsetTop)

      if (mouseDown) {
        ctx.moveTo(startX, startY)
        ctx.lineTo(currX, currY)
        ctx.lineJoin = ctx.lineCap = 'round'
        ctx.stroke()
        startX = currX
        startY = currY
      }
    }
  
    // Initialize line/opts
    const initLine = function(ev) {
      if (drawMode) {
        ctx.globalCompositeOperation = 'source-over';
        ctx.strokeStyle = strokeColor;
        ctx.lineWidth = defaultPenSize;
      } else {
        ctx.globalCompositeOperation = 'destination-out';
        ctx.lineWidth = defaultEraserSize;
      }
      ctx.beginPath()
      ctx.translate(0.5, 0.5) // anti-aliasing recommendation
      
      const sX = ev.type=="mousedown" ? ev.clientX : ev.touches[0].clientX
      const sY = ev.type=="mousedown" ? ev.clientY : ev.touches[0].clientY
      startX = Math.round(sX - offsetLeft)
      startY = Math.round(sY - offsetTop)
      mouseDown = true
    }

    // Stop mouseDown and allow touch slide navigation
    const stopDraw = function(ev) {
      mouseDown = false
      ev.stopPropagation()
    }
    
    // Get visible slide
    const getVisibleSlide = function() {
      const visible = document.querySelector(".remark-visible")
      return visible
    }

    // Get visibile slide content div
    const getVisibleSlideContentDiv = function() {
      const visible = getVisibleSlide()
      const contentDiv = visible.querySelector(".remark-slide-content")
      return contentDiv
    }

    // Get visible slide canvas
    const getVisibleSlideCanvas = function() {
      const visible = getVisibleSlide()
      const cnv = visible.querySelector(".drawing-canvas")
      return cnv
    }

    // Get visible slide dimensions
    const getVisibleSlideSize = function() {
      const visible = getVisibleSlide()
      const width = visible.querySelector(".remark-slide-scaler").offsetWidth
      const height = visible.querySelector(".remark-slide-scaler").offsetHeight
      const slideSize = Array(width, height)
      return slideSize
    }

    // Switch drawMode on dblClick
    const dblClickSwitch = function(ev) {
      if (ev.detail === 2) {
          drawMode = !drawMode
        }
      }

    // Canvas/canvas container constructor
    const createCanvas = function(id) {
      const slideSize = getVisibleSlideSize()

      const canvasDiv = document.createElement("div")
      canvasDiv.classList.add("canvas-container")
      canvasDiv.style.zIndex = -100

      const canvas = document.createElement("canvas")
      canvas.setAttribute("id", "canvas" + id)
      canvas.setAttribute("class", "drawing-canvas")
      canvas.setAttribute("width", slideSize[0])
      canvas.setAttribute("height", slideSize[1])

      canvasDiv.appendChild(canvas)
      return canvasDiv
    }

    // Add canvas to every slide on load
    i = 0
    const slides = document.getElementsByClassName("remark-slide-content")
    slides.forEach(slide => {
      const canvasDiv = createCanvas(i)
      slide.appendChild(canvasDiv)
      i += 1
    })

    // Create toolbox, button div, color picker div
    const toolBox = document.createElement("div")
    toolBox.id = "tool-box"
    toolBox.style.zIndex = 101 // need to set here to manipulate via JS

    const btnWrapper = document.createElement("div")
    btnWrapper.id = "btn-wrapper"

    const colWrapper = document.createElement("div")
    colWrapper.id = "col-wrapper"

    // Button constructor
    const createButton = function(id, cls, icon, color) {
      const btn = document.createElement("button")
      btn.classList.add(cls, "tool-btn")
      btn.id = id
      btn.innerHTML = "<i class='" + icon + "' style='color: " + color + "'></i>"
      return btn
    }

    // Build draw, erase, clear, done, exit buttons
    const drawBtn = createButton("drawBtn", "start-visible", "far fa-edit", "#000000")
    const eraseBtn = createButton("eraseBtn", "start-visible", "fas fa-eraser", "#000000")
    const clearBtn = createButton("clearBtn", "start-visible", "far fa-trash-alt", "#000000")
    const doneBtn = createButton("doneBtn", "start-visible", "far fa-check-circle", "#22B14C")
    const exitBtn = createButton("exitBtn", "start-visible", "far fa-times-circle", "#FF6962")

    // Draw button functionality - Desktop
    drawBtn.addEventListener("click", ev => {
      showHiddenBtns()
      pullCanvasFront()
      drawMode = true
      cnv = getVisibleSlideCanvas()
      ctx = cnv.getContext("2d")

      cnv.addEventListener("click", dblClickSwitch)
      
      cnv.addEventListener("mousedown", initLine)
      cnv.addEventListener("mousemove", drawLine)
      cnv.addEventListener("mouseup", stopDraw)

      isDone = false
      isExit = false
    })

    // Draw button functionality - Touch/Mobile
    drawBtn.addEventListener("touchend", ev => {
      ev.stopPropagation()

      showHiddenBtns()
      pullCanvasFront()
      drawMode = true
      cnv = getVisibleSlideCanvas()
      ctx = cnv.getContext("2d")
      
      cnv.addEventListener("touchstart", initLine)
      cnv.addEventListener("touchmove", drawLine)

      cnv.addEventListener("touchend", stopDraw)

      isDone = false
      isExit = false
    })

    // Erase button functionality
    ;["click", "touchend"].forEach(gesture => {
      eraseBtn.addEventListener(gesture, ev => {
        ev.stopPropagation()
        drawMode = false
      })
    })

    // Clear button functionality
    ;["click", "touchend"].forEach(gesture => {
      clearBtn.addEventListener(gesture, ev => {
        ev.stopPropagation()
        clearCanvas()
      })
    })

    // Done button functionality
    var isDone
    ;["click", "touchend"].forEach(gesture => {
      doneBtn.addEventListener(gesture, ev => {
        ev.stopPropagation()
        hideShownBtn(["color-picker"])
        pullCanvasFront()
        cnv.style.cursor = "auto"

        cnv.removeEventListener("mousedown", initLine)
        cnv.removeEventListener("mousemove", drawLine)
        cnv.removeEventListener("mouseup", stopDraw)
        cnv.removeEventListener("click", dblClickSwitch)

        cnv.removeEventListener("touchstart", initLine)
        cnv.removeEventListener("touchmove", drawLine)
        cnv.removeEventListener("touchend", stopDraw)

        isDone = true
      })
    })

    // Exit button functionality
    var isExit
    ;["click", "touchend"].forEach(gesture => {
      exitBtn.addEventListener(gesture, ev => {
        ev.stopPropagation()
        hideShownBtn(["color-picker"])
        pushCanvasBack()

        cnv.removeEventListener("mousedown", initLine)
        cnv.removeEventListener("mousemove", drawLine)
        cnv.removeEventListener("mouseup", stopDraw)
        cnv.removeEventListener("click", dblClickSwitch)

        cnv.removeEventListener("touchstart", initLine)
        cnv.removeEventListener("touchmove", drawLine)
        cnv.removeEventListener("touchend", stopDraw)

        isExit = true
        isDone = true
      })
    })

    // Color picker constructor/listeners
    const makeColorPicker = function(defCol) {
      let colorPicker = document.createElement("input")
      colorPicker.setAttribute("id", "color-picker")
      colorPicker.classList.add("start-hidden")
      colorPicker.setAttribute("type", "color")
      colorPicker.setAttribute("value", defCol)
      return colorPicker
    }
    const colorPicker = makeColorPicker(defaultPenColor)
    colorPicker.addEventListener("input", function() {
      strokeColor = colorPicker.value
    })
    ;["click", "touchend"].forEach(gesture => {
      colorPicker.addEventListener(gesture, ev => ev.stopPropagation())
    })

    // Assemble tool box
    ;[doneBtn, exitBtn, drawBtn, eraseBtn, clearBtn].forEach(btn => {
      btnWrapper.appendChild(btn)
    })
    colWrapper.appendChild(colorPicker)
    ;[btnWrapper, colWrapper].forEach(btn => {
      toolBox.appendChild(btn)
    })

    // Reveal all hidden buttons
    const showHiddenBtns = function() {
      const btns = document.getElementsByClassName("start-hidden")
      btns.forEach(btn => {
        btn.style.visibility = "visible"
      })
    }

    // Hide specific buttons
    const hideShownBtn = function(btnId) {
      btnId.forEach(id => {
        const btn = document.getElementById(id)
        btn.style.visibility = "hidden"
      })
    }

    // Add toolbox to visible slide when moving slides
    const addToolboxToSlide = function() {
      const visibleContent = getVisibleSlideContentDiv()
      strokeColor = defaultPenColor
      colorPicker.value = defaultPenColor
      visibleContent.appendChild(toolBox)
    }
    slideshow.on("afterShowSlide", addToolboxToSlide)

    // Force "done" drawing when navigating away from drawable slide
    slideshow.on("beforeHideSlide", function() {
      if (!isDone & drawMode) {
        const visible = getVisibleSlide()
        const done = visible.querySelector("#doneBtn")
        done.click()
        isDone = true
      }
    })

    // Pull canvas to front of stack
    const pullCanvasFront = function() {
      const canvas = getVisibleSlideCanvas()
      const canvasDiv = canvas.parentElement
      canvasDiv.style.zIndex = 100
      canvas.style.cursor = "crosshair"
    }

    // Push canvas to back of stack
    const pushCanvasBack = function() {
      const canvas = getVisibleSlideCanvas()
      const canvasDiv = canvas.parentElement
      canvasDiv.style.zIndex = -100
      canvas.style.cursor = "auto"
    }

    // Clear entire canvas
    const clearCanvas = function() {
      ctx.clearRect(0, 0, cnv.offsetWidth, cnv.offsetHeight)
    }

    // Set top/left offsets
    const setOffsets = function() {
      const visible = getVisibleSlideCanvas()
      const bbox = visible.getBoundingClientRect()
      offsetTop = bbox.top
      offsetLeft = bbox.left
    }
    setOffsets()

    // Update canvas/offsets on window resize
    window.addEventListener("resize", ev => {
      const canvasDivs = document.getElementsByClassName(".canvas-container")
      canvasDivs.forEach(div => {
        const canvas = div.querySelector(".drawing-canvas")
        canvas.width = div.clientWidth
        canvas.height = div.clientHeight
      })
      setOffsets()
    })

    // Check if toolbox is already on slide
    const isToolboxOnSlide = function() {
      const visible = getVisibleSlideContentDiv()
      const isOnSlide = visible.querySelector("#tool-box")
      return isOnSlide
    }

    // Hide/show toolbox
    const launchKey = 68 // "d" used to toggle toolbox viz
    document.addEventListener('keydown', ev => {
      if (isToolboxOnSlide() === null) {
        addToolboxToSlide()
        return
      }

      if (ev.keyCode === launchKey) {
        const visible = getVisibleSlide()
        const tBox = visible.querySelector("#tool-box")
        tBox.style.zIndex = -1 * tBox.style.zIndex
      }
    })

    // Add remark help text
    const addCanvasHelpText = () => {
      const helpTable = document.querySelector(
        '.remark-help-content table.light-keys'
      )
      if (!helpTable) {
        console.error(
          'Could not find remark help table, has remark been initialized?'
        )
        return
      }
      const newRow = document.createElement('tr')
      newRow.innerHTML += '<td><span class="key">d</span></td>'
      newRow.innerHTML += '<td>Toggle canvas toolbox</td>'
      helpTable.append(newRow)
    }
    addCanvasHelpText()
  })
}
