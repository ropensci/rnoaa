#' Run a built-in Shiny App.
#'
#' @import shiny
#' @return Nothing, it does something.
#' @examples
#' \dontrun{
#' runShinyApp()
#' }
#' @export
runShinyApp <- function() {
    # nocov start
    appDir <- system.file("shiny-examples",
                          "myapp", package = "rnoaa")
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing `rnoaa`.",
             call. = FALSE)
    }

    shiny::runApp(appDir, display.mode = "normal")
}
# nocov end
