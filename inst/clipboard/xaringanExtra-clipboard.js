(function(window, document) {
	if (!ClipboardJS.isSupported()) return;

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

  function RGBToRGBA(rgb, a = 1) {
  /* Derived from https://css-tricks.com/converting-color-spaces-in-javascript/ */

  if (rgb.includes('rgba')) return rgb

  // Choose correct separator
  let sep = rgb.indexOf(",") > -1 ? "," : " "
  // Turn "rgb(r,g,b)" into [r,g,b]
  rgb = rgb.substr(4).split(")")[0].split(sep).join(',')

  return `rgba(${rgb}, ${a})`
}

  ready(function() {
  	const btnTxt = JSON.parse(document.getElementById('xaringanextra-clipboard-options').textContent)
 		let template = `<button class="xaringanextra-clipboard-button" ` +
 		  `type="button" aria-label="Copy code to clipboard">${btnTxt.button}</button>`

 		let codeSelector = 'pre code:first-child'
 		const isRemarkSlideshow = typeof slideshow !== 'undefined' && slideshow.hasOwnProperty('getSlides')
 		if (isRemarkSlideshow) {
 			codeSelector = '.remark-slides-area ' + codeSelector
 		}

		document.querySelectorAll(codeSelector).forEach(el => {
			el = el.parentNode
		  el.style.position = 'relative'
		  el.insertAdjacentHTML('beforeend', template)

		  // match button text color to code color
		  const codeStyle = window.getComputedStyle(el.querySelector('code'))
		  el.querySelector('button').style.color = codeStyle.getPropertyValue('color')
		})

		document.clipboard = new ClipboardJS('.xaringanextra-clipboard-button', {
			target: function(trigger) {
				return trigger.parentNode.querySelector('code')
			},
			text: function(trigger) {
				return trigger.parentNode.querySelector('code').innerText
			}
		})

		document.clipboard.on('success', function(ev) {
			ev.trigger.innerHTML = btnTxt.success
			setTimeout(function() { ev.trigger.innerHTML = btnTxt.button }, 2500)
			ev.clearSelection()
		})

		document.clipboard.on('error', function(ev) {
			ev.trigger.innerHTML = btnTxt.error
			setTimeout(function() { ev.trigger.innerHTML = btnTxt.button }, 2500)
		})

		// block remark click/touch slide change event listeners
		if (isRemarkSlideshow) {
			function stopClipboardEvent(ev) {
				if (ev.target.classList.contains('xaringanextra-clipboard-button')) {
					ev.stopPropagation()
				}
			}
			// document.querySelector('.remark-slides-area').addEventListener('click', stopClipboardEvent)
			document.querySelector('.remark-slides-area').addEventListener('touchend', stopClipboardEvent)
		}
  })
})(window, document)
