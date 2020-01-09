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
    [...document.querySelectorAll('.panel-name')]
      .map(el => el.textContent.trim())

    const randId = () => {
      // https://gist.github.com/6174/6062387
      return Math.random().toString(36).substring(2, 8) +
    Math.random().toString(36).substring(2, 8)
    }

    const processPanelItem = (item) => {
      const nameDiv = item.querySelector('.panel-name')
      let name = 'Panel'
      if (nameDiv) {
        name = nameDiv.textContent.trim()
        if (nameDiv.tagName === 'SPAN' && nameDiv.parentNode.tagName === 'P') {
          item.removeChild(nameDiv.parentNode)
        } else {
          item.removeChild(nameDiv)
        }
      }
      return { name, content: item.children, id: randId() }
    }

    const reflowPanelSet = (panels) => {
      const res = document.createElement('div')
      res.className = 'panelset'

      // create header row
      const headerRow = document.createElement('div')
      headerRow.className = 'panel-tabs'
      panels
        .map((p, idx) => {
          const panelHeaderItem = document.createElement('div')
          panelHeaderItem.className = 'panel-tab'
          panelHeaderItem.tabIndex = 0
          panelHeaderItem.classList.toggle('panel-tab-active', idx === 0)
          panelHeaderItem.innerHTML = p.name
          panelHeaderItem.dataset.for = p.id
          return panelHeaderItem
        })
        .forEach(el => headerRow.appendChild(el))

      res.appendChild(headerRow)

      panels
        .map((p, idx) => {
          const panelContent = document.createElement('div')
          panelContent.className = 'panel'
          panelContent.classList.toggle('panel-active', idx === 0)
          panelContent.id = p.id
          Array.from(p.content).forEach(el => panelContent.appendChild(el))
          return panelContent
        })
        .forEach(el => res.appendChild(el))

      return res
    }

    const togglePanel = (clicked) => {
      if (!clicked.classList.contains('panel-tab')) return
      if (clicked.classList.contains('panel-tab-active')) return

      const tabs = clicked.parentNode
        .querySelectorAll('.panel-tab')
      const panels = clicked.parentNode.parentNode
        .querySelectorAll('.panel')

      Array.from(tabs)
        .forEach(t => t.classList.remove('panel-tab-active'))
      Array.from(panels)
        .forEach(p => p.classList.toggle('panel-active', p.id === clicked.dataset.for))

      clicked.classList.add('panel-tab-active')
    }

    const initPanelSet = (panelset) => {
      const panels = Array.from(panelset.querySelectorAll('.panel'))
      const contents = panels.map(processPanelItem)
      const newPanelSet = reflowPanelSet(contents)
      panelset.parentNode.insertBefore(newPanelSet, panelset)
      panelset.parentNode.removeChild(panelset)

      newPanelSet
        .querySelector('.panel-tabs')
        .addEventListener('click', (ev) => togglePanel(ev.target))

      newPanelSet
        .querySelector('.panel-tabs')
        .addEventListener('keydown', (ev) => {
          const self = ev.target
          if (ev.code === 'Space' || ev.code === 'Enter') {
            togglePanel(self)
            ev.stopPropagation()
          } else if (ev.code === 'ArrowLeft' && self.previousSibling) {
            togglePanel(self.previousSibling)
            self.previousSibling.focus()
            ev.stopPropagation()
          } else if (ev.code === 'ArrowRight' && self.nextSibling) {
            togglePanel(self.nextSibling)
            self.nextSibling.focus()
            ev.stopPropagation()
          }
        })
    }

    Array.from(
      document.querySelectorAll('.panelset')
    ).map(initPanelSet)

    if (typeof slideshow !== 'undefined') {
      slideshow.on('afterShowSlide', slide => {
        // clear focus if we had a panel-tab selected
        document.activeElement.blur()

        const slidePanel = document
          .querySelector('.remark-visible .panel-tab-active')

        if (slidePanel) slidePanel.focus()
      })
    }
  })
})()
