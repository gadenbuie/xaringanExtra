/* global slideshow,Peer,Cookies */
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

  function getBroadcastId () {
    const stored = Cookies.get('broadcast')
    return stored
  }

  function storeBroadcastId (id) {
    Cookies.set('broadcast', id, { expires: 1, sameSite: 'None', secure: true })
  }

  function createBroadcastButton () {
    const elTimer = document.querySelector('.remark-toolbar-timer')
    const btn = document.createElement('button')
    btn.classList = 'remark-toolbar-link remark-toolbar-broadcast'
    btn.id = 'xe-broadcast'
    btn.type = 'button'
    btn.textContent = 'Broadcast'

    elTimer.parentElement.insertBefore(btn, elTimer)

    btn.addEventListener('click', function () {
      initBroadcast(true)
    })
  }

  function removeBroadCastButton () {
    const btn = document.getElementById('xe-broadcast')
    if (btn) btn.parentElement.removeChild(btn)
  }

  function createBroadcastLink () {
    const { pathname, search } = window.location
    const link = document.createElement('a')
    link.classList = 'remark-toolbar-broadcast-link'
    link.href = pathname + search
    link.textContent = 'Broadcast link'

    const elTimer = document.querySelector('.remark-toolbar-timer')
    removeBroadCastButton()
    elTimer.parentElement.insertBefore(link, elTimer)
  }

  window.broadcast = {
    getBroadcastId,
    clearCookies () {
      Cookies.remove('broadcast')
    }
  }

  function initBroadcast (force = false) {
    const params = new URLSearchParams(window.location.search)
    if (!force && params.get('broadcast') === null) {
      createBroadcastButton()
      return
    }

    let broadcastId = getBroadcastId()
    const peerId = params.get('broadcast')

    const isBroadcaster = broadcastId === peerId || peerId === null || peerId === ''

    // Open Peer object
    const peer = new Peer(broadcastId)
    peer.on('open', function (id) {
      console.log(`peerjs connected with id ${id}`)
      if (isBroadcaster) {
        broadcastId = id
        storeBroadcastId(id)
        params.set('broadcast', id)

        // update URL
        const { pathname, hash } = window.location
        const uri = pathname + '?' + params.toString() + hash
        window.history.replaceState(uri, '', uri)
        createBroadcastLink()
      } else {
      // listen for slide changes
        console.log(`peerjs connecting to ${peerId}`)
        const conn = peer.connect(peerId)

        conn.on('open', function () {
          conn.on('data', function (data) {
            // console.log(data)
            slideshow.gotoSlide(data.index + 1)
          })
        })
      }
    })

    if (isBroadcaster) {
    // broadcast slide changes
      peer.on('connection', function (conn) {
        console.log(`New peer connected with id ${conn.peer}`)
        slideshow.on('showSlide', function (slide) {
        // console.log(`sending slide change to ${slide.getSlideIndex()}`)
          conn.send({ index: slide.getSlideIndex() })
        })

        const currentIndex = slideshow.getCurrentSlideIndex()
        // console.log(`sending current slide index ${currentIndex}`)
        setTimeout(function () { conn.send({ index: currentIndex }) }, 500)
      })
    }
  }

  ready(initBroadcast)
})()
