library(shiny)
library(datasets)

shinyApp(
  ui = fluidPage(
    titlePanel('Using insertUI and reactivity'),
    sidebarLayout(
      sidebarPanel(
        selectInput('data', 'Choose a dataset', c('rock', 'pressure', 'cars')),
        radioButtons('tool', 'Choose a tool', c('summary', 'plot', 'head')),
        actionButton('add', 'Add result')
      ),
      mainPanel(
        div(id = 'placeholder')
      )
    )
  ),
  server = function(input, output, session) {
    dataset <- reactive({ switch(input$data,
      'rock' = rock, 'pressure' = pressure, 'cars' = cars)
    })
    
    observeEvent(input$add, {
      id <- paste0(input$tool, input$add)
      insertUI('#placeholder', 
        ui = if (input$tool == 'summary') verbatimTextOutput(id)
             else if (input$tool == 'plot') plotOutput(id)
             else if (input$tool == 'head') tableOutput(id)
      )
      output[[id]] <-
        if (input$tool == 'summary') renderPrint({ summary(dataset()) })
        else if (input$tool == 'plot') renderPlot({ plot(dataset()) })
        else if (input$tool == 'head') renderTable({ head(dataset()) })
    })
  }
)