/* global Cookies */
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

  ready(makeEditable)

  function makeEditable () {
    const docId = JSON.parse(
      document.getElementById('xaringanExtra-editable-docid').textContent
    )
    docId.id = 'editable_' + docId.id

    const blockEvents = ev => ev.stopPropagation()
    const getKey = el => Array.from(el.classList).filter(c => c.match('key'))[0]
    const html2json = el => window.himalaya.parse(el.innerHTML)
    const json2html = json => window.himalaya.stringify(json)

    function storeElement (el) {
      let stored = Cookies.get(docId.id)
      stored = stored ? JSON.parse(stored) : {}
      const key = getKey(el)
      if (!key) return
      stored[key] = html2json(el)
      Cookies.set(docId.id, JSON.stringify(stored), { expires: docId.expires, sameSite: 'None', secure: true })
    }

    function updateElement (el) {
      const key = getKey(el)
      if (!key) return
      let stored = Cookies.get(docId.id)
      if (!stored) return
      stored = JSON.parse(stored)
      if (!Object.keys(stored).includes(key)) return
      el.innerHTML = json2html(stored[key])
    }

    function setIsEditingClass () {
      document.body.classList.add('xe-editable_is-editing')
    }

    function removeIsEditingClass () {
      document.body.classList.remove('xe-editable_is-editing')
    }

    window.editable = {
      clearCookies () {
        Cookies.remove(docId.id)
      },
      clearCookiesAll () {
        Object.keys(Cookies.get())
          .filter(key => key.match(/^editable_/))
          .forEach(key => Cookies.remove(key))
      }
    }

    const editables = document.querySelectorAll('.can-edit')
    if (!editables.length) return

    editables.forEach(el => {
      el.setAttribute('contenteditable', true)
      el.setAttribute('autocomplete', 'off')
      el.setAttribute('autocorrect', 'off')
      el.setAttribute('spellcheck', false)
      updateElement(el)
    })

    editables.forEach(function (el) {
      el.addEventListener('focus', function () {
        if (window.editable.debug) console.log('[editable] blocking shortcuts')
        setIsEditingClass()
        slideshow.pause()
        el.addEventListener('keyup', blockEvents)
        el.addEventListener('keydown', blockEvents)
        el.addEventListener('keypress', blockEvents)
      })
      el.addEventListener('input', function () {
        el.willStore = true
      })
      el.addEventListener('blur', function () {
        if (window.editable.debug) console.log('[editable] unblocking shortcuts')
        slideshow.resume()
        removeIsEditingClass()
        el.removeEventListener('keyup', blockEvents)
        el.removeEventListener('keydown', blockEvents)
        el.removeEventListener('keypress', blockEvents)
        if (el.willStore) {
          el.willStore = false
          if (window.editable.debug) console.log('[editable] storing update html')
          storeElement(el)
        }
      })
    })
  }
})()
