library(shiny)
library(ggplot2)
library(dplyr)

# user interface
ui <- fluidPage(
  titlePanel("USA Census Visualization"),
  sidebarLayout(
  sidebarPanel(
    helpText("Creat demographic maps with information from the 2010 census"),
    selectInput(inputId = "var",
                label = "Race",
                choices = list("Percent White", "Percent Black",
                               "Percent Hispanic","Percent Asian"),
                selected = "Percent White")
    ),
  mainPanel(
    plotOutput(outputId = "map")
  )
 )
)


              

# 

server <- function(input, output){
  
  output$map = renderPlot({
    counties <- reactive({
      race = readRDS("counties(1).rds")
      
      counties_map = map_data("county")
      
      counties_map = counties_map %>%
        mutate(name = paste(region, subregion, sep = ","))
      
      counties = left_join(counties_map, race, by = "name")
    })
    myrace = switch(input$var,
                    "Percent White" = counties()$white,
                    "Percent Black" = counties()$black,
                    "Percent Hispanic" = counties()$hispanic,
                    "Percent Asian" = counties()$asian)
  
  ggplot(counties(), aes(x = long, y = lat, group = group, fill = myrace)) +
    geom_polygon() +
    scale_fill_gradient(low = "white", high = "darkred") +
    theme_void()
})
}

shinyApp(ui, server)
