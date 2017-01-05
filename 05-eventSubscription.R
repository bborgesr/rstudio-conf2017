library(shiny)
library(datasets)

ui <- fluidPage(
  titlePanel('Double event subscription'),
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
)

server <- function(input, output, session) {
  dataset <- reactive({ switch(input$data,
    'rock' = rock, 'pressure' = pressure, 'cars' = cars)
  })
  
  observeEvent(input$add, {
    id <- paste0(input$tool, input$add)
    rmvid <- paste0('rmv', id)
    
    insertUI('#placeholder', 
      ui = div(id = paste0('div', id),
        style = 'border: 2px solid #191919; border-radius: 5px; 
                 background: #CCCCCC; margin: 15px;',
        actionButton(rmvid, 'X', style = 'background: #ff6666; color: #fff'),
        switch(input$tool,
          'summary' = verbatimTextOutput(id),
          'plot' = plotOutput(id),
          'head' = tableOutput(id))
      )
    )
    output[[id]] <-
      if (input$tool == 'summary') renderPrint({ summary(isolate(dataset())) })
      else if (input$tool == 'plot') renderPlot({ plot(isolate(dataset())) })
      else if (input$tool == 'head') renderTable({ head(isolate(dataset())) })
    
    observeEvent(input[[rmvid]], {
      removeUI(selector = paste0('#div', id))
    }, ignoreInit = TRUE, once = TRUE)
  })
}

shinyApp(ui, server)