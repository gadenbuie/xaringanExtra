#' Create a Flashcard Component
#'
#' @param front,back The HTML content to put on the front or back of the card
#'
#' @return A `<div>` that reveals content on `back` when hovering over `front`.
#'
#' @export
flashcard <- function(front, back) {
  htmltools::tagList(
    htmltools::htmlDependency(
      name = "flashcard",
      version = "0.0.1",
      package = "xaringanExtra",
      src = "flashcard",
      stylesheet = "flashcard.css"
    ),
    htmltools::tags$div(
      htmltools::tags$div(
        class = "flashcard",
        `tabindex` = "1",
        htmltools::tags$div(
          class = "flashcard-inner",
          htmltools::tags$div(
            class = "flashcard-front",
            front
          ),
          htmltools::tags$div(
            class = "flashcard-back",
            back,
          )
        )
      )
    )
  )
}
