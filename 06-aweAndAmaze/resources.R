resources <- function(){
  navbarMenu("Resources",
    tabPanel(tags$a("rstudio::conf talk slides",
      href = "https://docs.google.com/presentation/d/1wMxhVIWsFfkCZjEJ6VlfEZpMWmiA_umOavcuwGVIQcg/edit?usp=sharing")),
    tabPanel(tags$a("rstudio::conf talk repo",
      href = "https://github.com/bborgesr/rstudio-conf2017")),
    tabPanel(tags$a("Shiny website article",
      href = "http://shiny.rstudio.com/articles/dynamic-ui.html")),
    tabPanel(tags$a("renderUI docs",
      href = "http://shiny.rstudio.com/reference/shiny/latest/renderUI.html")),
    tabPanel(tags$a("insertUI docs",
      href = "http://shiny.rstudio.com/reference/shiny/latest/insertUI.html"))
  )
}
