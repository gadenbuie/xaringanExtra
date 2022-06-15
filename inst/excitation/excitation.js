/*
 *  Excitation for remark.js/xaringan
 *  Matthew T. Warkentin <warkentin@lunenfeld.ca>
 *  and Garrick Aden-Buie <garrick@adenbuie.com>
 */
window.addEventListener('DOMContentLoaded', (event) => {
  function htmlDecode (text) {
    const elem = document.createElement('textarea');
    elem.innerHTML = text;
    return elem.value; // decoded
  }

  function getTooltipData (key) {
    const tooltip_data = document.querySelector(`script[data-excitation-key=${key}]`)

    return tooltip_data
      ? JSON.parse(htmlDecode(tooltip_data.textContent))
      : undefined
  }

  let excite_spans = document.querySelectorAll('span.xe-excitation__tooltip')

  excite_spans.forEach((span) => {
    let key = span.getAttribute('data-excitation-key')
    let num_id = span.getAttribute('data-excitation-id')

    const tooltip_data = getTooltipData(key)
    if (!tooltip_data) {
      return
    }

    span.innerHTML = num_id
    tippy(span, {
      content: tooltip_data,
      allowHTML: true,
      hideOnClick: true,
      interactive: true,
      maxWidth: 'none',
      placement: 'auto',
      theme: 'simple',
      trigger: 'click'
    });
  });
});
