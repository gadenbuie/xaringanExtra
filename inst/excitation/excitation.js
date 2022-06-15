/*
 *  Excitation for remark.js/xaringan
 *  Matthew T. Warkentin <warkentin@lunenfeld.ca>
 *  and Garrick Aden-Buie <garrick@adenbuie.com>
 */
/* globals tippy */
window.addEventListener('DOMContentLoaded', (event) => {
  function htmlDecode (text) {
    const elem = document.createElement('textarea')
    elem.innerHTML = text
    return elem.value // decoded
  }
  function getTooltipData (key) {
    const tooltipData = document.querySelector(`script[data-excitation-key=${key}]`)

    return tooltipData
      ? JSON.parse(htmlDecode(tooltipData.textContent))
      : undefined
  }

  const exciteSpans = document.querySelectorAll('span.xe-excitation__tooltip')

  exciteSpans.forEach((span) => {
    const citeKey = span.getAttribute('data-excitation-key')
    const citeNum = span.getAttribute('data-excitation-id')

    const tooltipData = getTooltipData(citeKey)
    if (!tooltipData) {
      return
    }

    span.innerHTML = citeNum
    tippy(span, {
      content: tooltipData,
      allowHTML: true,
      hideOnClick: true,
      interactive: true,
      maxWidth: 'none',
      placement: 'auto',
      theme: 'simple',
      trigger: 'click'
    })
  })
})
