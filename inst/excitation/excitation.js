/*
 *  Excitation for remark.js/xaringan
 *  Matthew T. Warkentin <warkentin@lunenfeld.ca>
 *  and Garrick Aden-Buie <garrick@adenbuie.com>
 */
window.addEventListener('DOMContentLoaded', (event) => {
  let excite_spans = document.querySelectorAll('span.xe-excitation__tooltip')
  excite_spans.forEach((span) => {
    let key = span.getAttribute('data-excitation-key')
    let num_id = span.getAttribute('data-excitation-id')
    let tooltip_data = document.querySelector(
      `script[data-excitation-key=${key}]`
    )
    span.innerHTML = num_id
    tippy(span, {
      content: tooltip_data.textContent,
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
