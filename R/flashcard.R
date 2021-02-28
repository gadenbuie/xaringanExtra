#' Create a Flashcard Component
#'
#' @param front the HTML conent to put on the front of the card
#' @param back the HTML conent to put on the back of the card
#'
#' @return a div that on hover you can switch between front and back
#' @export
flashcard <- function(front,back) {
	htmltools::tagList(
		htmltools::htmlDependency(
			name    = "flashcard"
			, version = utils::packageVersion("xaringanExtra")
			, package = "xaringanExtra"
			, src     = "inst/flashcard"
			, stylesheet = "flashcard.css"
		),

		htmltools::tags$div(
			htmltools::tags$div(class="flashcard",
        htmltools::tags$div(class="flashcard-inner",
        	htmltools::tags$div(class="flashcard-front",
        											front
        											),
        	htmltools::tags$div(class="flashcard-back",
        											back,
        											)
							 				 )
							 )
		)
	)
}
