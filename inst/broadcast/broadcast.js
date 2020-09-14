/* global slideshow,Peer,Cookies,toast */
class BroadcastSlides {
  constructor (expires = 4 / 24) {
    this.expires = expires

    this.params = new URLSearchParams(window.location.search)

    // This is the Peer ID for the current slide viewer
    this.broadcastShareId = this.getBroadcastShareId()
    // This is the Peer ID of the slides we want to follow
    this.broadcastFollowId = this.params.get('broadcast')

    if (this.broadcastFollowId === '1') {
      // Reset broadcast ID if ?broadcast=1
      BroadcastSlides.clearCookies()
      this.broadcastShareId = null
      this.broadcastFollowId = null
    }

    this.isLive = false
    // sharing will go live immediately, start sharing or following
    const goLive = !(this.broadcastFollowId === null || this.broadcastFollowId === '')

    // we're the broadcaster (or could broadcast)
    this.isBroadcaster = this.broadcastShareId === this.broadcastFollowId || !(goLive)
    document.body.classList.add('broadcast__' + (this.isBroadcaster ? 'broadcaster' : 'follower'))

    this.connections = 0
    this.broadcastLink = null

    if (this.broadcastFollowId === null) {
      // slides loaded with  ?broadcast=1 or out ?broadcast flag
      this.createBroadcastButton()
    }

    if (goLive) {
      this.isBroadcaster ? this.startSharing() : this.startFollowing()
    }
  }

  connectPeerjs () {
    this.peer = new Peer(this.broadcastShareId)
  }

  startSharing () {
    this.connectPeerjs()
    const self = this
    this.peer.on('open', function (id) {
      console.log(`peerjs connected with id ${id}`)
      self.isLive = true
      document.body.classList.add('broadcast__is-live')
      toast.success('Broadcast Started!')

      self.broadcastShareId = id
      self.storeBroadcastShareId()
      self.params.set('broadcast', id)

      // update URL
      const { pathname, hash } = window.location
      const uri = pathname + '?' + self.params.toString() + hash
      window.history.replaceState(uri, '', uri)
      self.createBroadcastLink()
    })
    this.peer.on('disconnected', function () {
      document.body.classList.remove('broadcast__is-live')
    })
    this.peer.on('error', function (err) {
      self.signalPeerError(err)
      if (err.type === 'unavailable-id' || err.type === 'invalid-id') {
        BroadcastSlides.clearCookies()
        self.broadcastShareId = null
      }
      self.removeBroadCastButton()
      self.createBroadcastButton()
    })
    this.peer.on('connection', function (conn) {
      console.log(`New peer connected with id ${conn.peer}`)

      self.updateWatchers(1)

      conn.on('close', function () {
        self.updateWatchers(-1)
      })

      slideshow.on('showSlide', function (slide) {
      // console.log(`sending slide change to ${slide.getSlideIndex()}`)
        conn.send({ index: slide.getSlideIndex() })
      })

      const currentIndex = slideshow.getCurrentSlideIndex()
      // console.log(`sending current slide index ${currentIndex}`)
      setTimeout(function () { conn.send({ index: currentIndex }) }, 1000)
    })
  }

  startFollowing () {
    this.connectPeerjs()
    const self = this
    let needsNotified = true
    this.peer.on('open', function (id) {
      console.log(`peerjs connected with id ${id}`)
      self.isLive = true
      document.body.classList.add('broadcast__is-live')

      // listen for slide changes
      console.log(`peerjs connecting to ${self.broadcastFollowId}`)
      const conn = self.peer.connect(self.broadcastFollowId)

      conn.on('open', function () {
        conn.on('data', function (data) {
          // console.log(data)
          if (needsNotified) {
            needsNotified = false
            toast.success("You're following the broadcast!")
          }
          slideshow.gotoSlide(data.index + 1)
        })
      })

      conn.on('error', function (err) {
        self.signalPeerError(err, 'Unable to connect to broadcast')
      })

      conn.on('close', function () {
        toast.warning({
          message: 'Broadcast ended or signal was lost. Click to reload slides.',
          timeout: -1,
          onclick: function () { window.location.reload() }
        })
      })
    })

    this.peer.on('disconnected', function () {
      document.body.classList.remove('broadcast__is-live')
    })

    this.peer.on('error', self.signalPeerError)
  }

  signalPeerError (err, defaultMessage) {
    console.log(err)
    switch (err.type) {
      case 'browser-incompatible':
        toast.error('Broadcasting does not work with your browser')
        break

      case 'server-error':
      case 'network':
        toast.error('Cannot connect with PeerJS server')
        break

      case 'invalid-id':
      case 'unavailable-id':
      case 'peer-unavailable':
        toast.error('Expired or incorrect broadcast link')
        break

      default:
        toast.error(defaultMessage || 'Broadcasting failed')
    }
  }

  /*
   * Get previously used PeerID if these slides have been broadcast recently
   */
  getBroadcastShareId () {
    return Cookies.get('broadcastShareId')
  }

  storeBroadcastShareId () {
    Cookies.set('broadcastShareId', this.broadcastShareId, { expires: this.expires, sameSite: 'None', secure: true })
  }

  static clearCookies () {
    Cookies.remove('broadcastShareId')
  }

  createBroadcastButton () {
    const elTimer = document.querySelector('.remark-toolbar-timer')
    const btn = document.createElement('button')
    btn.classList = 'remark-toolbar-link remark-toolbar-broadcast'
    btn.id = 'xe-broadcast'
    btn.type = 'button'
    btn.textContent = 'Broadcast'

    elTimer.parentElement.insertBefore(btn, elTimer)

    const self = this

    btn.addEventListener('click', function () {
      btn.innerText = 'Connecting...'
      btn.setAttribute('disabled', true)
      self.startSharing()
    })
  }

  removeBroadCastButton () {
    const btn = document.getElementById('xe-broadcast')
    if (btn) btn.parentElement.removeChild(btn)
  }

  createBroadcastLink () {
    const { pathname, search } = window.location
    const link = document.createElement('a')
    link.classList = 'remark-toolbar-broadcast-link'
    this.broadcastLink = pathname + search
    link.href = this.broadcastLink
    link.textContent = 'Broadcast link'

    const elTimer = document.querySelector('.remark-toolbar-timer')
    this.removeBroadCastButton()
    elTimer.parentElement.insertBefore(link, elTimer)
    this.createWatchersSpan()
  }

  createWatchersSpan () {
    const elTimer = document.querySelector('.remark-toolbar-timer')
    const watchers = document.createElement('span')
    watchers.innerHTML = '(<span id="broadcast-watchers">0</span> watching)'
    elTimer.parentElement.appendChild(watchers)
  }

  updateWatchers (n) {
    this.connections = this.connections + n
    const el = document.getElementById('broadcast-watchers')
    if (!el) return
    el.innerText = this.connections
  }
}

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
    window.xeBroadcast = new BroadcastSlides()
  })
})()
