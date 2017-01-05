library(shiny)
library(shinythemes)
library(ggplot2)
library(htmltools)
source("resources.R")

dataset <- read.csv("github.csv")

ui <- navbarPage(
  theme = shinytheme("united"),
  title = "Dynamic UI demo",
  tabPanel("App",
    wellPanel(fluidRow(
      column(4, selectInput("xvar", "X variable", names(dataset))),
      column(4, selectInput("yvar", "Y variable", names(dataset))),
      column(4, actionButton("addplot", "Add plot", class = "pull-right"))
    )),
    # This <div> will hold all of the plots we're going to
    # dynamically add. It's going to be super fun!
    div(id = "plot_container", style = css(
      display = "flex",
      flex_direction = "row",
      width = "100%"
    ))
  ),
  resources(),
  
  # Disable fading effect when processing
  tags$style(".recalculating { opacity: 1; }")
)

server <- function(input, output, session) {
  # One of the very few times you'll see me create a non-reactive
  # session-level variable, and mutate it from within an observer
  plot_count <- 0
  
  # Add a plot when addplot is clicked
  observeEvent(input$addplot, {
    plot_count <<- plot_count + 1
    
    id <- paste0("plot", plot_count)
    # Take a static snapshot of xvar/yvar; the renderPlot we're
    # creating here cares only what their values are now, not in
    # the future.
    xvar <- input$xvar
    yvar <- input$yvar
    
    output[[id]] <- renderPlot({
      df <- brushedPoints(dataset, input$brush, allRows = TRUE)
      
      ggplot(df, aes_string(xvar, yvar, color = "selected_")) +
        geom_point(alpha = 0.6) +
        scale_color_manual(values = c("black", "green")) +
        guides(color = FALSE) +
        xlab(xvar) + ylab(yvar)
    })
    insertUI("#plot_container", where = "beforeEnd",
      ui = div(style = css(position="relative", flex=1, width="100%", height="675px"),
        div(style = css(position="absolute", top=0, bottom=0, left=0, right=0),
          plotOutput(id, brush = "brush", width = "100%", height = "100%")
        )
      )
    )
  })
}

shinyApp(ui, server)
