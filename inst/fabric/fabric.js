/*
 *  Fabric canvas for remark.js Slides
 *
 *  Matthew T. Warkentin
 *
 *  Built using the fabric.js library
 *  https://github.com/fabricjs/fabric.js
 *
 */

document.addEventListener("DOMContentLoaded", function() {
  const launchKey = 68 // keycode for D, used to enable canvas

  const getVisibleSlide = function() {
    const visible  = document.querySelector(".remark-visible")
    return visible
  }

  const getSlideContentDiv = function() {
    const slide = getVisibleSlide()
    const content = slide.querySelector(".remark-slide-content")
    return content
  }

  const getSlideWidth = function() {
    const slide = getVisibleSlide()
    const width = slide.querySelector(".remark-slide-scaler").offsetWidth
    return width
  }

  const getSlideHeight = function() {
    const slide = getVisibleSlide()
    const height = slide.querySelector(".remark-slide-scaler").offsetHeight
    return height
  }

  const createCanvas = function(colEl, strokeEl) {
    cWidth = getSlideWidth()
    cHeight = getSlideHeight()

    const canvas = new fabric.Canvas('canvas', {
      backgroundColor: 'rgba(0, 0, 0, 0)',
      isDrawingMode: true,
      width: cWidth,
      height: cHeight
      });

    canvas.freeDrawingBrush.width  = strokeEl.value
    canvas.freeDrawingBrush.color = colEl.value
    canvas.wrapperEl.style.width = "100%"
    canvas.wrapperEl.style.height = "100%"
    canvas.wrapperEl.style.zIndex = 100
    canvas.wrapperEl.style.position = "absolute"
    canvas.wrapperEl.style.left = 0
    canvas.wrapperEl.style.top = 0
    colEl.onchange = function() {{
      canvas.freeDrawingBrush.color = colEl.value;
    }};
    strokeEl.onchange = function() {{
      canvas.freeDrawingBrush.width = strokeEl.value;
    }};
    return canvas
    }

  const strokeInputs = function() {
    let slider = document.createElement("input")
    slider.setAttribute("class", "stroke-slider")
    slider.setAttribute("type", "range")
    slider.setAttribute("min", "1")
    slider.setAttribute("max", "20")
    slider.setAttribute("step", "1")
    slider.setAttribute("value", "1")
    slider.style.orient = "vertical"
    return slider
  }

  const colourInputs = function() {
    let colors = document.createElement("input")
    colors.setAttribute("class", "color-chooser")
    colors.setAttribute("type", "color")
    colors.setAttribute("value", "#000000")
    return colors
  }

  const isCanvasOnSlide = function() {
    const slide = getVisibleSlide()
    isPresent = slide.querySelector(".canvas-container") !== null
    return isPresent
  }

  const toggleCanvas = function() {
    if (isCanvasOnSlide() === true) {
      const toRemoveCanvas = getSlideContentDiv()
      const inputsToRemove = toRemoveCanvas.querySelectorAll("input")
      const canvasToRemove = toRemoveCanvas.querySelector(".canvas-container")
      toRemoveCanvas.removeChild(canvasToRemove)
      inputsToRemove.forEach(item => {
        toRemoveCanvas.removeChild(item)
      })
    } else {
      const toAddCanvas = getSlideContentDiv()

      // Add colour chooser
      const colourInput = colourInputs()
      toAddCanvas.appendChild(colourInput)

      // Add stroke slider
      const strokeInput = strokeInputs()
      toAddCanvas.appendChild(strokeInput)

      // Draw canvas
      const canvas = createCanvas(colourInput, strokeInput)
      toAddCanvas.appendChild(canvas.wrapperEl)
    }
  }

  const addDrawingHelpText = function() {
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
    newRow.innerHTML += '<td>Toggle fabric canvas</td>'
    helpTable.append(newRow)
  }

  document.addEventListener('keydown', ev => {
    if (ev.keyCode === launchKey) {
      toggleCanvas()
    }
  })

  addDrawingHelpText()
})
