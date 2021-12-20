
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
library(data.table)


# Example data


# reading data


load("communes_Cassini3.RData")
dataset <- sort(communes_Cassini3$source)
dataset2 <- as.data.table(dataset)

# UI
ui <- fluidPage(
  # App title ----
  titlePanel("Moteur de recherche des noms anciens de communes de France"),
  sidebarLayout(
     # Input(s)
    sidebarPanel(
      selectizeInput(inputId = "commune",  
                  label = "commune",
                  choices = dataset2,
                  selected = "")
    ),
    
    # datatable output
    mainPanel(
    DT::dataTableOutput(outputId = "table_de_donnees")
    )
  )
)

# Server
server <- function(input, output, session) {
  updateSelectizeInput(session = session, inputId = 'commune',
                       choices = c(Choose = '', dataset2), server = TRUE)
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
