
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(dplyr)
library(shiny)
library(DT)


library(brotli)
library(ggplot2)

# Example data


# reading data


load("communes_Cassini3.RData")
dataset <- sort(communes_Cassini3$source)

# UI
ui <- fluidPage(
  # App title ----
  titlePanel("mon appli"),
  sidebarLayout(
     # Input(s)
    sidebarPanel(
      selectInput(inputId = "commune",  
                  label = "commune",
                  choices = dataset,
                  selected = "")
    ),
    
    # datatable output
    mainPanel(
    DT::dataTableOutput(outputId = "table_de_donnees")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create data table
  output$table_de_donnees <- DT::renderDataTable({
    fiche_commune <- communes_Cassini3 %>%
      filter(source == input$commune) %>%
      select(insee:designation_actuelle)
    DT::datatable(data = fiche_commune, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
