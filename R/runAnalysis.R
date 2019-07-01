#' Wrapper for lauching Shiny app
#'
#' @export
#'
#' @return NULL
#' @examples \dontrun{
#' runAnalysis()
#' }
runAnalysis <- function() {
  appDir <- system.file("shiny-app", "CarboLogR", package = "CarboLogR")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing CarboLogR package.", call. = FALSE)
  }
  # find and launch the app
  shiny::runApp(appDir, display.mode = "normal")
}
