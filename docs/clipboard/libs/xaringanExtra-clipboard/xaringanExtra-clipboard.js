/* global slideshow,window,document */
window.xaringanExtraClipboard = function (selector, text) {
  if (!window.ClipboardJS.isSupported()) return
  if (!window.xaringanExtraClipboards) window.xaringanExtraClipboards = {}

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
    const {
      button: buttonText = 'Copy Code',
      success: successText = 'Copied!',
      error: errorText = 'Press Ctrl+C to Copy'
    } = text

    const template = '<button class="xaringanextra-clipboard-button" ' +
       `type="button" aria-label="Copy code to clipboard">${buttonText}</button>`

    const isRemarkSlideshow = typeof slideshow !== 'undefined' &&
      Object.prototype.hasOwnProperty.call(slideshow, 'getSlides')

    let siblingSelector = selector || 'pre'
    if (!selector && isRemarkSlideshow) {
      siblingSelector = '.remark-slides-area ' + siblingSelector
    }

    // insert <button>s
    document.querySelectorAll(siblingSelector).forEach(el => {
      if ([/^$/, 'inherit', 'unset', 'revert', 'static'].some(p => el.style.position.match(p))) {
        el.style.position = 'relative'
      }
      el.insertAdjacentHTML('beforeend', template)

      // match button text color to code color
      const currentColor = window.getComputedStyle(el.children[0]).getPropertyValue('color')
      el.querySelector('button.xaringanextra-clipboard-button').style.color = currentColor
    })

    // initialize cliboardjs
    const clipboard = new window.ClipboardJS(siblingSelector + ' .xaringanextra-clipboard-button', {
      text: function (trigger) {
        // temporarily remove the button text
        // so that it isn't included in the text that's copied
        const btnLabel = trigger.innerHTML
        trigger.innerHTML = ''
        // snapshot text of copy button's parent element
        const text = trigger.parentElement.innerText
        // restore the button's inner HTML
        trigger.innerHTML = btnLabel
        return text
      }
    })

    // show success text for 2.5 seconds on success
    clipboard.on('success', function (ev) {
      ev.trigger.innerHTML = successText
      ev.trigger.style.display = 'block'
      setTimeout(function () {
        ev.trigger.innerHTML = buttonText
        ev.trigger.style.display = ''
      }, 2500)
      ev.clearSelection()
    })

    // show error text for 2.5 seconds on error
    clipboard.on('error', function (ev) {
      ev.trigger.innerHTML = errorText
      setTimeout(function () { ev.trigger.innerHTML = buttonText }, 2500)
    })

    // block remark click/touch slide change event listeners
    if (isRemarkSlideshow) {
      ['touchstart', 'touchend', 'touchmove'].forEach(function (evType) {
        document.querySelector('.remark-slides-area').addEventListener(evType, function (ev) {
          if (!ev.target.closest('pre')) return
          if (ev.target.closest('pre').querySelector('.xaringanextra-clipboard-button')) {
            ev.stopPropagation()
          }
        })
      })
    }

    window.xaringanExtraClipboards[siblingSelector] = clipboard
  })
}
