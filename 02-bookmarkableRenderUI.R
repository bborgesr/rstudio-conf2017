library(shiny)
library(datasets)

enableBookmarking(store = "url")
shinyApp(
  ui = function(req) { 
    fluidPage(
      titlePanel('Using renderUI'),
      sidebarLayout(
        sidebarPanel(
          selectInput('data', 'Choose a dataset', c('rock', 'pressure', 'cars')),
          radioButtons('tool', 'Choose a tool', c('summary', 'plot', 'head')),
          bookmarkButton()
        ),
        mainPanel(
          uiOutput('result')
        )
      )
    )
  },
  server = function(input, output, session) {
    dataset <- reactive({ switch(input$data,
      'rock' = rock, 'pressure' = pressure, 'cars' = cars)
    })
    
    output$result <- renderUI({
      switch(input$tool,
        'summary' = verbatimTextOutput('summary'),
        'plot' = plotOutput('plot'),
        'head' = tableOutput('head'))
    })
    
    output$summary <- renderPrint({ summary(dataset()) })
    output$plot <- renderPlot({ plot(dataset()) })
    output$head <- renderTable({ head(dataset()) })
  }
)