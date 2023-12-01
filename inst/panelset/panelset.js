/* global slideshow */
;(function () {
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
    ;[...document.querySelectorAll('.panel-name')].map(el =>
      el.textContent.trim()
    )

    const panelIds = {}
    let panelsetIdx = 0
    const panelsetIds = []

    const uniquePanelsetId = id => {
      const panelsetNumber = () => (++panelsetIdx).toString().padStart(3, '0')

      if (typeof id === 'undefined' || id === '') {
        id = 'panelset_' + panelsetNumber()
      } else if (panelsetIds.includes(id)) {
        id = id + '_' + panelsetNumber()
      }

      panelsetIds.push(id)
      return id
    }

    const uniquePanelId = name => {
      name = encodeURIComponent(name.toLowerCase().replace(/[\s]/g, '-'))
      if (Object.keys(panelIds).includes(name)) {
        name += ++panelIds[name]
      } else {
        panelIds[name] = 1
      }
      return name
    }

    const identifyPanelName = item => {
      let name = 'Panel'

      // If the item doesn't have a parent element, then we've already processed
      // it, probably because we're in an Rmd, and it's been removed from the DOM
      if (!item.parentElement) {
        return
      }

      // In R Markdown when header-attrs.js is present, we may have found a
      // section header but the class attributes won't be duplicated on the <hX> tag
      if (
        (item.tagName === 'SECTION' || item.classList.contains('section')) &&
        /^H[1-6]/.test(item.children[0].tagName)
      ) {
        name = item.children[0].textContent
        item.classList.remove('panel-name')
        item.removeChild(item.children[0])
        return name
      }

      const nameDiv = item.querySelector('.panel-name')
      if (!nameDiv) return name

      // In remarkjs the .panel-name span might be in a paragraph tag
      // and if the <p> is empty, we'll remove it
      if (
        nameDiv.tagName === 'SPAN' &&
        nameDiv.parentNode.tagName === 'P' &&
        nameDiv.textContent === nameDiv.parentNode.textContent
      ) {
        name = nameDiv.textContent
        item.removeChild(nameDiv.parentNode)
        return name
      }

      // If none of the above, remove the nameDiv and return the name
      name = nameDiv.textContent
      nameDiv.parentNode.removeChild(nameDiv)
      return name
    }

    function getElementAttributes (el) {
      return {
        classes: Array.from(el.classList)
          .filter(c => !/^level\d$/.test(c))
          .toString(),
        style: el.style.cssText,
        dataset: el.dataset,
      }
    }

    const processPanelItem = item => {
      const name = identifyPanelName(item)
      if (!name) {
        return null
      }
      return {
        name,
        content: item.children,
        id: uniquePanelId(name),
        active:
          item.dataset &&
          ['', 'true'].includes(item.dataset.active?.toLowerCase()),
        ...getElementAttributes(item),
      }
    }

    const getCurrentPanelFromUrl = panelset => {
      const params = new URLSearchParams(window.location.search)
      return params.get(panelset)
    }

    function getInitSelectedPanel (panels, id) {
      const panelIds = panels.map(p => p.id)

      const panelSelectedUrl = getCurrentPanelFromUrl(id)
      if (panelSelectedUrl && panelIds.includes(panelSelectedUrl)) {
        return panelSelectedUrl
      }

      const panelsActive = panels.filter(p => p.active)
      if (panelsActive.length) {
        return panelsActive[0].id
      }

      return panels[0].id
    }

    const reflowPanelSet = (panels, { id, classes, style, dataset }) => {
      const res = document.createElement('div')
      res.classList = 'panelset' + (classes ? ' ' + classes : '')
      res.id = uniquePanelsetId(id)
      res.style.cssText = style
      if (dataset) {
        Object.keys(dataset).forEach(key => {
          res.dataset[key] = dataset[key]
        })
      }

      const panelSelected = getInitSelectedPanel(panels, res.id)

      // create header row
      const headerRow = document.createElement('ul')
      headerRow.className = 'panel-tabs'
      headerRow.setAttribute('role', 'tablist')
      panels
        .map((p, idx) => {
          const thisPanelIsActive = panelSelected === p.id

          const panelHeaderItem = document.createElement('li')
          panelHeaderItem.id = res.id + '_' + p.id // #panelsetid_panelid
          panelHeaderItem.className = 'panel-tab'
          panelHeaderItem.setAttribute('role', 'tab')
          panelHeaderItem.tabIndex = 0
          if (thisPanelIsActive) {
            panelHeaderItem.classList.add('panel-tab-active')
            panelHeaderItem.setAttribute('aria-selected', true)
          }
          if (p.dataset) {
            Object.keys(p.dataset).forEach(key => {
              panelHeaderItem.dataset[key] = p.dataset[key]
            })
          }

          const panelHeaderLink = document.createElement('a')
          panelHeaderLink.href =
            '?' + res.id + '=' + p.id + '#' + panelHeaderItem.id
          panelHeaderLink.setAttribute('onclick', 'return false;')
          panelHeaderLink.tabIndex = -1 // list item is tabable, not link
          panelHeaderLink.innerHTML = p.name
          panelHeaderLink.setAttribute('aria-controls', p.id)

          panelHeaderItem.appendChild(panelHeaderLink)
          return panelHeaderItem
        })
        .forEach(el => headerRow.appendChild(el))

      res.appendChild(headerRow)

      panels
        .map((p, idx) => {
          const thisPanelIsActive = panelSelected === p.id
          const panelContent = document.createElement('section')
          panelContent.classList = p.classes ? 'panel ' + p.classes : 'panel'
          panelContent.style.cssText = p.style
          panelContent.setAttribute('role', 'tabpanel')
          panelContent.classList.toggle('panel-active', thisPanelIsActive)
          panelContent.id = p.id
          panelContent.setAttribute('aria-labelledby', p.id)
          Array.from(p.content).forEach(el => panelContent.appendChild(el))
          return panelContent
        })
        .forEach(el => res.appendChild(el))

      return res
    }

    /*
     * Update selected panel for panelset or delete panelset from query string
     *
     * @param panelset Panelset ID to update in the search params
     * @param panel Panel ID of selected panel in panelset, or null to delete from search params
     * @param params Current params object, or params from window.location.search
     */
    function updateSearchParams (
      panelset,
      panel,
      params = new URLSearchParams(window.location.search)
    ) {
      if (panel) {
        params.set(panelset, panel)
      } else {
        params.delete(panelset)
      }
      return params
    }

    /*
     * Update the URL to match params
     */
    const updateUrl = params => {
      if (typeof params === 'undefined') return
      params = params.toString() ? '?' + params.toString() : ''
      const { pathname, hash } = window.location
      const uri = pathname + params + hash
      window.history.replaceState(uri, '', uri)
    }

    function handleClickedPanel (clicked) {
      const panelset = clicked.closest('.panelset')
      if (!panelset) return

      clicked = clicked.closest('.panel-tab')
      if (!clicked) return

      togglePanel(panelset, clicked)
    }

    function findPanelByName (panelset, name) {
      const matches = Array.from(
        panelset.querySelectorAll(':scope > .panel-tabs > .panel-tab')
      ).filter(p => p.innerText.toLowerCase().trim() === name)

      if (!matches) {
        console.error(
          `No panel with name "${name}" found in panelset ${panelset.id}`,
          { panelset, name }
        )
        return
      }

      if (matches > 1) {
        console.warn(
          `Multiple panels with name "${name}" found in panelset ${panelset.id}`,
          { panelset, name }
        )
      }
      return matches[0]
    }

    function togglePanel (panelset, target, updateGroup = true) {
      // target is a .panel-tab element or a panel name
      if (!(target instanceof window.HTMLElement)) {
        target = findPanelByName(panelset, target)
        if (!target) return
      }

      const tabs = panelset.querySelectorAll(
        ':scope > .panel-tabs > .panel-tab'
      )
      const panels = panelset.querySelectorAll(':scope > .panel')

      const targetPanelId = target.children[0].getAttribute('aria-controls')

      // Set tab state
      Array.from(tabs).forEach(t => {
        t.classList.remove('panel-tab-active')
        t.removeAttribute('aria-selected')
      })

      target.classList.add('panel-tab-active')
      target.setAttribute('aria-selected', true)

      Array.from(panels).forEach(p => {
        if (p.id === targetPanelId) {
          p.classList.add('panel-active')
          p.removeAttribute('tabIndex')
          p.hidden = false
        } else {
          p.classList.remove('panel-active')
          p.setAttribute('tabIndex', -1)
          p.hidden = true
        }
      })

      // emit window resize event to trick html widgets into fitting to the panel width
      window.dispatchEvent(new window.Event('resize'))

      if (updateGroup && panelset.dataset.group) {
        panelset.dispatchEvent(
          new window.CustomEvent('panelset:group', {
            bubbles: true,
            detail: {
              group: panelset.dataset.group,
              panel: target.innerText.toLowerCase().trim(),
            },
          })
        )
      }

      // update query string
      const params = updateSearchParams(panelset.id, targetPanelId)
      updateUrl(params)
    }

    const initPanelSet = panelset => {
      let panels = Array.from(panelset.querySelectorAll(':scope > .panel'))

      const pandocSectionSelector = ':is(section, .section)[class*="level"]'
      if (!panels.length) {
        // we're in tabset-alike R Markdown or Quarto
        const getSectionLevel = el => {
          const levels = [...el.classList].filter(s => s.match(/^level/))
          return levels.length ? levels[0].replace('level', '') : levels
        }

        // {.panelset} applied to a section heading
        let panelsetLevel = getSectionLevel(panelset)

        if (!panelsetLevel.length) {
          // {.panelset} applied as a fenced div around subsections
          const subSections = panelset.querySelectorAll(pandocSectionSelector)
          if (!subSections.length) return

          panelsetLevel = Array.from(subSections)
            .map(getSectionLevel)
            .map(x => parseInt(x))
            .reduce((acc, x) => Math.min(acc, x), Infinity)

          panelsetLevel = +panelsetLevel - 1
        }

        // move children that aren't inside a section up above the panelset
        Array.from(panelset.children).forEach(function (el) {
          if (el.matches(pandocSectionSelector)) return
          panelset.parentElement.insertBefore(el, panelset)
        })

        // panels are all .sections with .level<panelsetLevel + 1>
        const panelLevel = +panelsetLevel + 1
        panels = Array.from(
          panelset.querySelectorAll(`:is(section, .section).level${panelLevel}`)
        )
      }

      if (!panels.length) return

      const contents = panels.map(processPanelItem).filter(o => o !== null)
      const panelsetAttrs = getElementAttributes(panelset)
      const newPanelSet = reflowPanelSet(contents, {
        id: panelset.id,
        ...panelsetAttrs,
      })
      newPanelSet.classList = panelset.classList
      panelset.parentNode.insertBefore(newPanelSet, panelset)
      panelset.parentNode.removeChild(panelset)

      // click and touch events
      const panelTabs = newPanelSet.querySelector('.panel-tabs')
      ;['click', 'touchend'].forEach(eventType => {
        panelTabs.addEventListener(eventType, function (ev) {
          handleClickedPanel(ev.target)
          ev.stopPropagation()
        })
      })
      panelTabs.addEventListener('touchmove', function (ev) {
        ev.preventDefault()
      })

      // key events
      newPanelSet
        .querySelector('.panel-tabs')
        .addEventListener('keydown', ev => {
          const self = ev.currentTarget.querySelector('.panel-tab-active')
          if (ev.code === 'Space' || ev.code === 'Enter') {
            togglePanel(ev.target)
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

      // synchronize with the panelset group
      if (newPanelSet.dataset.group) {
        window.addEventListener('panelset:group', ev => {
          if (ev.target === newPanelSet) return
          if (ev.detail.group !== newPanelSet.dataset.group) return
          togglePanel(newPanelSet, ev.detail.panel, false)
        })
      }

      return panels
    }

    // initialize panels
    document
      .querySelectorAll('[data-panelset="true"]')
      .forEach(el => el.classList.add('panelset'))

    const panelsets = { atomic: [], nested: [] }
    Array.from(document.querySelectorAll('.panelset')).forEach(el => {
      if (el.querySelector('.panelset')) {
        // push nested panelsets to the start of the list (inner -> outer)
        panelsets.nested.unshift(el)
      } else {
        // put panelsets without nested panelsets at the beginning
        panelsets.atomic.push(el)
      }
    })

    // initialize atomic panelsets first, then nested panelsets
    panelsets.atomic.map(initPanelSet)
    panelsets.nested.map(initPanelSet)

    if (typeof slideshow !== 'undefined') {
      const getVisibleActivePanelInfo = () => {
        const slidePanels = document.querySelectorAll(
          '.remark-visible .panel-tab-active'
        )

        if (!slidePanels.length) return null

        return slidePanels.map(panel => {
          return {
            panel,
            panelId: panel.children[0].getAttribute('aria-controls'),
            panelSetId: panel.parentNode.parentNode.id,
          }
        })
      }

      slideshow.on('hideSlide', slide => {
        // clear focus if we had a panel-tab selected
        document.activeElement.blur()

        // clear search query for panelsets in current slide
        const params = [
          ...document.querySelectorAll('.remark-visible .panelset'),
        ].reduce(function (params, panelset) {
          return updateSearchParams(panelset.id, null, params)
        }, new URLSearchParams(window.location.search))

        updateUrl(params)
      })

      slideshow.on('afterShowSlide', slide => {
        const slidePanels = getVisibleActivePanelInfo()

        if (slidePanels) {
          // only first panel gets focus
          slidePanels[0].panel.focus()
          // but still update the url to reflect all active panels
          const params = slidePanels.reduce(function (
            params,
            { panelId, panelSetId }
          ) {
            return updateSearchParams(panelSetId, panelId, params)
          },
          new URLSearchParams(window.location.search))
          updateUrl(params)
        }
      })
    }
  })
})()
