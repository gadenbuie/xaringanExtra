## 📡 Broadcast

<div class="shareagain" style="min-width:300px;max-width:600px;margin:1em auto;"><iframe src="./broadcast/index.html" title="Broadcast Demo" width="400" height="300" loading=lazy></iframe></div>
<p align="right"><a href="./broadcast" target="_blank">Broadcast Demo<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="12px" height="12px" viewBox="0 0 12 12" style="enable-background:new 0 0 12 12;fill:currentColor;height:1em;width:1em;top:0.18em;position:relative;" xml:space="preserve"><g id="Icons" style="opacity:0.75;"><g id="external"><polygon id="box" style="fill-rule:evenodd;clip-rule:evenodd;" points="2,2 5,2 5,3 3,3 3,9 9,9 9,7 10,7 10,10 2,10   "/><polygon id="arrow_13_" style="fill-rule:evenodd;clip-rule:evenodd;" points="6.211,2 10,2 10,5.789 8.579,4.368 6.447,6.5    5.5,5.553 7.632,3.421   "/></g></g><g id="Guides" style="display:none;"></g></svg></a></p>

**Broadcast** lets others follow along, in real time\! Built with
[PeerJS](https://peerjs.com), **broadcast** give you a unique URL to
share with your viewers. Then, when they load your slides, their slides
will automatically follow you as you present\!

To equip your slides with broadcast capabilities, add the following
chunk to your slides’ `.Rmd` file.

```` markdown
```{r broadcast, echo=FALSE}
xaringanExtra::use_broadcast()
```
````

Then, host your slides online, either on a personal webpage, or through
[Netlify](https://www.netlify.com/), [GitHub
Pages](https://pages.github.com/), [GitLab
Pages](https://docs.gitlab.com/ee/user/project/pages/), or another
service.

When you want to present, open the version of your slides hosted online
in a modern browser. Then press <kbd>P</kbd> to enter the presenter
view. Click on the **Broadcast** button to start broadcasting.

![](figures/broadcast.png)

After a short moment, if everything works, the broadcast button will
turn into a broadcast link. Share this link with your audience. When
they open the link, their browser will connect with yours and from then
on, whenever you advance or change slides, your viewer’s slides will
move to the current slide.

Note that the broadcast link is unique and, as the presenter, is
remembered for 4 hours. After 4 hours of inactivity, a new link will be
generated. In general, create and share the broadcast link just before
or as your event starts and certainly not more than an hour before the
presentation.

### How It Works

PeerJS creates a direct, peer-to-peer connection between your browser
and your viewer’s browsers. A third party PeerJS server is used to
initially facilitate the connection using the broadcast ID to connect
with the presenter’s browser.

After the connection is made, data is sent directly between browsers and
the PeerJS server is no longer involved. Furthermore, at no time is any
information about your presentation transmitted over the network. When
you move to a slide, say for example slide 11, **broadcast** announces
“Slide 11” to any connected viewers and JavaScript in their browser
moves their presentation to slide 11.

This has two consequences:

1.  Viewers can move around and look at slides other than the one
    currently active in the presenter’s browser. When the presenter
    changes slides, however, all viewers’ slides will move to the new
    slide.

2.  If your slides involve interactivity, such as
    [htmlwidgets](https://www.htmlwidgets.org/) or \[panelset\], changes
    made in the presenter’s view aren’t replicated for viewers. Viewers
    will be taken to the same slide as the presenter, but they will need
    to click on their own to follow interactively.

### Extra Details

It’s worth mentioning a few details. First of all, the broadcaster needs
to be connected first before viewers connect. If a viewer connects
before the broadcaster starts (or restarts), they should reload the link
to reconnect.

Similarly, if the broadcaster reloads their slides, viewers will also
need to reload to reconnect. But once everyone is connected, a message
will appear for the viewer to prompt them to reconnect.

If you are the presenter and you load the broadcast link, the broadcst
will automatically reconnect and start broadcasting. If you want to view
your slides without broadcasting, just load the plain URL for the slides
without the `?broadcast=...` portion. From this view, you can restart
the broadcast from the presenter view and if the broadcast ID is still
valid that ID will be used. To reset the broadcast ID without waiting 4
hours, load your slides with `?broadcast=1` and new broadcast link will
be created at the next
broadcast.

