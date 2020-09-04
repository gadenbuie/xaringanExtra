/* global slideshow,Peer,Cookies */
class BroadcastSlides {
  constructor () {
    this.params = new URLSearchParams(window.location.search)

    // This is the Peer ID for the current slide viewer
    this.broadcastShareId = this.getBroadcastShareId()
    // This is the Peer ID of the slides we want to follow
    this.broadcastFollowId = this.params.get('broadcast')

    this.isLive = false
    // sharing will go live immediately, start sharing or following
    const goLive = !(this.broadcastFollowId === null || this.broadcastFollowId === '')

    // we're the broadcaster (or could broadcast)
    this.isBroadcaster = this.broadcastShareId === this.broadcastFollowId || !(goLive)

    this.connections = 0
    this.broadcastLink = null

    if (this.params.get('broadcast') === null) {
      // slides loaded without ?broadcast flag
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

      self.broadcastShareId = id
      self.storeBroadcastShareId()
      self.params.set('broadcast', id)

      // update URL
      const { pathname, hash } = window.location
      const uri = pathname + '?' + self.params.toString() + hash
      window.history.replaceState(uri, '', uri)
      self.createBroadcastLink()
    })
    this.peer.on('connection', function (conn) {
      console.log(`New peer connected with id ${conn.peer}`)

      self.connections = self.connections + 1

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
    this.peer.on('open', function (id) {
      console.log(`peerjs connected with id ${id}`)
      self.isLive = true

      // listen for slide changes
      console.log(`peerjs connecting to ${self.broadcastFollowId}`)
      const conn = self.peer.connect(self.broadcastFollowId)

      conn.on('open', function () {
        conn.on('data', function (data) {
          // console.log(data)
          slideshow.gotoSlide(data.index + 1)
        })
      })
    })
  }

  /*
   * Get previously used PeerID if these slides have been broadcast recently
   */
  getBroadcastShareId () {
    return Cookies.get('broadcastShareId')
  }

  storeBroadcastShareId () {
    Cookies.set('broadcastShareId', this.broadcastShareId, { expires: 1, sameSite: 'None', secure: true })
  }

  clearCookies () {
    Cookies.remove('broadcast')
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
