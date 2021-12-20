#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
# Wilfrid Cariou 2018

library(dplyr)
library(shiny)
library(DT)
library(data.table)
library(bslib)


# Example data


# reading data


load("communes_Cassini3.RData")
dataset <- sort(communes_Cassini3$source)
dataset2 <- as.data.table(dataset)

# La conversion en objet data.table a pour objectif accélérer l'affichage des noms de communes dans le selectizeInput.

# UI
ui <- fluidPage(
  theme = bs_theme(version = 4, bootswatch = "minty"),
  # App title ----
  titlePanel("Moteur de recherche des noms de communes de France"),
  sidebarLayout(
    mainPanel(
    p("Moteur de recherche de noms de communes basé sur les notices communales de la base Des villages de Cassini aux communes d'aujourd'hui"),
    p("(La base constituée par la BNF, l'EHESS, le CNRS et l'INED, propose, à partir des cartes de Cassini, associées aux limites administratives actuelles, l'accès aux évolutions des toponymes, des populations et des territoires communaux. "),
    p("Auteur: Wilfrid Cariou"),
    p("Date de céation : 2018"),
     # Input(s)
    sidebarPanel(
      selectizeInput(inputId = "commune",  
                  label = "commune",
                  choices = NULL, # 
                  selected = "")
    )
    ),
    
    # datatable output
    mainPanel(
    DT::dataTableOutput(outputId = "table_de_donnees")
    )
  )
)

# performances : 
# choices = NULLcombiné avec updateSelectize(server = TRUE)
# https://shiny.rstudio.com/articles/selectize.html

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
