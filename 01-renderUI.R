library(shiny)
library(datasets)

shinyApp(
  ui = fluidPage(
    titlePanel('Using renderUI'),
    sidebarLayout(
      sidebarPanel(
        selectInput('data', 'Choose a dataset', c('rock', 'pressure', 'cars')),
        radioButtons('tool', 'Choose a tool', c('summary', 'plot', 'head'))
      ),
      mainPanel(
        uiOutput('result')
      )
    )
  ),
  server = function(input, output, session) {
    dataset <- reactive({ switch(input$data,
      'rock' = rock, 'pressure' = pressure, 'cars' = cars)
    })
    
    output$result <- renderUI({
      if (input$tool == 'summary') verbatimTextOutput('summary')
      else if (input$tool == 'plot') plotOutput('plot')
      else if (input$tool == 'head') tableOutput('head')
    })
    
    output$summary <- renderPrint({ summary(dataset()) })
    output$plot <- renderPlot({ plot(dataset()) })
    output$head <- renderTable({ head(dataset()) })
  }
)