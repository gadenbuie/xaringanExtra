% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/broadcast.R
\name{use_broadcast}
\alias{use_broadcast}
\title{Broadcast Your Slides}
\usage{
use_broadcast()
}
\value{
An \code{htmltools::tagList()} with the HTML dependencies required for
\strong{broadcast}.
}
\description{
\href{https://lifecycle.r-lib.org/articles/stages.html}{Experimental}!
\strong{Broadcast} lets others follow along, in real time! Built with
\href{https://peerjs.com}{PeerJS}, \strong{broadcast} give you a unique URL to share
with your viewers. Then, when they load your slides, their slides will
automatically follow you as you present!
}
\details{
To equip your slides with broadcast capabilities, add the following
chunk to your slides’ \code{.Rmd} file.

\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{```\{r broadcast, echo=FALSE\}
xaringanExtra::use_broadcast()
```
}\if{html}{\out{</div>}}

Then, host your slides online, either on a personal webpage, or through
\href{https://www.netlify.com/}{Netlify}, \href{https://pages.github.com/}{GitHub Pages}, \href{https://docs.gitlab.com/ee/user/project/pages/}{GitLab Pages}, or another
service.

When you want to present, open the version of your slides hosted online
in a modern browser. Then press \if{html}{\out{<kbd>}}P\if{html}{\out{</kbd>}} to enter the presenter
view. Click on the \strong{Broadcast} button to start broadcasting.

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
\subsection{How It Works}{

PeerJS creates a direct, peer-to-peer connection between your browser
and your viewer’s browsers. A third party PeerJS server is used to
initially facilitate the connection using the broadcast ID to connect
with the presenter’s browser.

After the connection is made, data is sent directly between browsers and
the PeerJS server is no longer involved. Furthermore, at no time is any
information about your presentation transmitted over the network. When
you move to a slide, say for example slide 11, \strong{broadcast} announces
“Slide 11” to any connected viewers and JavaScript in their browser
moves their presentation to slide 11.

This has two consequences:
\enumerate{
\item Viewers can move around and look at slides other than the one
currently active in the presenter’s browser. When the presenter
changes slides, however, all viewers’ slides will move to the new
slide.
\item If your slides involve interactivity, such as
\href{https://www.htmlwidgets.org/}{htmlwidgets} or
\link{panelset}, changes made in the presenter’s view aren’t
replicated for viewers. Viewers will be taken to the same slide as
the presenter, but they will need to click on their own to follow
interactively.
}
}

\subsection{Extra Details}{

It’s worth mentioning a few details. First of all, the broadcaster needs
to be connected first before viewers connect. If a viewer connects
before the broadcaster starts (or restarts), they should reload the link
to reconnect.

Similarly, if the broadcaster reloads their slides, viewers will also
need to reload to reconnect. But once everyone is connected, a message
will appear for the viewer to prompt them to reconnect.

If you are the presenter and you load the broadcast link, the broadcast
will automatically reconnect and start broadcasting. If you want to view
your slides without broadcasting, just load the plain URL for the slides
without the \code{?broadcast=...} portion. From this view, you can restart
the broadcast from the presenter view and if the broadcast ID is still
valid that ID will be used. To reset the broadcast ID without waiting 4
hours, load your slides with \code{?broadcast=1} and new broadcast link will
be created at the next broadcast.
}
}
\examples{
use_broadcast()

}
\references{
\url{https://peerjs.com}
}
