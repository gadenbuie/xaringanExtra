/* Panelset
 * Tab panels for web projects created from markdown with Quarto and R Markdown.
 *
 * https://pkg.garrickadenbuie.com/xaringanExtra/#/panelset
 *
 * Copyright (c) 2019-2024 Garrick Aden-Buie
 *
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 */

/* VERSION: 0.3.0 */

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

    function inRevealjs () {
      return typeof window.Reveal !== 'undefined'
    }

    function inRemarkjs () {
      return typeof window.remark !== 'undefined'
    }

    function inRemarkSlide (el) {
      return inRemarkjs() && el.closest('.remark-slide')
    }

    const panelIds = {}
    let panelsetIdx = 0
    const panelsetIds = []

    /**
     * Generates a unique panelset ID.
     * @param {string} id - The optional ID to be used as a base for the panelset ID.
     * @returns {string} - The generated unique panelset ID.
     */
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

    /**
     * Generates a unique panel ID based on the provided name, by appending an
     * increasing integer to the name to make it unique.
     *
     * @param {string} name - The name to generate the panel ID from.
     * @returns {string} The unique panel ID.
     */
    const uniquePanelId = name => {
      name = encodeURIComponent(name.toLowerCase().replace(/[\s]/g, '-'))
      if (Object.keys(panelIds).includes(name)) {
        name += ++panelIds[name]
      } else {
        panelIds[name] = 1
      }
      return name
    }

    /**
     * Identifies the panel name based on the given item, taking into account
     * the various ways that panel names can be specified in R Markdown, Quarto,
     * or revealjs.
     *
     * @param {HTMLElement} item - The item to identify the panel name from.
     * @returns {string} The identified panel name or undefined if no name can
     * be identified.
     */
    const identifyPanelName = item => {
      let name = 'Panel'

      // If the item doesn't have a parent element, then we've already processed
      // it, probably because we're in an Rmd, and it's been removed from the DOM
      if (!item.parentElement) {
        return
      }

      if (item.matches('.panel')) {
        if (item.dataset.name) return item.dataset.name
        if (item.getAttribute('name')) return item.getAttribute('name')
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
        dataset: el.dataset
      }
    }

    /**
     * Processes an original section of content and prepare data for the content
     * panel the item will become.
     *
     * @param {HTMLElement} item - The panel item to process.
     * @returns {Object|null} - An object containing the panel's name, content,
     * id, active status, and other attributes. Returns null if the panel name
     * cannot be identified.
     */
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
        ...getElementAttributes(item)
      }
    }

    /**
     * Retrieves the current panel from the URL parameters.
     * @param {string} panelsetId - The ID of the panelset.
     * @returns {string|null} - The current panel ID or null if not in the URL.
     */
    const getCurrentPanelFromUrl = panelsetId => {
      const params = new URLSearchParams(window.location.search)
      return params.get(panelsetId)
    }

    /**
     * Returns the initial selected panel ID based on the provided panels and
     * the ID of the corresponding panelset. The active panel is chosen
     * following:
     *
     * 1. If the panselset appears in the URL, use the panel ID from the URL.
     * 2. If there is an active panel, use the ID of the first active panel.
     * 3. Use the ID of the first panel in the array.
     *
     * Note that groups are not considered here. If the panelset is part of a
     * group, the group state will be updated after the initial panelset is
     * created.
     *
     * @param {Array} panels - The array of panel objects.
     * @param {string} panelsetId - The ID of the panelset specified in the URL.
     * @returns {string} - The ID of the initial selected panel.
     */
    function getInitSelectedPanel (panels, panelsetId) {
      const panelIds = panels.map(p => p.id)

      const panelSelectedUrl = getCurrentPanelFromUrl(panelsetId)
      if (panelSelectedUrl && panelIds.includes(panelSelectedUrl)) {
        return panelSelectedUrl
      }

      const panelsActive = panels.filter(p => p.active)
      if (panelsActive.length) {
        return panelsActive[0].id
      }

      return panels[0].id
    }

    /**
     * Creates a panel set element with header tabs and corresponding content
     * sections.
     *
     * @param {Array} panels - An array of panel objects.
     * @param {Object} options - An object containing optional parameters for
     * the panel set.
     * @param {string} options.id - The ID of the panel set element.
     * @param {string} options.classes - Additional CSS classes to be applied to
     * the panel set element.
     * @param {string} options.style - Inline CSS styles to be applied to the
     * panel set element.
     * @param {Object} options.dataset - Custom data attributes to be added to
     * the panel set element.
     * @returns {HTMLElement} - The created panel set element.
     */
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
          if (thisPanelIsActive) {
            panelHeaderItem.tabIndex = 0
          }
          panelHeaderItem.classList.toggle(
            'panel-tab-active',
            thisPanelIsActive
          )
          panelHeaderItem.setAttribute('aria-selected', thisPanelIsActive)

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
          const panelTag = inRevealjs() ? 'div' : 'section'
          const panelContent = document.createElement(panelTag)
          panelContent.classList = p.classes ? 'panel ' + p.classes : 'panel'
          panelContent.style.cssText = p.style
          panelContent.classList.toggle('panel-active', thisPanelIsActive)
          panelContent.id = p.id
          // https://www.w3.org/WAI/ARIA/apg/patterns/tabs/examples/tabs-automatic/
          panelContent.setAttribute('role', 'tabpanel')
          panelContent.setAttribute('aria-labelledby', p.id)
          panelContent.tabIndex = 0
          Array.from(p.content).forEach(el => panelContent.appendChild(el))
          return panelContent
        })
        .forEach(el => res.appendChild(el))

      return res
    }

    /*
     * Update selected panel for panelset or delete panelset from query string
     *
     * @param panelset Panelset ID to update in the search params @param panel
     * Panel ID of selected panel in panelset, or null to delete from search
     * params @param params Current params object, or params from
     * window.location.search
     */

    /**
     * Updates the search parameters with the specified panelset and panel
     * values. If a panel is provided, it sets the panelset and panel in the
     * search parameters. If no panel is provided, it removes the panelset from
     * the search parameters.
     *
     * @param {string} panelsetId - The ID of the panelset.
     * @param {string} [panelId] - The ID of the panel (optional).
     * @param {URLSearchParams} [params=new
     * URLSearchParams(window.location.search)] - The search parameters object
     * (optional).
     * @returns {URLSearchParams} - The updated search parameters object.
     */
    function updateSearchParams (
      panelsetId,
      panelId,
      params = new URLSearchParams(window.location.search)
    ) {
      if (panelId) {
        params.set(panelsetId, panelId)
      } else {
        params.delete(panelsetId)
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

    /**
     * Handles the click event on a panel tab within a panelset.
     * @param {HTMLElement} clicked - The clicked element.
     */
    function handleClickedPanel (clicked) {
      const panelset = clicked.closest('.panelset')
      if (!panelset) return

      clicked = clicked.closest('.panel-tab')
      if (!clicked) return

      togglePanel(panelset, clicked)
    }

    /**
     * Handles keydown events for the `.panel-tabs` element within a panelset.
     * This performs two actions: toggling the panel via space or enter and
     * moving to the next or previous panel via arrow keys, depending on the
     * panelset orientation.
     *
     * @see https://www.w3.org/WAI/ARIA/apg/patterns/tabs/examples/tabs-automatic/
     *
     * @param {HTMLElement} panelset - The panelset element.
     * @param {KeyboardEvent} ev - The keydown event.
     */
    function handlePanelTabsKeydown (panelset, ev) {
      const target = ev.currentTarget.querySelector('.panel-tab-active')

      function stopEvent () {
        ev.preventDefault()
        if (inRemarkjs() || inRevealjs()) {
          ev.stopPropagation()
        }
      }

      if (ev.code === 'Space' || ev.code === 'Enter') {
        togglePanel(panelset, ev.target)
        stopEvent()
        return
      }

      let direction

      if (panelset.getAttribute('aria-orientation') === 'vertical') {
        if (ev.code === 'ArrowUp') direction = 'prev'
        if (ev.code === 'ArrowDown') direction = 'next'
      }

      if (
        inRemarkSlide(panelset) ||
        inRevealjs() ||
        panelset.getAttribute('aria-orientation') === 'horizontal'
      ) {
        if (ev.code === 'ArrowLeft') direction = 'prev'
        if (ev.code === 'ArrowRight') direction = 'next'
      }

      if (!direction) return

      const newActive = toggleSibling(panelset, target, direction)
      if (newActive) stopEvent()
      return newActive
    }

    /**
     * Finds a panel by name within a panelset. `name` is compared with the
     * panel tab text content, case-insensitive and trimmed.
     *
     * @param {HTMLElement} panelset - The panelset element.
     * @param {string} name - The name of the panel tab to find.
     * @returns {HTMLElement|undefined} - The matching panel element, or
     * undefined if not found.
     */
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

    /**
     * Toggles the visibility of a panel in a panelset.
     *
     * @param {HTMLElement} panelset - The panelset element containing the
     * panels.
     * @param {HTMLElement|string} target - The target panel or panel name to
     * toggle.
     * @param {'string'} [update='all'] - The update mode for the
     * panelset. Possible values are 'all', 'group', or 'url'.
     */
    function togglePanel (panelset, target, update = 'all', tabIndex = 0) {
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
        t.setAttribute('aria-selected', false)
        t.removeAttribute('tabindex')
      })

      target.classList.add('panel-tab-active')
      target.setAttribute('aria-selected', true)
      target.tabIndex = tabIndex

      Array.from(panels).forEach(p => {
        const isActive = p.id === targetPanelId
        p.classList.toggle('panel-active', isActive)
        p.hidden = !isActive
      })

      // emit window resize event to trick html widgets into fitting to the panel width
      window.dispatchEvent(new window.Event('resize'))

      if (['all', 'group'].includes(update) && panelset.dataset.group) {
        const group = panelset.dataset.group
        const panel = target.innerText.toLowerCase().trim()

        setStoredPanelGroupState(group, panel)

        panelset.dispatchEvent(
          new window.CustomEvent('panelset:group', {
            bubbles: true,
            detail: { group, panel }
          })
        )
      }

      // update query string
      if (['all', 'url'].includes(update)) {
        const params = updateSearchParams(panelset.id, targetPanelId)
        updateUrl(params)
      }
    }

    /**
     * Toggles the sibling panel in the specified direction.
     *
     * @param {HTMLElement} panelset - The panelset element.
     * @param {HTMLElement} target - The target panel element.
     * @param {"next" | "prev"} [direction="next"] - The direction to toggle the
     * sibling panel. Possible values are "next" and "prev".
     */
    function toggleSibling (panelset, target, direction = 'next') {
      let sibling
      switch (direction) {
        case 'next':
          sibling = target.nextSibling
          break
        case 'prev':
          sibling = target.previousSibling
          break
      }

      if (!sibling) return
      const update = parseInt(target.tabIndex) < 0 ? 'url' : 'all'
      togglePanel(panelset, sibling, update, target.tabIndex)
      sibling.focus()
      return sibling
    }

    /**
     * Initializes a panel set from the original markup into a full panelset.
     * This includes creating the panel tabs, rearranging content, adding event
     * listeners, and synchronizing with a panel set group.
     *
     * @param {HTMLElement} panelset - The `.panelset` element to initialize.
     * @returns {HTMLElement} - The new panelset element.
     */
    const initPanelSet = panelset => {
      let panels = Array.from(panelset.querySelectorAll(':scope > .panel, :scope > .cell > .panel'))

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

      // create content panels
      const contents = panels.map(processPanelItem).filter(o => o !== null)

      // create panelset
      const panelsetAttrs = getElementAttributes(panelset)
      const newPanelSet = reflowPanelSet(contents, {
        id: panelset.id,
        ...panelsetAttrs
      })
      newPanelSet.classList = panelset.classList

      // set orientation
      const isVertical = panelset.matches(
        '.sideways, .vertical, [aria-orientation="vertical"]'
      )
      newPanelSet.setAttribute(
        'aria-orientation',
        isVertical ? 'vertical' : 'horizontal'
      )

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
          handlePanelTabsKeydown(newPanelSet, ev)
        })

      // synchronize with the panelset group
      if (newPanelSet.dataset.group) {
        window.addEventListener('panelset:group', ev => {
          if (ev.target === newPanelSet) return
          if (ev.detail.group !== newPanelSet.dataset.group) return
          togglePanel(newPanelSet, ev.detail.panel, 'url')
        })

        const groupData = getStoredPanelSettings()
        const currentPanelFromUrl = getCurrentPanelFromUrl(newPanelSet.id)

        if (!currentPanelFromUrl && groupData[newPanelSet.dataset.group]) {
          togglePanel(newPanelSet, groupData[newPanelSet.dataset.group], null)
        }
      }

      return newPanelSet
    }

    const localStorageKey = 'panelset-data'

    /**
     * Retrieves or creates the stored panel settings from local storage.
     * @returns {{['string']: 'string'} | {}} The stored panel settings, as an
     * empty object or an object with group names as keys and the currently
     * activated panel names as values.
     */
    function getStoredPanelSettings () {
      const data = window.localStorage.getItem(localStorageKey)
      if (!data) {
        window.localStorage.setItem(localStorageKey, '{}')
        return {}
      }
      if (data) {
        return JSON.parse(data)
      }
    }

    function setStoredPanelSettings (data) {
      window.localStorage.setItem(localStorageKey, JSON.stringify(data))
    }

    /**
     * Sets the stored panel group state in local storage. The group `name` is
     * used as a key and is globally checked across pages in the same domain.
     *
     * @param {string} name - The name of the panel group.
     * @param {any} value - The value to set for the panel group.
     */
    function setStoredPanelGroupState (name, value) {
      const data = getStoredPanelSettings()
      data[name] = value
      setStoredPanelSettings(data)
    }

    // initialize panels
    document
      .querySelectorAll('[data-panelset="true"]')
      .forEach(el => {
        const isCell = el.classList.contains('cell')
        const hasParentPanelset = el.parentElement.classList.contains('panelset')
        if (!isCell || !hasParentPanelset) {
          // We let `data-panelset="true"` create a new panelset, unless it's on
          // a code cell that's already inside a panelset, in which case the
          // panels will be folded into the parent panelset.
          el.classList.add('panelset')
        }
      })

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
    panelsets.atomic.forEach(initPanelSet)
    panelsets.nested.forEach(initPanelSet)

    if (inRemarkjs()) {
      const getVisibleActivePanelInfo = () => {
        const slidePanels = document.querySelectorAll(
          '.remark-visible .panel-tab-active'
        )

        if (!slidePanels.length) return null

        return slidePanels.map(panel => {
          return {
            panel,
            panelId: panel.children[0].getAttribute('aria-controls'),
            panelSetId: panel.parentNode.parentNode.id
          }
        })
      }

      slideshow.on('hideSlide', slide => {
        // clear focus if we had a panel-tab selected
        document.activeElement.blur()

        // clear search query for panelsets in current slide
        const params = [
          ...document.querySelectorAll('.remark-visible .panelset')
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

    if (inRevealjs()) {
      window.Reveal.on('slidechanged', function ({ currentSlide, previousSlide, ...data }) {
        // clear focus from any active panel-tab in the previous slide
        const previousActive = previousSlide.querySelector('.panelset .panel-tab:focus')
        if (previousActive) {
          previousActive.blur()
          previousActive.removeAttribute('tabindex')
        }

        const previousPanelsets = previousSlide.querySelectorAll('.panelset')
        if (previousPanelsets.length) {
          // clear search query for panelsets in previous slide
          const params = [
            ...previousSlide.querySelectorAll('.panelset')
          ].reduce(function (params, panelset) {
            return updateSearchParams(panelset.id, null, params)
          }, new URLSearchParams(window.location.search))

          updateUrl(params)
        }

        const firstPanelset = currentSlide.querySelector('.panelset')
        if (!firstPanelset) return

        const panelIdFromUrl = getCurrentPanelFromUrl(firstPanelset.id)
        const panelFromUrl = !panelIdFromUrl
          ? null
          : firstPanelset
            .querySelector(`[aria-controls="${panelIdFromUrl}"]`)
            ?.parentElement

        const firstPanel = panelIdFromUrl
          ? panelFromUrl
          : firstPanelset.querySelector('.panel-tab-active')

        if (!firstPanel) return
        firstPanel.setAttribute('tabindex', '-1')
        firstPanel.focus()

        // update url for all panels on this slide
        const params = [
          ...currentSlide.querySelectorAll('.panelset')
        ].reduce(function (params, panelset) {
          return updateSearchParams(
            panelset.id,
            panelset.querySelector('.panel-active').id,
            params
          )
        }, new URLSearchParams(window.location.search))

        updateUrl(params)
      })
    }
  })
})()
