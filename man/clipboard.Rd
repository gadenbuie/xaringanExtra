% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clipboard.R
\name{clipboard}
\alias{clipboard}
\alias{use_clipboard}
\alias{html_dependency_clipboardjs}
\alias{html_dependency_clipboard}
\title{Clipboard}
\usage{
use_clipboard(
  button_text = "Copy Code",
  success_text = "Copied!",
  error_text = "Press Ctrl+C to Copy",
  selector = NULL,
  minified = TRUE
)

html_dependency_clipboardjs(minified = TRUE)

html_dependency_clipboard()
}
\arguments{
\item{button_text, success_text, error_text}{Text (or HTML) shown in the copy
button by default (\emph{button}), on copy \emph{success}, or in the event of an
\emph{error}.}

\item{selector}{The CSS selector used to identify the elements that will
receive the copy code button. If \code{NULL}, the extension will automatically
choose the selector for \pkg{xaringan} slides or general R Markdown.

The CSS selector should identify the parent container that holds the
content to be copied. The copy button will be added as the last element
in this container, and then the text of every element inside the container
identified by the selector, minus the copy button text, is copied to the
clipboard.}

\item{minified}{Should the minified clipboardjs dependency be used?}
}
\value{
An \code{htmltools::tagList()} with the HTML dependencies required for
\strong{clipboard}.
}
\description{
Add a "Copy Code" button for one-click code chunk copying.
}
\details{
To add \strong{clipboard} to your xaringan presentation or R Markdown
document, add the following code chunk to your slides’ R Markdown file.

\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{```\{r xaringanExtra-clipboard, echo=FALSE\}
xaringanExtra::use_clipboard()
```
}\if{html}{\out{</div>}}

You can also customize the text that is shown by default when hovering
over a code chunk with the \code{button_text} argument. Use \code{success_text} to
specify the text shown when the copy action works, or \code{error_text} for
the text shown when the copy action fails. If the copy action fails, the
text will still be selected, so the user can still manually press
\code{Ctrl+C} to copy the code chunk.

These options accept raw HTML strings, so you can achieve an icon-only
appearance using FontAwesome icons:

\if{html}{\out{<div class="sourceCode markdown">}}\preformatted{```\{r xaringanExtra-clipboard, echo=FALSE\}
htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i>",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i>",
    error_text = "<i class=\"fa fa-times-circle\" style=\"color: #F94144\"></i>"
  ),
  rmarkdown::html_dependency_font_awesome()
)
```
}\if{html}{\out{</div>}}
}
\section{Functions}{
\itemize{
\item \code{use_clipboard()}: Adds \strong{clipboard} to your xaringan slides or R
Markdown HTML output.

\item \code{html_dependency_clipboardjs()}: Returns an \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}} with the
\href{https://clipboardjs.com/}{clipboard.js} library. For expert use.

\item \code{html_dependency_clipboard()}: Returns an \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}} with the
clipboard dependencies for use in xaringan and R Markdown documents. Most
users will want to use \code{use_clipboard()} instead.

}}
\examples{
use_clipboard()

}
\references{
https://clipboardjs.com/
}
